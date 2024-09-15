# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic gnustep-base
RESTRICT="mirror"

MY_PV=$(ver_rs 1- _)
DESCRIPTION="It is a back-end component for the GNUstep GUI Library."
HOMEPAGE="https://github.com/gnustep/libs-back"
SRC_URI="https://github.com/gnustep/libs-back/releases/download/back-${MY_PV}/gnustep-back-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm64 ~amd64"

DEPEND="gnustep-base/gnustep-make
		gnustep-base/gnustep-base
		gnustep-base/gnustep-gui
		sys-devel/gcc:*[objc]
		media-libs/freetype
		x11-libs/cairo:*[X]
		x11-libs/libXt"

RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
				sed -i '/gzip/d' ${WORKDIR}/${P}/Tools/GNUmakefile.postamble
				if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
					emake DESTDIR="${D}" install
				fi
}
