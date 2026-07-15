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

# Download linuxdeploy and appimagetool
LINUXDEPLOY="${DIST}/linuxdeploy-${AI_ARCH}.AppImage"
APPIMAGETOOL="${DIST}/appimagetool-${AI_ARCH}.AppImage"
wget -q -O "${LINUXDEPLOY}" "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${AI_ARCH}.AppImage"
wget -q -O "${APPIMAGETOOL}" "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-${AI_ARCH}.AppImage"
chmod +x "${LINUXDEPLOY}" "${APPIMAGETOOL}"

APPIMAGE_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}-${ARCH}.AppImage"
export OUTPUT="${APPIMAGE_FILE}"
export ARCH="${AI_ARCH}"

# linuxdeploy bundles dependencies and calls appimagetool internally
"${LINUXDEPLOY}" --appdir "${APPDIR}" \
  --desktop-file "${APPDIR}/droidstar-9m2pju.desktop" \
  --icon-file "${APPDIR}/droidstar-9m2pju.png" \
  --output appimage || {
    echo "linuxdeploy --output appimage failed; trying appimagetool directly"
    "${APPIMAGETOOL}" -n "${APPDIR}" "${APPIMAGE_FILE}"
  }

rm -f "${LINUXDEPLOY}" "${APPIMAGETOOL}"
rm -rf "${APPDIR}" "${APPDIR_TAR}"

echo "=== AppImage built: $(ls -lh ${APPIMAGE_FILE}) ==="
