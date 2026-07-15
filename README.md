# DroidStar-9M2PJU

**Unofficial Linux packaging of DroidStar by 9M2PJU**

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-9M2PJU-orange?style=for-the-badge&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/9m2pju)

This is an unofficial Linux build and packaging of [DroidStar](https://github.com/nostar/DroidStar), the amateur radio digital modes client by Doug McLain AD8DP. All credit for the original software goes to the original author. This repository adds automated CI/CD builds for Linux on both **amd64** and **arm64** architectures, producing multiple package formats for easy installation across distributions.

## About DroidStar

DroidStar connects to M17, Fusion (YSF/FCS, DN and VW modes), DMR, P25, NXDN, D-STAR (REF/XRF/DCS) reflectors and AllStar nodes (IAX2 client or Web Transceiver mode) over UDP. It is compatible with AMBE USB devices (ThumbDV, DVstick 30, DVSI, etc) and supports MMDVM modems for use as a hotspot or stand-alone transceiver.

The software is built with Qt6 and runs on Linux, Windows, macOS, Android, and iOS.

## Download Pre-built Packages

Pre-built packages are automatically generated on every push to `main` and published as GitHub Releases. See the [Releases page](../../releases) for the latest build.

### Available Package Formats

| Format | Architectures | Target Distribution |
|--------|--------------|---------------------|
| `.deb` | amd64, arm64 | Debian, Ubuntu, Mint, etc |
| `.rpm` | amd64, arm64 | Fedora, RHEL, openSUSE, etc |
| `.pkg.tar.zst` | x86_64, aarch64 | Arch Linux, Manjaro, etc |
| `.AppImage` | amd64, arm64 | Any Linux (portable, no install) |
| `.flatpak` | x86_64 | Any Linux with Flatpak |
| `.snap` | x86_64 | Any Linux with Snap |
| `.tar.gz` | amd64, arm64 | Portable tarball |

### Installation

**Debian/Ubuntu (.deb):**
```bash
sudo apt install ./DroidStar-9M2PJU-*-amd64.deb
# or for arm64:
sudo apt install ./DroidStar-9M2PJU-*-arm64.deb
```

**Fedora/RHEL (.rpm):**
```bash
sudo dnf install ./DroidStar-9M2PJU-*.x86_64.rpm
# or for arm64:
sudo dnf install ./DroidStar-9M2PJU-*.aarch64.rpm
```

**Arch Linux (.pkg.tar.zst):**
```bash
sudo pacman -U DroidStar-9M2PJU-*-x86_64.pkg.tar.zst
# or for arm64:
sudo pacman -U DroidStar-9M2PJU-*-aarch64.pkg.tar.zst
```

**AppImage (portable):**
```bash
chmod +x DroidStar-9M2PJU-*.AppImage
./DroidStar-9M2PJU-*.AppImage
```

**Flatpak:**
```bash
flatpak install --user ./DroidStar-9M2PJU-*.flatpak
flatpak run org.dudetronics.DroidStar9M2PJU
```

**Snap:**
```bash
sudo snap install --dangerous DroidStar-9M2PJU-*.snap
snap run droidstar-9m2pju
```

## Usage

Linux users with USB AMBE and/or MMDVM dongles will need to make sure they have permission to use the USB serial device, and disable the ModemManager service. On most systems this means adding your user to the `dialout` group:

```bash
sudo usermod -aG dialout $USER
sudo systemctl disable ModemManager.service
```

Reboot after making these changes.

### Main Controls

- **Host/Mod**: Select the desired host and module (for D-STAR and M17)
- **Callsign**: Enter your amateur radio callsign (valid license required)
- **DMRID**: A valid DMR ID is required to connect to DMR servers
- **Latitude/Longitude/Location/Description**: DMR config options sent to the DMR server during connect
- **Talkgroup**: For DMR, enter the talkgroup ID number
- **MYCALL/URCALL/RPTR1/RPTR2**: For D-STAR modes REF/DCS/XRF

## Building from Source

### Requirements

- Qt 6.5 or newer (Qt 6.8.3 on Ubuntu 25.04)
- CMake
- C++ compiler with C++17 support

### Build Dependencies (Ubuntu 25.04)

```bash
sudo apt install build-essential cmake git \
  qt6-base-dev qt6-base-private-dev qt6-declarative-dev \
  qt6-multimedia-dev qt6-serialport-dev qt6-shadertools-dev
```

### Build

```bash
git clone https://github.com/9M2PJU/DroidStar-Linux.git
cd DroidStar-Linux
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
make -j$(nproc)
sudo make install
```

### md380_vocoder (ARM only)

The `md380_vocoder` library contains 32-bit ARM firmware objects and can only be linked on 32-bit ARM platforms. It is disabled by default and controlled by the `USE_MD380_VOCODER` CMake option:

```bash
cmake .. -DUSE_MD380_VOCODER=ON
```

You must ensure that you are not in violation of any patent laws in your area if you decide to use this.

## CI/CD Pipeline

This repository includes a GitHub Actions workflow (`.github/workflows/build.yml`) that automatically builds and publishes packages on every push to `main`:

1. **deb/rpm/AppImage/tarball** - Built in `ubuntu:25.04` Docker containers on native amd64 and arm64 GitHub runners (Qt 6.8.3)
2. **Arch Linux pkg** - Built in `archlinux:latest` Docker containers on native x86_64 and aarch64 runners
3. **Flatpak** - Built on the runner using `flatpak-builder` with the `org.kde.Sdk//6.8` runtime
4. **Snap** - Built on the runner using `snapcraft`

All artifacts are collected and published as a GitHub Release tagged `DroidStar-9M2PJU-<commit-sha>`.

## Credits

- **Original DroidStar software**: Doug McLain AD8DP - [https://github.com/nostar/DroidStar](https://github.com/nostar/DroidStar)
- **Linux packaging and CI/CD**: 9M2PJU

This is an unofficial Linux packaging. The original project is an open source project for educational and development purposes. No support is provided for any build.

## License

The original DroidStar software is open source. See the source repository for license details.
