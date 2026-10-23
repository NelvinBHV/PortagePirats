# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Die genaue Version des Tags bei GitHub
MY_PV="21.2.5-Omega"

DESCRIPTION="Tvheadend HTSP PVR client for Kodi"
HOMEPAGE="https://github.com/kodi-pvr/pvr.hts"
# Download direkt von GitHub, lokal als ${P}.tar.gz speichern
SRC_URI="https://github.com/kodi-pvr/pvr.hts/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

COMMON_DEPEND="
	=media-tv/kodi-21*
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

# GitHub entpackt immer in "RepoName-TagName"
S="${WORKDIR}/pvr.hts-${MY_PV}"

src_prepare() {
	# Standard CMake Vorbereitung
	cmake_src_prepare

	# FIX: Fehlenden Header <cstdint> für uint32_t hinzufügen.
	# Ohne das bricht der Build mit GCC 13/14/15 ab ("uint32_t does not name a type")
	sed -i '/#include <string>/a #include <cstdint>' src/tvheadend/HTSPVFS.h || die "Sed failed to patch HTSPVFS.h"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}
