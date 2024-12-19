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

    Run the following command in PowerShell:
    ```powershell
    wsl -l -o
    
    NAME                            FRIENDLY NAME
    CachyOS                         CachyOS (x86-64-v3)
    CachyOS_v4                      CachyOS (x86-64-v4)
    CachyOS_Zen4                    CachyOS (Zen4)
    ```

3. Install CachyOS:

    Run the following command in PowerShell:
    ```powershell
    wsl --install CachyOS
    ```