# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

COMMIT="6a3e34da3c6b44b51bed798dbd4ade86b4cbed49"

DESCRIPTION="C game engine and hardware abstraction layer for classic Amiga"
HOMEPAGE="https://github.com/AmigaPorts/ACE"
SRC_URI="https://github.com/AmigaPorts/ACE/archive/${COMMIT}.tar.gz -> ${PN}-${PV}.tar.gz"
S="${WORKDIR}/ACE-${COMMIT}"

LICENSE="MPL-2.0 MIT public-domain"
SLOT="0"
KEYWORDS="amd64"
IUSE="+aga debug ecs"

# sfdc 1.13 in this toolchain fixes CIA resource wrappers upstream.
DEPEND=">=dev-embedded/m68k-amigaos-gcc-16.2_rc13-r1"
BDEPEND="dev-util/amiga-cmake-cross-toolchains"

src_configure() {
	# Native CPU tuning flags (for example -march=znver4) are invalid for
	# the m68k-amigaos cross compiler. The toolchain file supplies -m68020.
	filter-flags '-march=*' '-mcpu=*' '-mtune=*'

	cmake \
		-S "${S}" \
		-B "${BUILD_DIR}" \
		-G Ninja \
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr" \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DCMAKE_TOOLCHAIN_FILE=/usr/share/amiga-cmake/m68k-amigaos.cmake \
		-DTOOLCHAIN_PATH=/opt/amiga \
		-DM68K_CPU=68020 \
		-DM68K_FPU=soft \
		-DM68K_CRT=nix20 \
		-DACE_LIBRARY_KIND=STATIC \
		-DACE_USE_AGA_FEATURES=$(usex aga ON OFF) \
		-DACE_USE_ECS_FEATURES=$(usex ecs ON OFF) \
		-DACE_DEBUG=$(usex debug ON OFF) \
		|| die "cmake configure failed"
}

src_install() {
	cmake_src_install
	dodoc docs/*.md
}
