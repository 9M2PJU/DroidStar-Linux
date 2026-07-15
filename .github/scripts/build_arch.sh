#!/usr/bin/env bash
# Build DroidStar-9M2PJU as an Arch Linux package (.pkg.tar.zst).
# Runs inside an archlinux:latest container for both amd64 and arm64.
set -euo pipefail

ARCH="${ARCH:-$(uname -m)}"
SHORT_SHA="${SHORT_SHA:-unknown}"
PKG_NAME="droidstar-9m2pju"
APP_NAME="DroidStar"
APP_DISPLAY="DroidStar-9M2PJU"
VERSION="1.0.${SHORT_SHA}"
DIST="/src/dist"

echo "=== Building ${APP_DISPLAY} Arch Linux package for ${ARCH} (version ${VERSION}) ==="

# Fix git dubious ownership in container
git config --global --add safe.directory /src || true

echo "=== Installing build dependencies ==="
pacman -Syu --noconfirm --needed \
  base-devel cmake git qt6-base qt6-declarative qt6-multimedia qt6-serialport \
  qt6-shadertools

echo "=== Configuring with CMake ==="
cmake -B build -S . \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr

echo "=== Building ==="
cmake --build build -j"$(nproc)"

echo "=== Staging install tree ==="
STAGE_ROOT="/src/stage"
rm -rf "${STAGE_ROOT}"
DESTDIR="${STAGE_ROOT}" cmake --install build --prefix /usr

mkdir -p "${DIST}"

# Desktop entry + icon
mkdir -p "${STAGE_ROOT}/usr/share/applications"
cat > "${STAGE_ROOT}/usr/share/applications/${PKG_NAME}.desktop" <<EOF
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
  mkdir -p "${STAGE_ROOT}/usr/share/icons/hicolor/256x256/apps"
  cp /src/images/droidstar.png "${STAGE_ROOT}/usr/share/icons/hicolor/256x256/apps/${PKG_NAME}.png"
fi

echo "=== Building .pkg.tar.zst ==="
# Create a simple PKGBUILD-style package using makepkg
PKGROOT="${DIST}/pkg-root"
rm -rf "${PKGROOT}"
mkdir -p "${PKGROOT}"

# Copy staged tree into package root
cp -a "${STAGE_ROOT}/." "${PKGROOT}/"

# Create .PKGINFO
cat > "${PKGROOT}/.PKGINFO" <<EOF
pkgname = ${PKG_NAME}
pkgver = ${VERSION}
pkgrel = 1
pkgdesc = ${APP_DISPLAY} - amateur radio digital modes client
url = https://github.com/nostar/DroidStar
builddate = $(date +%s)
packager = 9M2PJU <9M2PJU@users.noreply.github.com>
size = $(du -sk "${PKGROOT}" | cut -f1)
arch = ${ARCH}
license = GPL-3.0-or-later
depend = qt6-base
depend = qt6-declarative
depend = qt6-multimedia
depend = qt6-serialport
depend = qt6-shadertools
depend = hicolor-icon-theme
EOF

# Create .INSTALL (post-install hook for icon cache)
cat > "${PKGROOT}/.INSTALL" <<'EOF'
post_install() {
  update-desktop-database -q /usr/share/applications 2>/dev/null || true
  gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor 2>/dev/null || true
}
post_upgrade() {
  post_install
}
EOF

# Build the package
PKG_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}-${ARCH}.pkg.tar.zst"
cd "${DIST}"
# Use bsdtar to create the package, then zstd compress
bsdtar -czf - --format=ustar --uid 0 --gid 0 -C "${PKGROOT}" .PKGINFO .INSTALL $(ls -A "${PKGROOT}" | grep -v -E '^\.PKGINFO$|^\.INSTALL$') | zstd -q -o "$(basename "${PKG_FILE}")"
cd /src

rm -rf "${PKGROOT}" "${STAGE_ROOT}"

echo "=== Dist contents ==="
ls -lh "${DIST}"

echo "=== Done building ${APP_DISPLAY} Arch package for ${ARCH} ==="
