# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kodi's Adaptive inputstream addon"
HOMEPAGE="https://github.com/xbmc/inputstream.adaptive"
SRC_URI="https://github.com/xbmc/inputstream.adaptive/archive/refs/tags/21.5.18-Omega.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

# Abhängigkeiten basierend auf CMakeLists.txt
COMMON_DEPEND="
	=media-tv/kodi-21*
	dev-libs/pugixml
	dev-libs/rapidjson
	media-libs/bento4
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-cpp/gtest )
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

# Das Verzeichnis im Tarball heißt "inputstream.adaptive-21.5.18-Omega"
S="${WORKDIR}/inputstream.adaptive-21.5.18-Omega"

src_configure() {
	local mycmakeargs=(
		# Wir nutzen die System-Bibliothek für bento4
		-DENABLE_INTERNAL_BENTO4=OFF
		-DBUILD_TESTING=$(usex test)
		# Installationspfad wird normalerweise durch Kodi-CMake-Makros handled,
		# aber Prefix muss /usr sein.
		-DCMAKE_INSTALL_PREFIX=/usr
	)
	cmake_src_configure
}
