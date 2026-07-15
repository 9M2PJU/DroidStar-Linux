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
name: droidstar-9m2pju
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
  droidstar:
    command: usr/bin/DroidStar
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
    desktop: usr/share/applications/droidstar-9m2pju.desktop

parts:
  droidstar:
    source: .
    plugin: cmake
    cmake-parameters:
      - -DCMAKE_BUILD_TYPE=Release
      - -DCMAKE_INSTALL_PREFIX=/usr
    build-packages:
      - build-essential
      - cmake
      - git
      - qt6-base-dev
      - qt6-base-private-dev
      - qt6-declarative-dev
      - qt6-multimedia-dev
      - qt6-serialport-dev
      - qt6-shadertools-dev
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
      - qml6-module-qtnetwork
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

# Build the snap using snapcraft in destructive mode (no LXD needed)
cd "${PWD}"
snapcraft --verbose --destructive-mode 2>&1 || {
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
