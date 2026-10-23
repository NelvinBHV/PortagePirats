# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Magenta PVR client for Kodi"
HOMEPAGE="https://github.com/nirvana-7777/pvr.magenta"
SRC_URI="https://github.com/nirvana-7777/pvr.magenta/archive/refs/tags/21.8.0-Omega.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

# Abhängigkeiten basierend auf CMakeLists.txt und addon.xml.in
COMMON_DEPEND="
	=media-tv/kodi-21*
	dev-libs/rapidjson
"
DEPEND="${COMMON_DEPEND}"
# Das Plugin benötigt inputstream.adaptive zur Laufzeit für DRM (Widevine)
RDEPEND="${COMMON_DEPEND}
	media-plugins/kodi-inputstream-adaptive
"
BDEPEND="
	virtual/pkgconfig
"

# Das Verzeichnis im Tarball heißt "pvr.magenta-21.8.0-Omega"
S="${WORKDIR}/pvr.magenta-21.8.0-Omega"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}
