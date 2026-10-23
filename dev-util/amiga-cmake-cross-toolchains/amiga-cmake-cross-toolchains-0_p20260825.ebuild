# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="c579e46732af7398a09360dce4a6fb8d91d3f447"

DESCRIPTION="CMake cross-toolchain files for Amiga-like systems"
HOMEPAGE="https://github.com/AmigaPorts/AmigaCMakeCrossToolchains"
SRC_URI="https://github.com/AmigaPorts/AmigaCMakeCrossToolchains/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/AmigaCMakeCrossToolchains-${COMMIT}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-build/cmake
	dev-embedded/m68k-amigaos-gcc
"

src_compile() { :; }

src_install() {
	dodoc README.md

	insinto /usr/share/amiga-cmake
	doins *.cmake
	doins -r Modules

	# Upstream defaults to /opt/m68k-amigaos, while AmigaPorts installs its
	# complete compiler suite below /opt/amiga.
	sed -i 's|set(TOOLCHAIN_PATH_DEFAULT /opt/${TOOLCHAIN_PREFIX})|set(TOOLCHAIN_PATH_DEFAULT /opt/amiga)|' \
		"${ED}/usr/share/amiga-cmake/m68k-amigaos.cmake" || die

	# The toolchain checks for Platform/AmigaOS to retain the AmigaOS system
	# name. Upstream documents copying Generic.cmake; a small include adapter
	# provides the same result without duplicating CMake's versioned file.
	printf '%s\n' 'include(Platform/Generic)' > "${T}/AmigaOS.cmake" || die
	insinto /usr/share/cmake/Modules/Platform
	doins "${T}/AmigaOS.cmake"
}
