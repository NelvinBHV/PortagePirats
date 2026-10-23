# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Der gewünschte Commit-Hash
MY_COMMIT="af55a16bad506472688c6d17a37ad3055b15f71e"

DESCRIPTION="Magenta PVR client for Kodi"
HOMEPAGE="https://github.com/nirvana-7777/pvr.magenta"
# Wir laden den Source-Code direkt von GitHub als Tarball herunter
SRC_URI="https://github.com/nirvana-7777/pvr.magenta/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

COMMON_DEPEND="
	=media-tv/kodi-21*
	dev-libs/rapidjson
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	media-plugins/kodi-inputstream-adaptive
"
BDEPEND="
	virtual/pkgconfig
"

# GitHub extrahiert in den Ordner "Repo-Name-CommitHash"
S="${WORKDIR}/pvr.magenta-${MY_COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}
