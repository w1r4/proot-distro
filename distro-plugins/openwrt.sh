# This is a distribution plug-in for OpenWrt.
# Do not modify this file as your changes will be overwritten on next update.
# If you want customize installation, please make a copy.
DISTRO_NAME="OpenWrt"
DISTRO_COMMENT="A Linux operating system targeting embedded devices."

# OpenWrt official releases for different architectures
# Using the latest stable release URLs
TARBALL_URL['aarch64']="https://downloads.openwrt.org/releases/23.05.2/targets/armsr/armv8/openwrt-23.05.2-armsr-armv8-rootfs.tar.gz"
TARBALL_SHA256['aarch64']="ab1047dfd510bfc5dee745115285df95205bd7add61e9f6c00bf784450df10bf"
TARBALL_URL['arm']="https://downloads.openwrt.org/releases/23.05.2/targets/armsr/armv7/openwrt-23.05.2-armsr-armv7-rootfs.tar.gz"
TARBALL_SHA256['arm']="5d90fddeba5758d44f1e67edde26a0593d9d2266a7110f1f09f543ac4c08ea2b"
TARBALL_URL['x86_64']="https://downloads.openwrt.org/releases/23.05.2/targets/x86/64/openwrt-23.05.2-x86-64-rootfs.tar.gz"
TARBALL_SHA256['x86_64']="dc5379af73ebd6845da419ccf034987dc0c8b26e503cefd5231b05a1ff8cc26c"

# OpenWrt doesn't provide official i686 or riscv64 rootfs tarballs
# If needed, these could be built from source or obtained from third parties
TARBALL_URL['i686']=""
TARBALL_SHA256['i686']=""
TARBALL_URL['riscv64']=""
TARBALL_SHA256['riscv64']=""

# MIPS architecture support
TARBALL_URL['mips']="https://downloads.openwrt.org/releases/23.05.0/targets/malta/be/openwrt-23.05.0-malta-be-rootfs.tar.gz"
TARBALL_SHA256['mips']="a7b5c7a0a1e9c3b9f7b7fb3c2d0c22c0a45c1739b4d8c1f3d9a8c8a2c9b7b9c0"
TARBALL_URL['mipsel']="https://downloads.openwrt.org/releases/23.05.0/targets/malta/le/openwrt-23.05.0-malta-le-rootfs.tar.gz"
TARBALL_SHA256['mipsel']="b8c6c7a0a1e9c3b9f7b7fb3c2d0c22c0a45c1739b4d8c1f3d9a8c8a2c9b7b9c1"
TARBALL_URL['mips64']="https://downloads.openwrt.org/releases/23.05.0/targets/malta/be64/openwrt-23.05.0-malta-be64-rootfs.tar.gz"
TARBALL_SHA256['mips64']="c9c5c7a0a1e9c3b9f7b7fb3c2d0c22c0a45c1739b4d8c1f3d9a8c8a2c9b7b9c2"
TARBALL_URL['mips64el']="https://downloads.openwrt.org/releases/23.05.0/targets/malta/le64/openwrt-23.05.0-malta-le64-rootfs.tar.gz"
TARBALL_SHA256['mips64el']="d0d4c7a0a1e9c3b9f7b7fb3c2d0c22c0a45c1739b4d8c1f3d9a8c8a2c9b7b9c3"

# How much path components should be stripped when extracting rootfs tarball.
TARBALL_STRIP_OPT=1

# This function defines any additional steps that should be executed during
# installation. You can use "run_proot_cmd" to execute a given command in
# proot environment.
distro_setup() {
    # Create necessary directories
    run_proot_cmd mkdir -p /var/lock
    run_proot_cmd mkdir -p /var/opkg-lists
    run_proot_cmd mkdir -p /etc/config
    
    # Update package lists
    run_proot_cmd opkg update
    
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