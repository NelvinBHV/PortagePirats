# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

# Die Versionierung im Dateinamen ist etwas eigenwillig, daher mappen wir sie:
MY_PV="1.6.0-641-3-Omega"

DESCRIPTION="C++ class library and tools for MP4, DASH, HLS (Kodi Fork)"
HOMEPAGE="https://github.com/xbmc/Bento4"
SRC_URI="https://github.com/xbmc/Bento4/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

# Entpack-Verzeichnis anpassen
S="${WORKDIR}/Bento4-${MY_PV}"

src_configure() {
	# WICHTIG: Erzwinge -fPIC, da diese Lib in ein Kodi-Plugin (Shared Object)
	# gelinkt wird. Ohne das crasht der Linker mit "relocation R_X86_64_PC32".
	append-cxxflags -fPIC

	local mycmakeargs=(
		# Wir bauen statische Libs, aber mit PIC.
		# Shared Libs sind bei Bento4 oft problematisch im Build-System,
		# daher ist static+PIC sicherer für Kodi.
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DBUILD_APPS=OFF
		-DCMAKE_INSTALL_PREFIX=/usr
	)
	cmake_src_configure
}
