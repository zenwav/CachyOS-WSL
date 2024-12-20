## CachyOS WSL Root Filesystem

This project is used to generate the CachyOS root filesystem for WSL.

### Usage

1. Add a registry key:

    ```cmd
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss" /v DistributionListUrlAppend /t REG_SZ /d "https://github.com/okrc/CachyOS-WSL/releases/latest/download/DistributionInfo.json" /f
    ```

    <details>

    ```powershell
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss -Name DistributionListUrlAppend -Force -Type String -Value https://github.com/okrc/CachyOS-WSL/releases/latest/download/DistributionInfo.json
    ```
    </details>

2. List available WSL distributions:

    ```powershell
    wsl -l -o
    ```

3. Install CachyOS:

    ```powershell
    wsl --install CachyOS
    ```

### Default Shell Configuration

CachyOS customizes shell theme packages `cachyos-fish-config` and `cachyos-zsh-config`. You can choose your preferred shell, either fish or zsh.

- To install fish configuration:
    ```sh
    sudo pacman -Sy --needed --noconfirm cachyos-fish-config
    mkdir -p ~/.config/fish
    cp /etc/skel/.config/fish/config.fish ~/.config/fish/config.fish
    ```

- To install zsh configuration:
    ```sh
    sudo pacman -Sy --needed --noconfirm cachyos-zsh-config
    cp /etc/skel/.zshrc ~/
    ```
