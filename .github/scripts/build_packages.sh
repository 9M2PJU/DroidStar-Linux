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
apt-get update -qq
apt-get install -y --no-install-recommends \
  build-essential cmake git ca-certificates file \
  qt6-base-dev qt6-base-private-dev qt6-declarative-dev qt6-multimedia-dev \
  qt6-serialport-dev qt6-shadertools-dev qt6-base-dev-tools qt6-declarative-dev-tools

# Packaging tools: dpkg-dev (deb), rpm + alien (rpm), wget + libfuse2 (AppImage)
apt-get install -y --no-install-recommends dpkg-dev rpm alien wget
apt-get install -y --no-install-recommends libfuse2t64 || apt-get install -y --no-install-recommends libfuse2 || true

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
# 4) .AppImage staging (the actual AppImage is built on the runner, not in
#    the container, because appimagetool needs FUSE which is unavailable in
#    Docker. We just prepare the AppDir here.)
# ---------------------------------------------------------------------------
echo "=== Preparing AppImage AppDir ==="
APPDIR="${DIST}/AppDir"
rm -rf "${APPDIR}"
mkdir -p "${APPDIR}/usr/bin" "${APPDIR}/usr/share/applications" "${APPDIR}/usr/share/icons/hicolor/256x256/apps"

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
# Tar up the AppDir so the runner can build the AppImage outside the container
tar czf "${DIST}/${APP_NAME}-9M2PJU-${ARCH}-AppDir.tar.gz" -C "${DIST}" AppDir
rm -rf "${APPDIR}"

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------
rm -rf "${STAGE_ROOT}"

echo "=== Dist contents ==="
ls -lh "${DIST}"

echo "=== Done building ${APP_DISPLAY} for ${ARCH} ==="
