#!/usr/bin/env bash
# Build DroidStar-9M2PJU and package as .deb, .rpm, .AppImage, and a portable tarball.
# Runs inside an ubuntu:25.04 container (Qt 6.8.3) for both amd64 and arm64.
set -euo pipefail

ARCH="${ARCH:-$(dpkg --print-architecture)}"
SHORT_SHA="${SHORT_SHA:-unknown}"
PKG_NAME="droidstar-9m2pju"
APP_NAME="DroidStar"
APP_DISPLAY="DroidStar-9M2PJU"
VERSION="1.0.${SHORT_SHA}"
INSTALL_PREFIX="/usr"
DIST="/src/dist"

echo "=== Building ${APP_DISPLAY} for ${ARCH} (version ${VERSION}) ==="

export DEBIAN_FRONTEND=noninteractive

echo "=== Installing build dependencies ==="

# ports.ubuntu.com is flaky from GitHub Actions ARM64 runners.
# Ubuntu 24.04+ uses deb822 format (/etc/apt/sources.list.d/ubuntu.sources)
# not the old .list format. We must handle both.
switch_mirror() {
  local new_mirror="$1"
  echo "=== Switching mirror to: ${new_mirror} ==="
  # Old format: /etc/apt/sources.list and *.list files
  sed -i "s|http://[^ ]*ubuntu-ports|${new_mirror}|g" \
    /etc/apt/sources.list 2>/dev/null || true
  sed -i "s|http://[^ ]*ubuntu-ports|${new_mirror}|g" \
    /etc/apt/sources.list.d/*.list 2>/dev/null || true
  # New deb822 format: *.sources files (URIs: http://...)
  sed -i "s|http://[^ ]*ubuntu-ports|${new_mirror}|g" \
    /etc/apt/sources.list.d/*.sources 2>/dev/null || true
}

if [ "$(dpkg --print-architecture)" = "arm64" ]; then
  switch_mirror "http://de.ports.ubuntu.com/ubuntu-ports"
fi

# apt-get update returns exit 0 even when all fetches fail (treats them as warnings).
# We must actually verify that package indexes were downloaded.
apt_update_retry() {
  local mirrors=(
    "http://de.ports.ubuntu.com/ubuntu-ports"
    "http://ports.ubuntu.com/ubuntu-ports"
    "http://ftp.ports.ubuntu.com/ubuntu-ports"
    "http://mirror.freedif.org/ports.ubuntu.com/ubuntu-ports"
    "http://us.ports.ubuntu.com/ubuntu-ports"
  )
  local mirror_idx=0
  for attempt in 1 2 3 4 5 6 7 8 9 10; do
    echo "=== apt-get update attempt ${attempt}/10 ==="
    apt-get update 2>&1 || true
    # Verify that at least the main index was actually fetched
    if apt-cache show build-essential >/dev/null 2>&1; then
      echo "=== apt-get update succeeded (build-essential is available) ==="
      return 0
    fi
    echo "=== apt-get update did not fetch indexes properly ==="
    # Try next mirror
    mirror_idx=$(( mirror_idx + 1 ))
    if [ ${mirror_idx} -ge ${#mirrors[@]} ]; then
      mirror_idx=0
    fi
    switch_mirror "${mirrors[$mirror_idx]}"
    sleep 5
  done
  echo "=== FATAL: apt-get update failed after 10 attempts ==="
  return 1
}

apt_update_retry || exit 1

# Retry apt-get install too (mirror might recover mid-download)
apt_install_retry() {
  local pkg_attempt
  for pkg_attempt in 1 2 3; do
    echo "=== apt-get install attempt ${pkg_attempt}/3 ==="
    if apt-get install -y --no-install-recommends "$@"; then
      return 0
    fi
    echo "=== apt-get install failed, retrying after apt-get update ==="
    apt-get update 2>&1 || true
    sleep 5
  done
  echo "=== FATAL: apt-get install failed after 3 attempts ==="
  return 1
}

apt_install_retry \
  build-essential cmake git ca-certificates file \
  qt6-base-dev qt6-base-private-dev qt6-declarative-dev qt6-multimedia-dev \
  qt6-serialport-dev qt6-shadertools-dev qt6-base-dev-tools qt6-declarative-dev-tools || exit 1

# Packaging tools: dpkg-dev (deb), rpm + alien (rpm), wget + libfuse2 (AppImage),
# libarchive-tools (bsdtar) + zstd (Arch .pkg.tar.zst)
apt_install_retry dpkg-dev rpm alien wget || exit 1
apt-get install -y --no-install-recommends libfuse2t64 || apt-get install -y --no-install-recommends libfuse2 || true
apt_install_retry libarchive-tools zstd || exit 1

# Fix git dubious ownership in container
git config --global --add safe.directory /src || true

echo "=== Configuring with CMake ==="
cmake -B build -S . \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"

echo "=== Building ==="
cmake --build build -j"$(nproc)"

echo "=== Staging install tree ==="
STAGE_ROOT="/src/stage"
rm -rf "${STAGE_ROOT}"
DESTDIR="${STAGE_ROOT}" cmake --install build --prefix "${INSTALL_PREFIX}"
ls -lhR "${STAGE_ROOT}"

mkdir -p "${DIST}"

# ---------------------------------------------------------------------------
# 1) Portable tarball
# ---------------------------------------------------------------------------
echo "=== Building portable tarball ==="
PORTABLE_DIR="${DIST}/${APP_NAME}-${ARCH}"
rm -rf "${PORTABLE_DIR}"
mkdir -p "${PORTABLE_DIR}/bin"
cp build/${APP_NAME} "${PORTABLE_DIR}/bin/"
cat > "${PORTABLE_DIR}/${APP_DISPLAY}.sh" <<EOF
#!/usr/bin/env bash
DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"
export QT_PLUGIN_PATH="\${DIR}/plugins:\${QT_PLUGIN_PATH}"
export QML2_IMPORT_PATH="\${DIR}/qml:\${QML2_IMPORT_PATH}"
exec "\${DIR}/bin/${APP_NAME}" "\$@"
EOF
chmod +x "${PORTABLE_DIR}/${APP_DISPLAY}.sh"
tar czf "${DIST}/${APP_NAME}-9M2PJU-${ARCH}.tar.gz" -C "${DIST}" "${APP_NAME}-${ARCH}"
rm -rf "${PORTABLE_DIR}"

# ---------------------------------------------------------------------------
# 2) .deb package
# ---------------------------------------------------------------------------
echo "=== Building .deb ==="
DEBROOT="${DIST}/deb-root"
rm -rf "${DEBROOT}"
mkdir -p "${DEBROOT}"
cp -a "${STAGE_ROOT}/." "${DEBROOT}/"
mkdir -p "${DEBROOT}/DEBIAN"

INSTALLED_SIZE=$(du -sk "${DEBROOT}/usr" | cut -f1)

cat > "${DEBROOT}/DEBIAN/control" <<EOF
Package: ${PKG_NAME}
Version: ${VERSION}
Section: hamradio
Priority: optional
Architecture: ${ARCH}
Depends: libqt6core6t64, libqt6gui6, libqt6multimedia6, libqt6network6, libqt6qml6, libqt6quick6, libqt6quickcontrols2-6, libqt6serialport6, libgl1, libc6
Maintainer: 9M2PJU <9M2PJU@users.noreply.github.com>
Installed-Size: ${INSTALLED_SIZE}
Description: ${APP_DISPLAY} - amateur radio digital modes client
 Unofficial Linux packaging of DroidStar by 9M2PJU.
 Connects to M17, Fusion (YSF/FCS), DMR, P25, NXDN, D-STAR (REF/XRF/DCS)
 reflectors and AllStar nodes (IAX2 / Web Transceiver) over UDP.
 .
 All credit for the original DroidStar software goes to Doug McLain AD8DP.
 Original project: https://github.com/nostar/DroidStar
EOF

# Desktop entry + icon
mkdir -p "${DEBROOT}/usr/share/applications"
cat > "${DEBROOT}/usr/share/applications/${PKG_NAME}.desktop" <<EOF
[Desktop Entry]
Name=${APP_DISPLAY}
Comment=Amateur radio digital modes client (9M2PJU build)
Exec=${INSTALL_PREFIX}/bin/${APP_NAME}
Icon=${PKG_NAME}
Terminal=false
Type=Application
Categories=HamRadio;Network;Audio;
EOF

if [ -f /src/images/droidstar.png ]; then
  mkdir -p "${DEBROOT}/usr/share/icons/hicolor/256x256/apps"
  cp /src/images/droidstar.png "${DEBROOT}/usr/share/icons/hicolor/256x256/apps/${PKG_NAME}.png"
fi

cat > "${DEBROOT}/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications || true
fi
exit 0
EOF
chmod 755 "${DEBROOT}/DEBIAN/postinst"

DEB_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}-${ARCH}.deb"
dpkg-deb --build --root-owner-group "${DEBROOT}" "${DEB_FILE}"
rm -rf "${DEBROOT}"

# ---------------------------------------------------------------------------
# 3) .rpm package (convert .deb via alien)
# ---------------------------------------------------------------------------
echo "=== Building .rpm ==="
RPM_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}-${ARCH}.rpm"
# alien generates the rpm in the current working directory
cd "${DIST}"
alien -r -k -v "${DEB_FILE}" --scripts || {
  echo "alien rpm conversion failed; rpm package not produced."
}
# Find and rename the alien-generated rpm
find "${DIST}" -maxdepth 1 -name "*.rpm" ! -name "$(basename "${RPM_FILE}")" -exec mv {} "${RPM_FILE}" \; 2>/dev/null || true
cd /src

# ---------------------------------------------------------------------------
# 4) .pkg.tar.zst (Arch Linux package)
# ---------------------------------------------------------------------------
echo "=== Building .pkg.tar.zst ==="
ARCH_PKG_NAME="${ARCH}"
case "${ARCH}" in
  amd64)  ARCH_PKG_NAME="x86_64" ;;
  arm64)  ARCH_PKG_NAME="aarch64" ;;
esac

PKGROOT="${DIST}/pkg-root"
rm -rf "${PKGROOT}"
mkdir -p "${PKGROOT}"
cp -a "${STAGE_ROOT}/." "${PKGROOT}/"

# Desktop entry + icon
mkdir -p "${PKGROOT}/usr/share/applications"
cat > "${PKGROOT}/usr/share/applications/${PKG_NAME}.desktop" <<EOF
[Desktop Entry]
Name=${APP_DISPLAY}
Comment=Amateur radio digital modes client (9M2PJU build)
Exec=${INSTALL_PREFIX}/bin/${APP_NAME}
Icon=${PKG_NAME}
Terminal=false
Type=Application
Categories=HamRadio;Network;Audio;
EOF

if [ -f /src/images/droidstar.png ]; then
  mkdir -p "${PKGROOT}/usr/share/icons/hicolor/256x256/apps"
  cp /src/images/droidstar.png "${PKGROOT}/usr/share/icons/hicolor/256x256/apps/${PKG_NAME}.png"
fi

cat > "${PKGROOT}/.PKGINFO" <<EOF
pkgname = ${PKG_NAME}
pkgver = ${VERSION}
pkgrel = 1
pkgdesc = ${APP_DISPLAY} - amateur radio digital modes client
url = https://github.com/9M2PJU/DroidStar-Linux
builddate = $(date +%s)
packager = 9M2PJU <9M2PJU@users.noreply.github.com>
size = $(du -sk "${PKGROOT}" | cut -f1)
arch = ${ARCH_PKG_NAME}
license = GPL-3.0-or-later
depend = qt6-base
depend = qt6-declarative
depend = qt6-multimedia
depend = qt6-serialport
depend = qt6-shadertools
depend = hicolor-icon-theme
EOF

cat > "${PKGROOT}/.INSTALL" <<'EOF'
post_install() {
  update-desktop-database -q /usr/share/applications 2>/dev/null || true
  gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor 2>/dev/null || true
}
post_upgrade() {
  post_install
}
EOF

PKG_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}-${ARCH_PKG_NAME}.pkg.tar.zst"
cd "${DIST}"
bsdtar -czf - --format=ustar --uid 0 --gid 0 -C "${PKGROOT}" .PKGINFO .INSTALL $(ls -A "${PKGROOT}" | grep -v -E '^\.PKGINFO$|^\.INSTALL$') | zstd -q -o "$(basename "${PKG_FILE}")"
cd /src
rm -rf "${PKGROOT}"

# ---------------------------------------------------------------------------
# 5) .AppImage staging (the actual AppImage is built on the runner, not in
#    the container, because appimagetool needs FUSE which is unavailable in
#    Docker. We just prepare the AppDir here.)
# ---------------------------------------------------------------------------
echo "=== Preparing AppImage AppDir ==="
APPDIR="${DIST}/AppDir"
rm -rf "${APPDIR}"
mkdir -p "${APPDIR}/usr/bin" "${APPDIR}/usr/lib" "${APPDIR}/usr/share/applications" "${APPDIR}/usr/share/icons/hicolor/256x256/apps"

cp build/${APP_NAME} "${APPDIR}/usr/bin/"
cat > "${APPDIR}/usr/share/applications/${PKG_NAME}.desktop" <<EOF
[Desktop Entry]
Name=${APP_DISPLAY}
Comment=Amateur radio digital modes client (9M2PJU build)
Exec=${APP_NAME}
Icon=${PKG_NAME}
Terminal=false
Type=Application
Categories=HamRadio;Network;Audio;
EOF
if [ -f /src/images/droidstar.png ]; then
  cp /src/images/droidstar.png "${APPDIR}/usr/share/icons/hicolor/256x256/apps/${PKG_NAME}.png"
  cp /src/images/droidstar.png "${APPDIR}/${PKG_NAME}.png"
fi

# Bundle Qt6 shared libraries and QML plugins into AppDir
# (linuxdeploy on the runner can't strip Ubuntu 25.04 libs, so we bundle here)
# Exclude system libraries (libc, libm, libstdc++, libgcc_s, ld-linux, etc.)
# that must come from the host system to avoid glibc version conflicts.
echo "=== Bundling Qt6 libraries into AppDir ==="
LDD_LIBS=$(ldd "${APPDIR}/usr/bin/${APP_NAME}" | awk '{print $3}' | grep -v '^$' | sort -u)
for lib in ${LDD_LIBS}; do
  libname=$(basename "${lib}")
  # Skip only the most fundamental system libraries that must match the host glibc/kernel
  case "${libname}" in
    libc.so.*|libm.so.*|libdl.so.*|libpthread.so.*|librt.so.*|libresolv.so.*|\
    libstdc++.so.*|libgcc_s.so.*|ld-linux*|libmvec.so.*)
      echo "Skipping system library: ${libname}"
      continue
      ;;
  esac
  if [ -f "${lib}" ]; then
    echo "Bundling: ${libname}"
    cp --preserve=links "${lib}" "${APPDIR}/usr/lib/" 2>/dev/null || true
  fi
done

# Copy Qt6 plugins (platforms, imageformats, etc)
QT_PLUGIN_DIR=$(find /usr/lib -type d -name "plugins" -path "*qt6*" 2>/dev/null | head -1)
if [ -n "${QT_PLUGIN_DIR}" ]; then
  mkdir -p "${APPDIR}/usr/plugins"
  cp -a "${QT_PLUGIN_DIR}/." "${APPDIR}/usr/plugins/"
fi

# Copy Qt6 QML modules
QML_DIR=$(find /usr/lib -type d -name "qml" -path "*qt6*" 2>/dev/null | head -1)
if [ -n "${QML_DIR}" ]; then
  mkdir -p "${APPDIR}/usr/qml"
  cp -a "${QML_DIR}/." "${APPDIR}/usr/qml/"
fi

# Bundle dependencies of Qt plugins and QML modules (not just the main binary)
echo "=== Bundling Qt plugin/QML dependencies ==="
find "${APPDIR}/usr/plugins" "${APPDIR}/usr/qml" -type f -name "*.so" -exec ldd {} \; 2>/dev/null \
  | awk '{print $3}' | grep -v '^$' | sort -u | while read -r lib; do
  libname=$(basename "${lib}")
  case "${libname}" in
    libc.so.*|libm.so.*|libdl.so.*|libpthread.so.*|librt.so.*|libresolv.so.*|\
    libstdc++.so.*|libgcc_s.so.*|ld-linux*|libmvec.so.*)
      continue
      ;;
  esac
  if [ -f "${lib}" ] && [ ! -f "${APPDIR}/usr/lib/${libname}" ]; then
    echo "Bundling plugin dep: ${libname}"
    cp --preserve=links "${lib}" "${APPDIR}/usr/lib/" 2>/dev/null || true
  fi
done

# Create AppRun script at AppDir root
cat > "${APPDIR}/AppRun" <<'RUNEOF'
#!/usr/bin/env bash
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${HERE}/usr/lib/x86_64-linux-gnu:${HERE}/usr/lib/aarch64-linux-gnu:${LD_LIBRARY_PATH}"
export QT_PLUGIN_PATH="${HERE}/usr/plugins:${QT_PLUGIN_PATH}"
export QML2_IMPORT_PATH="${HERE}/usr/qml:${QML2_IMPORT_PATH}"
export QT_QPA_PLATFORM_PLUGIN_PATH="${HERE}/usr/plugins/platforms:${QT_QPA_PLATFORM_PLUGIN_PATH}"
exec "${HERE}/usr/bin/DroidStar" "$@"
RUNEOF
chmod +x "${APPDIR}/AppRun"

# Tar up the AppDir so the runner can build the AppImage outside the container
tar czf "${DIST}/${APP_NAME}-9M2PJU-${ARCH}-AppDir.tar.gz" -C "${DIST}" AppDir
rm -rf "${APPDIR}"

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------
rm -rf "${STAGE_ROOT}"

echo "=== Dist contents ==="
ls -lh "${DIST}"

# Fix permissions so the runner (non-root) can write to dist/ for AppImage build
chmod -R 777 "${DIST}" 2>/dev/null || true

echo "=== Done building ${APP_DISPLAY} for ${ARCH} ==="
