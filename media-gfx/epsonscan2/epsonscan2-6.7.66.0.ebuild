
# Copyright 2024
# Distributed under the terms of the GNU General Public License, v2 or later

EAPI=8
RESTRICT="mirror"
CMAKE_BUILD_TYPE="Release"
CMAKE_VERBOSE="OFF"
inherit cmake desktop udev xdg-utils

DESCRIPTION="EpsonScan2 Scanner Software"
HOMEPAGE="https://support.epson.net/linux/en/epsonscan2.php"
SRC_URI="https://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=JA&CN2=US&CTI=171&PRN=Linux%20src%20package&OSC=LX&DL -> ${P}-1.src.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

DEPEND="dev-libs/boost
	dev-libs/rapidjson
	dev-qt/qtcore
	dev-qt/qtgui
	dev-qt/qtwidgets
	media-gfx/sane-backends
	media-libs/libharu
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	virtual/libusb"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv epsonscan2* ${P}
}

src_configure() {
	cmake_src_configure
	cd ${BUILD_DIR}
	# Prevent to create symlinks from cmake_install.cmake
	sed -i /create_symlink/d cmake_install.cmake || die
	# Change doc path to ${P} in cmake_install.cmake
	sed -i "s/epsonscan2-1.0.0.0-1/${P}/g" cmake_install.cmake
}
src_install() {
	cmake_src_install
	# Install epsonscan.png to /usr/share/pixmaps
	doicon ${FILESDIR}/epsonscan.png
	# Install epsonscan.desktop to /usr/share/applications
	insinto /usr/share/applications
	doins ${FILESDIR}/epsonscan.desktop
	#Create symlinks
	LIBDIR="/usr/$(get_libdir)/sane"
	dosym ../epsonscan2/libsane-epsonscan2.so ${LIBDIR}/libsane-epsonscan2.so.1
	dosym ../epsonscan2/libsane-epsonscan2.so ${LIBDIR}/libsane-epsonscan2.so.1.0.0
}
pkg_postinst() {
	udev_reload
	xdg_desktop_database_update
	xdg_icon_cache_update
	
}
pkg_postrm() {
	udev_reload
	xdg_desktop_database_update
	xdg_icon_cache_update
}
