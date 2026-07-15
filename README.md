# DroidStar-9M2PJU

**Unofficial Linux packaging of DroidStar by 9M2PJU**

[![Build](https://img.shields.io/github/actions/workflow/status/9M2PJU/DroidStar-Linux/build.yml?style=for-the-badge&label=CI%2FCD)](../../actions)
[![Release](https://img.shields.io/github/v/release/9M2PJU/DroidStar-Linux?style=for-the-badge&label=Latest%20Release)](../../releases)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-9M2PJU-orange?style=for-the-badge&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/9m2pju)
[![Wise](https://img.shields.io/badge/Wise-Donate%209M2PJU-green?style=for-the-badge&logo=wise)](https://wise.com/pay/me/faizulz13)

---

## Table of Contents

- [About](#about)
- [Supported Modes & Hardware](#supported-modes--hardware)
- [Download](#download)
- [Installation](#installation)
  - [Debian / Ubuntu / Mint (.deb)](#debian--ubuntu--mint-deb)
  - [Fedora / RHEL / CentOS / openSUSE (.rpm)](#fedora--rhel--centos--opensuse-rpm)
  - [Arch Linux / Manjaro (.pkg.tar.zst)](#arch-linux--manjaro-pkgtarzst)
  - [AppImage (Portable — Any Linux)](#appimage-portable--any-linux)
  - [Flatpak (Any Linux with Flatpak)](#flatpak-any-linux-with-flatpak)
  - [Snap (Any Linux with Snap)](#snap-any-linux-with-snap)
  - [Portable Tarball (.tar.gz)](#portable-tarball-targz)
- [Post-Install Setup](#post-install-setup)
- [Usage](#usage)
- [Building from Source](#building-from-source)
- [CI/CD Pipeline](#cicd-pipeline)
- [Credits & License](#credits--license)

---

## About

This is an unofficial Linux build and packaging of [DroidStar](https://github.com/nostar/DroidStar), the amateur radio digital modes client by **Doug McLain AD8DP**. All credit for the original software goes to the original author.

This repository adds automated CI/CD builds for Linux on both **amd64 (x86_64)** and **arm64 (aarch64)** architectures, producing **six** package formats for easy installation across all major Linux distributions:

| Format | Architectures | Target | Install Method |
|--------|--------------|--------|----------------|
| `.deb` | amd64, arm64 | Debian, Ubuntu, Mint, Pop!_OS | `apt install` |
| `.rpm` | amd64, arm64 | Fedora, RHEL, CentOS, openSUSE | `dnf install` |
| `.pkg.tar.zst` | x86_64 | Arch Linux, Manjaro, EndeavourOS | `pacman -U` |
| `.AppImage` | amd64, arm64 | Any Linux (portable, no install) | Just run |
| `.flatpak` | x86_64 | Any Linux with Flatpak | `flatpak install` |
| `.snap` | x86_64 | Any Linux with Snap | `snap install` |
| `.tar.gz` | amd64, arm64 | Any Linux (manual extraction) | Extract & run |

---

## Supported Modes & Hardware

DroidStar connects to the following reflectors and modes over UDP:

| Mode | Networks | Notes |
|------|----------|-------|
| **M17** | M17 reflectors | Open-source digital voice protocol |
| **DMR** | Brandmeister, HBlink, etc | Requires DMR ID |
| **D-STAR** | REF, XRF, DCS reflectors | DD mode supported |
| **YSF / Fusion** | FCS, YSF reflectors | DN and VW modes |
| **P25** | P25 reflectors | P25 Phase 1 |
| **NXDN** | NXDN reflectors | NXDN digital voice |
| **AllStar** | AllStar nodes | IAX2 client or Web Transceiver mode |

**Supported hardware:**
- AMBE USB devices: ThumbDV, DVstick 30, DVSI, NW Digital Radio
- MMDVM modems (for hotspot or stand-alone transceiver use)
- Serial AMBE vocoders

The software is built with **Qt6** and runs on Linux, Windows, macOS, Android, and iOS.

---

## Download

Pre-built packages are automatically generated on every push to `main` and published as GitHub Releases.

**Latest release:** [Releases page](../../releases)

You can download packages directly from the browser, or use `wget`/`curl` from the command line. See the installation sections below for one-liner download-and-install commands.

---

## Installation

Choose the section that matches your Linux distribution.

### Debian / Ubuntu / Mint (.deb)

**Supported:** Ubuntu 24.04+, Debian 13+, Linux Mint 22+, Pop!_OS, and any Debian-based distro with Qt 6.4+.

**One-liner (amd64):**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.deb -O /tmp/droidstar.deb && sudo apt install /tmp/droidstar.deb
```

**One-liner (arm64 — Raspberry Pi 4/5, ARM servers):**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-arm64.deb -O /tmp/droidstar.deb && sudo apt install /tmp/droidstar.deb
```

**Manual steps:**
```bash
# 1. Download from the Releases page or:
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.deb

# 2. Install (apt will resolve Qt6 dependencies automatically)
sudo apt install ./DroidStar-9M2PJU-amd64.deb

# 3. Run
DroidStar
```

**Uninstall:**
```bash
sudo apt remove droidstar-9m2pju
```

---

### Fedora / RHEL / CentOS / openSUSE (.rpm)

**Supported:** Fedora 40+, RHEL 9+, CentOS Stream 9+, openSUSE Tumbleweed/Leap 15.6+, and any RPM-based distro with Qt 6.4+.

**One-liner (x86_64):**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.rpm -O /tmp/droidstar.rpm && sudo dnf install /tmp/droidstar.rpm
```

**One-liner (aarch64):**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-arm64.rpm -O /tmp/droidstar.rpm && sudo dnf install /tmp/droidstar.rpm
```

**Manual steps (Fedora/RHEL):**
```bash
# 1. Download
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.rpm

# 2. Install (dnf will resolve Qt6 dependencies automatically)
sudo dnf install ./DroidStar-9M2PJU-amd64.rpm

# 3. Run
DroidStar
```

**openSUSE (use zypper instead of dnf):**
```bash
sudo zypper install ./DroidStar-9M2PJU-amd64.rpm
```

**Uninstall:**
```bash
sudo dnf remove droidstar-9m2pju
# or on openSUSE:
sudo zypper remove droidstar-9m2pju
```

---

### Arch Linux / Manjaro (.pkg.tar.zst)

**Supported:** Arch Linux, Manjaro, EndeavourOS, Garuda, and any Arch-based distro (x86_64 only).

**One-liner:**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-x86_64.pkg.tar.zst -O /tmp/droidstar.pkg.tar.zst && sudo pacman -U /tmp/droidstar.pkg.tar.zst
```

**Manual steps:**
```bash
# 1. Download
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-x86_64.pkg.tar.zst

# 2. Install (pacman will resolve Qt6 dependencies automatically)
sudo pacman -U DroidStar-9M2PJU-x86_64.pkg.tar.zst

# 3. Run
DroidStar
```

**Uninstall:**
```bash
sudo pacman -R droidstar-9m2pju
```

---

### AppImage (Portable — Any Linux)

**Supported:** Any Linux distribution on amd64 or arm64. No installation required — just download and run. Qt6 libraries are bundled inside the AppImage.

**Prerequisite:** `libfuse2` must be installed (required by all AppImages).

```bash
# Debian/Ubuntu:
sudo apt install libfuse2

# Fedora/RHEL:
sudo dnf install fuse

# Arch Linux:
sudo pacman -S fuse2

# openSUSE:
sudo zypper install fuse
```

**One-liner (amd64):**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.AppImage -O ~/DroidStar.AppImage && chmod +x ~/DroidStar.AppImage && ~/DroidStar.AppImage
```

**One-liner (arm64 — Raspberry Pi 4/5, ARM servers):**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-arm64.AppImage -O ~/DroidStar.AppImage && chmod +x ~/DroidStar.AppImage && ~/DroidStar.AppImage
```

**Manual steps:**
```bash
# 1. Download
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.AppImage

# 2. Make executable
chmod +x DroidStar-9M2PJU-amd64.AppImage

# 3. Run
./DroidStar-9M2PJU-amd64.AppImage
```

**Tips:**
- Move it to `/opt` or `~/Applications` for a permanent setup
- Create a desktop shortcut by placing a `.desktop` file in `~/.local/share/applications/`
- The AppImage is self-contained — no Qt6 installation needed on your system

**"Uninstall":** Just delete the AppImage file.

---

### Flatpak (Any Linux with Flatpak)

**Supported:** Any Linux distribution with Flatpak installed (x86_64 only). Uses the KDE Platform 6.8 runtime which provides Qt6.

**Prerequisite:** Install Flatpak if you don't have it:

```bash
# Debian/Ubuntu:
sudo apt install flatpak

# Fedora (pre-installed, but just in case):
sudo dnf install flatpak

# Arch Linux:
sudo pacman -S flatpak

# openSUSE:
sudo zypper install flatpak
```

**Install:**
```bash
# 1. Download the .flatpak bundle
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU.flatpak

# 2. Install (this will also download the KDE Platform runtime if not already installed)
flatpak install --user ./DroidStar-9M2PJU.flatpak

# 3. Run
flatpak run org.dudetronics.DroidStar9M2PJU
```

**One-liner:**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU.flatpak -O /tmp/droidstar.flatpak && flatpak install --user --noninteractive /tmp/droidstar.flatpak && flatpak run org.dudetronics.DroidStar9M2PJU
```

**Uninstall:**
```bash
flatpak remove org.dudetronics.DroidStar9M2PJU
```

---

### Snap (Any Linux with Snap)

**Supported:** Any Linux distribution with Snapd installed (x86_64 only). Uses the KDE Qt6 content snap which provides Qt 6.8.

**Prerequisite:** Install Snapd if you don't have it:

```bash
# Debian/Ubuntu:
sudo apt install snapd

# Fedora:
sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap

# Arch Linux (AUR):
yay -S snapd
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# openSUSE:
sudo zypper install snapd
sudo systemctl enable --now snapd
```

**Install:**
```bash
# 1. Download the .snap file
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU.snap

# 2. Install (--dangerous is needed because the snap is not from the Snap Store)
sudo snap install --dangerous ./DroidStar-9M2PJU.snap

# 3. Run
snap run droidstar-9m2pju
```

**One-liner:**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU.snap -O /tmp/droidstar.snap && sudo snap install --dangerous /tmp/droidstar.snap && snap run droidstar-9m2pju
```

**Connect audio interfaces (if needed):**
```bash
sudo snap connect droidstar-9m2pju:audio-record :audio-record
sudo snap connect droidstar-9m2pju:serial-port :serial-port
```

**Uninstall:**
```bash
sudo snap remove droidstar-9m2pju
```

---

### Portable Tarball (.tar.gz)

**Supported:** Any Linux distribution on amd64 or arm64. Requires Qt6 to be installed on your system.

**One-liner (amd64):**
```bash
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.tar.gz -O /tmp/droidstar.tar.gz && tar xzf /tmp/droidstar.tar.gz -C /tmp && /tmp/DroidStar-amd64/DroidStar
```

**Manual steps:**
```bash
# 1. Download
wget https://github.com/9M2PJU/DroidStar-Linux/releases/latest/download/DroidStar-9M2PJU-amd64.tar.gz

# 2. Extract
tar xzf DroidStar-9M2PJU-amd64.tar.gz

# 3. Run
cd DroidStar-amd64
./DroidStar
```

**Note:** The tarball does not bundle Qt6 libraries. You must have Qt6 installed on your system:
```bash
# Debian/Ubuntu:
sudo apt install qt6-base-dev qt6-declarative-dev qt6-multimedia-dev qt6-serialport-dev

# Fedora:
sudo dnf install qt6-qtbase qt6-qtdeclarative qt6-qtmultimedia qt6-qtserialport

# Arch Linux:
sudo pacman -S qt6-base qt6-declarative qt6-multimedia qt6-serialport
```

**"Uninstall":** Just delete the extracted directory.

---

## Post-Install Setup

### USB AMBE / MMDVM Dongle Permissions

If you use USB AMBE devices (ThumbDV, DVstick 30, etc.) or MMDVM modems, you need permission to access USB serial devices. On most Linux distributions:

```bash
# Add your user to the dialout group (serial device access)
sudo usermod -aG dialout $USER

# Disable ModemManager (it can interfere with serial ports)
sudo systemctl disable ModemManager.service
sudo systemctl stop ModemManager.service
```

**Reboot** or log out/in after adding yourself to the `dialout` group for the changes to take effect.

### udev Rules (optional, for consistent device naming)

If you have multiple serial devices, you can create udev rules for stable device names:

```bash
# Example for ThumbDV (USB VID:PID 15a2:0073)
echo 'SUBSYSTEM=="tty", ATTRS{idVendor}=="15a2", ATTRS{idProduct}=="0073", SYMLINK+="thumbdv"' | sudo tee /etc/udev/rules.d/99-thumbdv.rules
sudo udevadm control --reload-rules
```

---

## Usage

Launch DroidStar from your application menu, or from the terminal:

```bash
DroidStar          # if installed via deb/rpm/pkg
flatpak run org.dudetronics.DroidStar9M2PJU   # if installed via Flatpak
snap run droidstar-9m2pju                      # if installed via Snap
./DroidStar-9M2PJU-*.AppImage                  # if using AppImage
```

### Main Controls

| Control | Description |
|---------|-------------|
| **Host/Mod** | Select the desired host and module (for D-STAR and M17) |
| **Callsign** | Enter your amateur radio callsign (valid license required) |
| **DMRID** | A valid DMR ID is required to connect to DMR servers |
| **Latitude/Longitude** | DMR location config sent to the DMR server during connect |
| **Location/Description** | DMR display text sent to the DMR server |
| **Talkgroup** | For DMR, enter the talkgroup ID number |
| **MYCALL/URCALL/RPTR1/RPTR2** | For D-STAR modes REF/DCS/XRF |

### Quick Start

1. Enter your **callsign** in the Settings tab
2. Enter your **DMR ID** (if using DMR)
3. Select a **mode** (M17, DMR, D-STAR, YSF, P25, NXDN, or AllStar)
4. Choose a **reflector/host** from the dropdown
5. Select the **module** (A-Z for D-STAR, talkgroup for DMR)
6. Click **Connect**
7. Press **PTT** or use **Spacebar** to transmit

---

## Building from Source

### Requirements

- **Qt 6.5** or newer (Qt 6.8.3 on Ubuntu 25.04)
- CMake 3.16+
- C++ compiler with C++17 support (GCC 13+, Clang 16+)

### Build Dependencies

**Ubuntu 25.04 / Debian 13:**
```bash
sudo apt install build-essential cmake git \
  qt6-base-dev qt6-base-private-dev qt6-declarative-dev \
  qt6-multimedia-dev qt6-serialport-dev qt6-shadertools-dev
```

**Fedora 40+ / RHEL 9+ (with EPEL):**
```bash
sudo dnf install gcc-c++ cmake git \
  qt6-qtbase-devel qt6-qtbase-private-devel qt6-qtdeclarative-devel \
  qt6-qtmultimedia-devel qt6-qtserialport-devel qt6-qtshadertools-devel
```

**Arch Linux:**
```bash
sudo pacman -S base-devel cmake git \
  qt6-base qt6-declarative qt6-multimedia qt6-serialport qt6-shadertools
```

**openSUSE Tumbleweed:**
```bash
sudo zypper install gcc-c++ cmake git \
  qt6-base-devel qt6-declarative-devel qt6-multimedia-devel \
  qt6-serialport-devel qt6-shadertools-devel
```

### Build & Install

```bash
git clone https://github.com/9M2PJU/DroidStar-Linux.git
cd DroidStar-Linux
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j$(nproc)
sudo cmake --install build
```

### Build Options

| Option | Default | Description |
|--------|---------|-------------|
| `USE_MD380_VOCODER` | `OFF` | Enable md380_vocoder library (32-bit ARM firmware objects, ARM-only) |
| `SKIP_QT_DEPLOY` | `OFF` | Skip Qt6 deploy script (use when runtime provides Qt, e.g. Flatpak) |

### md380_vocoder (ARM 32-bit only)

The `md380_vocoder` library contains 32-bit ARM firmware objects and can only be linked on 32-bit ARM platforms. Enable it with:

```bash
cmake -B build -DUSE_MD380_VOCODER=ON
```

You must ensure that you are not in violation of any patent laws in your area if you decide to use this.

---

## CI/CD Pipeline

This repository includes a GitHub Actions workflow (`.github/workflows/build.yml`) that automatically builds and publishes packages on every push to `main`:

| Job | Container/Runner | Output | Architectures |
|-----|-----------------|--------|---------------|
| **deb/rpm/AppImage/tarball** | `ubuntu:25.04` Docker (Qt 6.8.3) | `.deb`, `.rpm`, `.AppImage`, `.tar.gz` | amd64, arm64 |
| **Arch Linux pkg** | `archlinux:latest` Docker | `.pkg.tar.zst` | x86_64 |
| **Flatpak** | GitHub runner + `flatpak-builder` + KDE SDK 6.8 | `.flatpak` | x86_64 |
| **Snap** | GitHub runner + LXD + `snapcraft` + KDE Qt6 SDK | `.snap` | x86_64 |

All artifacts are collected and published as a GitHub Release tagged `DroidStar-9M2PJU-<commit-sha>`.

### AppImage Build Details

The AppImage is built in two stages because `appimagetool` requires FUSE (unavailable in Docker):

1. **In container:** Compile the binary, bundle Qt6 libraries/plugins/QML modules into an AppDir, create a custom `AppRun` script, and tar it up
2. **On runner:** Extract the AppDir tarball and run `appimagetool` to produce the final `.AppImage`

System libraries (libc, libm, libstdc++, libgcc_s, ld-linux) are excluded from the bundle to avoid glibc version conflicts with the host system.

---

## Credits & License

- **Original DroidStar software**: Doug McLain AD8DP — [https://github.com/nostar/DroidStar](https://github.com/nostar/DroidStar)
- **Linux packaging, CI/CD, and branding**: 9M2PJU

This is an unofficial Linux packaging. The original project is an open source project for educational and development purposes. No support is provided for any build.

---

## Support

If you find this packaging useful, consider supporting:

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-9M2PJU-orange?style=for-the-badge&logo=buy-me-a-coffee)](https://www.buymeacoffee.com/9m2pju)
[![Wise](https://img.shields.io/badge/Wise-Donate%209M2PJU-green?style=for-the-badge&logo=wise)](https://wise.com/pay/me/faizulz13)

For issues with the **original DroidStar software**, please report them to the [upstream repository](https://github.com/nostar/DroidStar/issues).

For issues with **this Linux packaging** (build failures, missing dependencies, package format issues), please report them to [this repository's issues](../../issues).
