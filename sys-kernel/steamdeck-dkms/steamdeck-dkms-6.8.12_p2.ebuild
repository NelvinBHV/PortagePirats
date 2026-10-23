# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT="f9c0a828b9c1b6c0ce16311822389b8d1c65eb54"
UPSTREAM_VERSION="6.8.12.valve2"

DESCRIPTION="Steam Deck EC sensors, fan, LEDs and extcon kernel modules"
HOMEPAGE="https://github.com/firlin123/steamdeck-dkms"
SRC_URI="https://github.com/firlin123/steamdeck-dkms/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/steamdeck-dkms-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

CONFIG_CHECK="
	ACPI
	EXTCON
	HWMON
	LEDS_CLASS
	MFD_CORE
"

pkg_setup() {
	linux-mod-r1_pkg_setup

	MODULES_MAKEARGS+=(
		KERNEL_DIR="${KV_OUT_DIR}"
	)
}

pkg_pretend() {
	check_extra_config
}

src_compile() {
	local modlist=(
		steamdeck=misc
		steamdeck_hwmon=misc
		steamdeck_leds=misc
		steamdeck_extcon=misc
	)

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	insinto /usr/lib/modules-load.d
	newins usr/share/initramfs-tools/modules.d/steamdeck-dkms.conf steamdeck.conf
}
