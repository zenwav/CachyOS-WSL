#!/usr/bin/env bash

set -euo pipefail # Enable strict mode for better error handling

# === Configuration Section ===
declare -r BASE_PACKAGES="base cachyos-hooks cachyos-keyring cachyos-mirrorlist iptables-nft sudo"
declare -r SERVICES_TO_MASK=(
    systemd-resolved.service
    systemd-networkd.service
    NetworkManager.service
    getty.target
    systemd-homed.service
    systemd-userdbd.service
    systemd-firstboot.service
    systemd-nsresourced.service
    systemd-tmpfiles-setup.service
    systemd-tmpfiles-clean.service
    systemd-tmpfiles-clean.timer
    systemd-tmpfiles-setup-dev-early.service
    systemd-tmpfiles-setup-dev.service
    tmp.mount
)
declare -r BUILDDIR="/rootfs"
declare -r WORKING_DIR=$(pwd)
declare -r PACMAN_AWK=$(mktemp --suffix=_pacman.awk)
declare -r PACMAN_CONF=$(mktemp --suffix=_pacman.conf)
declare -r OPTION=${1:-v3}

# === Configure Pacman and Download Required Files ===
function configure_pacman() {
    case "$OPTION" in
    v3)
        curl -s https://raw.githubusercontent.com/CachyOS/cachyos-repo-add-script/refs/heads/develop/install-repo.awk -o "${PACMAN_AWK}"
        declare -g PACKAGES="${BASE_PACKAGES} cachyos-v3-mirrorlist"
        declare -g ROOTFS_FILE="cachyos-v3-rootfs.wsl"
        ;;
    v4)
        curl -s https://raw.githubusercontent.com/CachyOS/cachyos-repo-add-script/refs/heads/develop/install-v4-repo.awk -o "${PACMAN_AWK}"
        declare -g PACKAGES="${BASE_PACKAGES} cachyos-v4-mirrorlist"
        declare -g ROOTFS_FILE="cachyos-v4-rootfs.wsl"
        ;;
    znver4)
        curl -s https://raw.githubusercontent.com/CachyOS/cachyos-repo-add-script/refs/heads/develop/install-znver4-repo.awk -o "${PACMAN_AWK}"
        declare -g PACKAGES="${BASE_PACKAGES} cachyos-v4-mirrorlist"
        declare -g ROOTFS_FILE="cachyos-znver4-rootfs.wsl"
        ;;
    *)
        echo "Invalid option: $OPTION"
        echo "Usage: $0 [v3|v4|znver4] (default: v3)"
        exit 1
        ;;
    esac

    curl -sL https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/refs/heads/master/pacman/pacman.conf \
        -o "${PACMAN_CONF}"
    gawk -i inplace -f "${PACMAN_AWK}" "${PACMAN_CONF}"
}

# === Initialize the Root Filesystem ===
function setup_rootfs() {
    echo "Setting up root filesystem in ${BUILDDIR}..."
    mkdir -p /etc/pacman.d/hooks
    touch /etc/pacman.d/hooks/30-systemd-tmpfiles.hook
    mkdir -vp "${BUILDDIR}"/{var/lib/pacman,etc}
    ln -sf ../usr/lib/os-release "${BUILDDIR}/etc/os-release"
}

# === Install Base Packages ===
function install_packages() {
    echo "Installing base packages..."
    pacman --sync \
        --root "${BUILDDIR}" \
        --refresh \
        --config "${PACMAN_CONF}" \
        --noconfirm \
        --noprogressbar \
        ${PACKAGES}
}

# === Configure Pacman and System Files ===
function configure_system() {
    echo "Configuring system files..."
    gawk -i inplace -f "${PACMAN_AWK}" "${BUILDDIR}/etc/pacman.conf"
    sed -i 's,^#\(Color\|ILoveCandy\),\1,g' "${BUILDDIR}/etc/pacman.conf"
    sed -i 's,^#Server,Server,g' "${BUILDDIR}/etc/pacman.d/mirrorlist"
    ln -sf /etc/locale.conf "${BUILDDIR}"/etc/default/locale
    cp --recursive --preserve=timestamps "${WORKING_DIR}"/linux_files/* "${BUILDDIR}"
    rm -rf "${BUILDDIR}"/etc/{resolv.conf,machine-id,hostname,hosts}

    # Configure sudo permissions
    echo "%wheel ALL=(ALL) ALL" | tee "${BUILDDIR}/etc/sudoers.d/10-installer" >/dev/null
    chmod 440 "${BUILDDIR}/etc/sudoers.d/10-installer"

    # Set default systemd target
    ln -sf /usr/lib/systemd/system/multi-user.target "${BUILDDIR}/etc/systemd/system/default.target"
}

# === Mask WSL-Incompatible Services ===
function mask_services() {
    echo "Masking WSL-incompatible services..."
    for service in "${SERVICES_TO_MASK[@]}"; do
        ln -sf /dev/null "${BUILDDIR}/etc/systemd/system/${service}"
    done
}

# === Pack the Root Filesystem ===
function pack_rootfs() {
    echo "Packing root filesystem into ${ROOTFS_FILE}..."
    (
        cd "${BUILDDIR}"
        tar --anchored --xattrs --exclude-from="${WORKING_DIR}/scripts/exclude" --numeric-owner -czf "${WORKING_DIR}/${ROOTFS_FILE}" *
    )
}

# === Main Script Execution ===
configure_pacman
setup_rootfs
install_packages
configure_system
mask_services
pack_rootfs

# Clean up temporary files
rm -f "${PACMAN_CONF}" "${PACMAN_AWK}"
echo "Root filesystem packed successfully: ${ROOTFS_FILE}"
