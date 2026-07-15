#!/usr/bin/env bash
# Build the AppImage from a pre-built AppDir tarball.
# Runs on the GitHub runner (has FUSE available), not in a container.
set -euo pipefail

ARCH="${ARCH:-amd64}"
SHORT_SHA="${SHORT_SHA:-unknown}"
APP_NAME="DroidStar"
VERSION="1.0.${SHORT_SHA}"
DIST="${PWD}/dist"

echo "=== Building AppImage for ${ARCH} (version ${VERSION}) ==="

case "${ARCH}" in
  amd64) AI_ARCH="x86_64";;
  arm64) AI_ARCH="aarch64";;
  *) AI_ARCH="${ARCH}";;
esac

APPDIR_TAR="${DIST}/${APP_NAME}-9M2PJU-${ARCH}-AppDir.tar.gz"
APPDIR="${DIST}/AppDir"

if [ ! -f "${APPDIR_TAR}" ]; then
  echo "AppDir tarball not found: ${APPDIR_TAR}"
  exit 1
fi

rm -rf "${APPDIR}"
tar xzf "${APPDIR_TAR}" -C "${DIST}"

# appimagetool expects the desktop file at the AppDir root
cp "${APPDIR}/usr/share/applications/droidstar-9m2pju.desktop" "${APPDIR}/droidstar-9m2pju.desktop"

# Download appimagetool (linuxdeploy not needed — libs are already bundled in the AppDir)
APPIMAGETOOL="${DIST}/appimagetool-${AI_ARCH}.AppImage"
wget -q -O "${APPIMAGETOOL}" "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-${AI_ARCH}.AppImage"
chmod +x "${APPIMAGETOOL}"

APPIMAGE_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}-${ARCH}.AppImage"
export ARCH="${AI_ARCH}"

# Build the AppImage directly with appimagetool
# (Qt6 libs and QML plugins are already bundled in the AppDir from the container build)
"${APPIMAGETOOL}" -n "${APPDIR}" "${APPIMAGE_FILE}" || {
  echo "appimagetool failed"
  exit 1
}

rm -f "${APPIMAGETOOL}"
rm -rf "${APPDIR}" "${APPDIR_TAR}"

echo "=== AppImage built: $(ls -lh ${APPIMAGE_FILE}) ==="
