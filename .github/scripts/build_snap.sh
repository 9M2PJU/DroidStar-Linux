#!/usr/bin/env bash
# Build DroidStar-9M2PJU as a Snap package (.snap).
# Runs on the GitHub runner using snapcraft with LXD.
set -euo pipefail

SHORT_SHA="${SHORT_SHA:-unknown}"
APP_NAME="DroidStar"
APP_DISPLAY="DroidStar-9M2PJU"
VERSION="1.0.${SHORT_SHA}"
DIST="${PWD}/dist"

echo "=== Building ${APP_DISPLAY} Snap (version ${VERSION}) ==="

mkdir -p "${DIST}"

# Generate snapcraft.yaml in the source root
SNAPCRAFT_YAML="${PWD}/snap/snapcraft.yaml"
mkdir -p "$(dirname "${SNAPCRAFT_YAML}")"

cat > "${SNAPCRAFT_YAML}" <<'YAML'
name: 9m2pju-droidstar
title: DroidStar-9M2PJU
summary: Amateur radio digital modes client (9M2PJU build)
description: |
  Unofficial Linux packaging of DroidStar by 9M2PJU.
  Connects to M17, Fusion (YSF/FCS), DMR, P25, NXDN, D-STAR (REF/XRF/DCS)
  reflectors and AllStar nodes (IAX2 / Web Transceiver) over UDP.

  All credit for the original DroidStar software goes to Doug McLain AD8DP.
  Original project: https://github.com/nostar/DroidStar

version: '1.0-commit'
grade: stable
confinement: strict
base: core24
icon: images/droidstar.png

apps:
  9m2pju-droidstar:
    command: usr/bin/DroidStar
    desktop: usr/share/applications/9m2pju-droidstar.desktop
    plugs:
      - network
      - network-bind
      - audio-playback
      - audio-record
      - serial-port
      - x11
      - wayland
      - opengl
      - home

parts:
  droidstar:
    source: .
    plugin: cmake
    override-build: |
      craftctl default
      mkdir -p "${CRAFT_PART_INSTALL}/usr/share/applications"
      cat > "${CRAFT_PART_INSTALL}/usr/share/applications/9m2pju-droidstar.desktop" <<'EOF'
[Desktop Entry]
Name=DroidStar-9M2PJU
Comment=Amateur radio digital modes client (9M2PJU build)
Exec=9m2pju-droidstar
Icon=/usr/share/icons/hicolor/256x256/apps/9m2pju-droidstar.png
Terminal=false
Type=Application
Categories=HamRadio;Network;Audio;
EOF
      mkdir -p "${CRAFT_PART_INSTALL}/usr/share/icons/hicolor/256x256/apps"
      cp images/droidstar.png "${CRAFT_PART_INSTALL}/usr/share/icons/hicolor/256x256/apps/9m2pju-droidstar.png"
    cmake-parameters:
      - -DCMAKE_BUILD_TYPE=Release
      - -DCMAKE_INSTALL_PREFIX=/usr
      - -DCMAKE_PREFIX_PATH=/snap/kde-qt6-core24-sdk/current/usr
      - -DSKIP_QT_DEPLOY=ON
    build-environment:
      - CMAKE_PREFIX_PATH: /snap/kde-qt6-core24-sdk/current/usr
      - PATH: /snap/kde-qt6-core24-sdk/current/usr/bin:${PATH}
      - PKG_CONFIG_PATH: /snap/kde-qt6-core24-sdk/current/usr/lib/${CRAFT_ARCH_TRIPLET_BUILD_FOR}/pkgconfig
      - LD_LIBRARY_PATH: /snap/kde-qt6-core24-sdk/current/usr/lib/${CRAFT_ARCH_TRIPLET_BUILD_FOR}
    build-packages:
      - build-essential
      - cmake
      - git
      - pkg-config
      - libglib2.0-dev
      - libgl-dev
      - libvulkan-dev
      - libxkbcommon-dev
      - libegl-dev
      - libfontconfig1-dev
      - libfreetype-dev
      - libharfbuzz-dev
      - libpulse-dev
      - libasound2-dev
      - libavcodec-dev
      - libavformat-dev
      - libavutil-dev
      - libswresample-dev
      - libswscale-dev
      - libproxy1v5
      - libproxy-dev
      - libcurl4
      - libxml2-dev
      - libsqlite3-dev
    build-snaps:
      - kde-qt6-core24-sdk
    stage-packages:
      - libqt6core6t64
      - libqt6gui6
      - libqt6multimedia6
      - libqt6network6
      - libqt6qml6
      - libqt6quick6
      - libqt6quickcontrols2-6
      - libqt6serialport6
      - libgl1
      - qml6-module-qtquick
      - qml6-module-qtquick-controls
      - qml6-module-qtquick-layouts
      - qml6-module-qtquick-window
      - qml6-module-qtquick-templates
      - qml6-module-qtquick-shapes
      - qml6-module-qtquick-dialogs
      - qml6-module-qtcore
      - qml6-module-qtmultimedia
      - qml6-module-qtqml
      - qml6-module-qtqml-models
      - qml6-module-qtqml-workerscript
      - qml6-module-qt-labs-settings
      - qml6-module-qt-labs-folderlistmodel
      - qt6-qpa-plugins
YAML

# Patch the version into snapcraft.yaml
sed -i "s/version: '1.0-commit'/version: '${VERSION}'/" "${SNAPCRAFT_YAML}"

echo "=== snapcraft.yaml written to ${SNAPCRAFT_YAML} ==="

# Build the snap using snapcraft (uses LXD to build in core24 base)
cd "${PWD}"
snapcraft --verbose 2>&1 || {
  echo "snapcraft build failed"
  exit 1
}

# Move the snap to dist
mkdir -p "${DIST}"
mv *.snap "${DIST}/" 2>/dev/null || true
SNAP_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}.snap"
for f in "${DIST}"/*.snap; do
  base=$(basename "$f")
  if [ "$base" != "$(basename "${SNAP_FILE}")" ]; then
    mv "$f" "${SNAP_FILE}"
  fi
done

echo "=== Dist contents ==="
ls -lh "${DIST}"
echo "=== Done building ${APP_DISPLAY} Snap ==="
