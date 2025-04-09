# 🐧 CachyOS WSL Root Filesystem

This project provides the **CachyOS root filesystem** for running under **Windows Subsystem for Linux (WSL)**.

---

## 📥 Download Statistics

Below are the current download stats for each variant of the CachyOS WSL rootfs:

| Variant | Architecture | Downloads |
|---------|--------------|-----------|
| **CachyOS v3** | x86-64_v3 | [![v3 Downloads](https://img.shields.io/github/downloads/okrc/CachyOS-WSL/cachyos-v3-rootfs.wsl)](https://github.com/okrc/CachyOS-WSL/releases/latest/download/cachyos-v3-rootfs.wsl) |
| **CachyOS v4** | x86-64_v4 | [![v4 Downloads](https://img.shields.io/github/downloads/okrc/CachyOS-WSL/cachyos-v4-rootfs.wsl)](https://github.com/okrc/CachyOS-WSL/releases/latest/download/cachyos-v4-rootfs.wsl) |
| **CachyOS znver4** | AMD Zen 4 | [![znver4 Downloads](https://img.shields.io/github/downloads/okrc/CachyOS-WSL/cachyos-znver4-rootfs.wsl)](https://github.com/okrc/CachyOS-WSL/releases/latest/download/cachyos-znver4-rootfs.wsl) |

---

## 🚀 Quick Start

### 1. Add Registry Key for Custom Distribution List

```cmd
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" /v DistributionListUrlAppend /t REG_SZ /d "https://github.com/okrc/CachyOS-WSL/releases/latest/download/DistributionInfo.json" /f
```

<details>
<summary>PowerShell</summary>

```powershell
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss -Name DistributionListUrlAppend -Force -Type String -Value https://github.com/okrc/CachyOS-WSL/releases/latest/download/DistributionInfo.json
```
</details>

### 2. List Available WSL Distributions

```powershell
wsl -l -o
```

### 3. Install CachyOS

```powershell
wsl --install CachyOS
```

---

## 🎨 Default Shell Configuration

CachyOS comes with customized shell themes via `cachyos-fish-config` and `cachyos-zsh-config`. Choose either `fish` or `zsh` for your preferred shell experience.

### 🐟 fish shell setup:

```sh
sudo pacman -Sy --needed --noconfirm cachyos-fish-config
mkdir -p ~/.config/fish
cp /etc/skel/.config/fish/config.fish ~/.config/fish/config.fish
```

### 💻 zsh shell setup:

```sh
sudo pacman -Sy --needed --noconfirm cachyos-zsh-config
cp /etc/skel/.zshrc ~/
```

---

## 💬 Feedback

Feel free to open issues or pull requests if you encounter problems or want to contribute!
