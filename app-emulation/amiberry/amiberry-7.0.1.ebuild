# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

RESTRICT="mirror"
DESCRIPTION="Amiberry is an optimized Amiga emulator,"
HOMEPAGE="https://blitterstudio.com/amiberry/"
SRC_URI="https://github.com/BlitterStudio/amiberry/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 amd64"

DEPEND="dev-libs/libserialport
	media-fonts/liberation-fonts
	media-libs/flac
	media-libs/libmpeg2
	media-libs/libpng
	media-libs/libsdl2
	media-libs/portmidi
	media-libs/sdl2-image
	media-sound/mpg123-base
	net-libs/enet
	sys-libs/zlib"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	eapply "${FILESDIR}/amiberry-${PV}-path.patch"
	eapply "${FILESDIR}/amiberry-${PV}-font.patch"
	eapply "${FILESDIR}/amiberry-${PV}-desktop.patch"
	eapply_user
	default
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
