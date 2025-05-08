#!/usr/bin/env bash
##
## Build recipe for OpenWrt rootfs
##

# Define distribution name and version
dist_name="OpenWrt"
dist_version="23.05.0"

# Function to bootstrap the OpenWrt distribution
bootstrap_distribution() {
    # Create a working directory for OpenWrt
    mkdir -p "${WORKDIR}/openwrt"
    cd "${WORKDIR}/openwrt"
    
    # Download OpenWrt rootfs for different architectures
    for arch in aarch64 arm x86_64; do
        case "$arch" in
            aarch64)
                rootfs_url="https://downloads.openwrt.org/releases/${dist_version}/targets/armsr/armv8/openwrt-${dist_version}-armsr-armv8-rootfs.tar.gz"
                rootfs_file="${ROOTFS_DIR}/openwrt-${dist_version}-${arch}-rootfs.tar.xz"
                ;;
            arm)
                rootfs_url="https://downloads.openwrt.org/releases/${dist_version}/targets/armsr/armv7/openwrt-${dist_version}-armsr-armv7-rootfs.tar.gz"
                rootfs_file="${ROOTFS_DIR}/openwrt-${dist_version}-${arch}-rootfs.tar.xz"
                ;;
            x86_64)
                rootfs_url="https://downloads.openwrt.org/releases/${dist_version}/targets/x86/64/openwrt-${dist_version}-x86-64-rootfs.tar.gz"
                rootfs_file="${ROOTFS_DIR}/openwrt-${dist_version}-${arch}-rootfs.tar.xz"
                ;;
        esac
        
        # Download and extract the rootfs
        mkdir -p "${WORKDIR}/openwrt/${arch}"
        echo "[*] Downloading OpenWrt rootfs for ${arch}..."
        curl -L -o "${WORKDIR}/openwrt/${arch}/rootfs.tar.gz" "${rootfs_url}"
        
        # Extract and repackage the rootfs
        echo "[*] Extracting and repackaging OpenWrt rootfs for ${arch}..."
        mkdir -p "${WORKDIR}/openwrt/${arch}/root"
        tar -xf "${WORKDIR}/openwrt/${arch}/rootfs.tar.gz" -C "${WORKDIR}/openwrt/${arch}/root"
        
        # Archive the rootfs
        echo "[*] Creating OpenWrt rootfs archive for ${arch}..."
        archive_rootfs "${rootfs_file}" "openwrt/${arch}/root"
        
        echo "[*] OpenWrt rootfs for ${arch} is ready at ${rootfs_file}"
    done
}

# Function to write the plugin for proot-distro
write_plugin() {
    cat <<- EOF > "${PLUGIN_DIR}/openwrt.sh"
	# This is a distribution plug-in for OpenWrt.
	# Do not modify this file as your changes will be overwritten on next update.
	# If you want customize installation, please make a copy.
	DISTRO_NAME="${dist_name}"
	DISTRO_COMMENT="A Linux operating system targeting embedded devices."
	
	# OpenWrt official releases for different architectures
	# Using the latest stable release URLs
	TARBALL_URL['aarch64']="${GIT_RELEASE_URL}/openwrt-${dist_version}-aarch64-rootfs.tar.xz"
	TARBALL_SHA256['aarch64']="$(sha256sum "${ROOTFS_DIR}/openwrt-${dist_version}-aarch64-rootfs.tar.xz" | awk '{print $1}')"
	TARBALL_URL['arm']="${GIT_RELEASE_URL}/openwrt-${dist_version}-arm-rootfs.tar.xz"
	TARBALL_SHA256['arm']="$(sha256sum "${ROOTFS_DIR}/openwrt-${dist_version}-arm-rootfs.tar.xz" | awk '{print $1}')"
	TARBALL_URL['x86_64']="${GIT_RELEASE_URL}/openwrt-${dist_version}-x86_64-rootfs.tar.xz"
	TARBALL_SHA256['x86_64']="$(sha256sum "${ROOTFS_DIR}/openwrt-${dist_version}-x86_64-rootfs.tar.xz" | awk '{print $1}')"
	
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
EOF

    echo "[*] Plugin for OpenWrt has been generated at ${PLUGIN_DIR}/openwrt.sh"
}