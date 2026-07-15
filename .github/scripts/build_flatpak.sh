#!/usr/bin/env bash
# Build DroidStar-9M2PJU as a Flatpak bundle (.flatpak).
# Runs on the GitHub runner directly (needs flatpak + flatpak-builder installed).
set -euo pipefail

SHORT_SHA="${SHORT_SHA:-unknown}"
APP_NAME="DroidStar"
APP_DISPLAY="DroidStar-9M2PJU"
APP_ID="org.dudetronics.DroidStar9M2PJU"
VERSION="1.0.${SHORT_SHA}"
DIST="${PWD}/dist"

echo "=== Building ${APP_DISPLAY} Flatpak (version ${VERSION}) ==="

mkdir -p "${DIST}"

# Install flatpak and flatpak-builder if not present
if ! command -v flatpak >/dev/null 2>&1; then
  echo "flatpak not found; installing..."
  for fa_attempt in 1 2 3; do
    echo "=== apt-get install flatpak attempt ${fa_attempt}/3 ==="
    sudo apt-get update -qq && sudo apt-get install -y flatpak flatpak-builder && break
    echo "=== apt-get install failed, retrying ==="
    sleep 5
    if [ ${fa_attempt} -eq 3 ]; then
      echo "=== FATAL: Failed to install flatpak after 3 attempts ==="
      exit 1
    fi
  done
fi

# Add the flathub remote and install the KDE SDK runtime (includes Qt6)
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
for sdk_attempt in 1 2 3; do
  echo "=== flatpak install KDE SDK attempt ${sdk_attempt}/3 ==="
  flatpak install --user --noninteractive --or-update flathub org.kde.Sdk//6.8 && \
  flatpak install --user --noninteractive --or-update flathub org.kde.Platform//6.8 && break
  echo "=== flatpak install failed, retrying ==="
  sleep 5
  if [ ${sdk_attempt} -eq 3 ]; then
    echo "=== WARNING: Failed to install KDE SDK after 3 attempts ==="
  fi
done

# Generate the Flatpak manifest
MANIFEST="${PWD}/.github/flatpak/${APP_ID}.json"
mkdir -p "$(dirname "${MANIFEST}")"

cat > "${MANIFEST}" <<EOF
{
  "app-id": "${APP_ID}",
  "runtime": "org.kde.Platform",
  "runtime-version": "6.8",
  "sdk": "org.kde.Sdk",
  "command": "${APP_NAME}",
  "finish-args": [
    "--share=network",
    "--share=ipc",
    "--socket=fallback-x11",
    "--socket=wayland",
    "--socket=pulseaudio",
    "--device=all",
    "--filesystem=home"
  ],
  "modules": [
    {
      "name": "droidstar",
      "buildsystem": "cmake-ninja",
      "sources": [
        {
          "type": "dir",
          "path": "${PWD}"
        }
      ],
      "config-opts": [
        "-DCMAKE_BUILD_TYPE=Release",
        "-DCMAKE_INSTALL_PREFIX=/app",
        "-DSKIP_QT_DEPLOY=ON"
      ]
    }
  ]
}
EOF

echo "=== Flatpak manifest written to ${MANIFEST} ==="

# Build the flatpak
BUILD_DIR="${PWD}/flatpak-build"
REPO_DIR="${PWD}/flatpak-repo"
rm -rf "${BUILD_DIR}" "${REPO_DIR}"
flatpak-builder --user --repo="${REPO_DIR}" "${BUILD_DIR}" "${MANIFEST}" || {
  echo "flatpak-builder failed"
  exit 1
}

# Bundle into a .flatpak file
FLATPAK_FILE="${DIST}/${APP_NAME}-9M2PJU-${VERSION}.flatpak"
flatpak build-bundle "${REPO_DIR}" "${FLATPAK_FILE}" "${APP_ID}" || {
  echo "flatpak build-bundle failed"
  exit 1
}

rm -rf "${BUILD_DIR}"

echo "=== Dist contents ==="
ls -lh "${DIST}"
echo "=== Done building ${APP_DISPLAY} Flatpak ==="
