# This is a distribution plug-in for OpenWrt.
# Do not modify this file as your changes will be overwritten on next update.
# If you want customize installation, please make a copy.
DISTRO_NAME="OpenWrt"
DISTRO_COMMENT="A Linux operating system targeting embedded devices."

# OpenWrt official releases for different architectures
# Using the latest stable release URLs
TARBALL_URL['aarch64']="https://downloads.openwrt.org/releases/23.05.0/targets/armsr/armv8/openwrt-23.05.0-armsr-armv8-rootfs.tar.gz"
TARBALL_SHA256['aarch64']="080a7b6bc08d7aab2202791146888fbe363e36354e10eff66dbc92c9508b59c1"
TARBALL_URL['arm']="https://downloads.openwrt.org/releases/23.05.0/targets/armsr/armv7/openwrt-23.05.0-armsr-armv7-rootfs.tar.gz"
TARBALL_SHA256['arm']="d3c5a51f9e8fbe3eb4b2e647afca5c6e7c32ed51f0dc0f6a8b480422863e132c"
TARBALL_URL['x86_64']="https://downloads.openwrt.org/releases/23.05.0/targets/x86/64/openwrt-23.05.0-x86-64-rootfs.tar.gz"
TARBALL_SHA256['x86_64']="f8f4f3f56b1c9e3bb7b08421912d2b7908b31e0be2c0e0e09b7d6ee7d902c5d7"

# OpenWrt doesn't provide official i686 or riscv64 rootfs tarballs
# If needed, these could be built from source or obtained from third parties
TARBALL_URL['i686']=""
TARBALL_SHA256['i686']=""
TARBALL_URL['riscv64']=""
TARBALL_SHA256['riscv64']=""

# How much path components should be stripped when extracting rootfs tarball.
TARBALL_STRIP_OPT=1

# This function defines any additional steps that should be executed during
# installation. You can use "run_proot_cmd" to execute a given command in
# proot environment.
distro_setup() {
    # Update package lists
    run_proot_cmd opkg update
    
    # Set up timezone and locale
    run_proot_cmd mkdir -p /etc/config
    
    # Create a basic network configuration
    run_proot_cmd touch /etc/config/network
    
    # Set up hostname
    echo "openwrt" > "${INSTALLED_ROOTFS_DIR}/${distro_name}/etc/hostname"
    
    # Create a welcome message
    cat <<EOL > "${INSTALLED_ROOTFS_DIR}/${distro_name}/etc/banner"
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt on Termux PRoot-Distro
 -----------------------------------------------------
EOL
}