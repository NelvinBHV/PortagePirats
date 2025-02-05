
# Copyright 2024
# Distributed under the terms of the GNU General Public License, v2 or later

EAPI=8
RESTRICT="mirror fetch"
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

pkg_nofetch() {
	einfo "Please download ${P}-1.src.tar.gz manually"
	einfo "You can use wget for this:"
	einfo "wget --user-agent=\"Mozilla/5.0 (X11; Linux x86_64; rv:135.0) Gecko/20100101 Firefox/135.0\" \"https://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=JA&CN2=US&CTI=171&PRN=Linux%20src%20package&OSC=LX&DL\" -O /var/cache/distfiles/epsonscan2-6.7.70.0-1.src.tar.gz"
}


src_unpack() {
	unpack ${A}
	mv epsonscan2* ${P}
}

src_prepare() {
	einfo "Cleanup poor source code from epsonscan2"
	find . -name "CMakeCache.txt" | xargs -I {} rm {} > /dev/null 2>&1
	find . -name "cmake_install.cmake" | xargs -I{} rm {} > /dev/null 2>&1
	find . -name "Makefile" | xargs -I{} rm {} > /dev/null 2>&1
	find . -name "CMakeFiles" | xargs -I {}  rm -r {} > /dev/null 2>&1
	eapply_user
	cmake_src_prepare
}

src_configure() {
	cmake_src_configure
	# Change hardcoded /tmp/build to ${BUILD_DIR}
	einfo "Change hardcoded /tmp/build to ${BUILD_DIR}"
	sed -i "s|/tmp/build|${BUILD_DIR}|g" *
}

src_install() {
	einfo "Prevent to create symlinks from cmake_install.cmake"
	# Prevent to create symlinks from cmake_install.cmake
	sed -i /create_symlink/d ${BUILD_DIR}/cmake_install.cmake || die
	einfo "Change doc path to ${P} in cmake_install.cmake"
	# Change doc path to ${P} in cmake_install.cmake
	sed -i "s/epsonscan2-1.0.0.0-1/${P}/g" ${BUILD_DIR}/cmake_install.cmake || die
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
