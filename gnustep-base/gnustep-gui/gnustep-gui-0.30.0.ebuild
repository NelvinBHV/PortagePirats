# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic gnustep-base
RESTRICT="mirror"

MY_PV=$(ver_rs 1- _)
DESCRIPTION="GNUStep library of graphical user interface classes"
HOMEPAGE="https://github.com/gnustep/libs-gui"
SRC_URI="https://github.com/gnustep/libs-gui/releases/download/gui-${MY_PV}/gnustep-gui-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm64 ~amd64"

DEPEND="gnustep-base/gnustep-make
		gnustep-base/gnustep-base
		sys-devel/gcc:*[objc]
		media-libs/freetype
		x11-libs/cairo
		x11-libs/libXt
		media-libs/tiff"

RDEPEND="${DEPEND}"
BDEPEND=""
#PATCHES=(
#        "${FILESDIR}"/${PN}-1.29.0-libxml2-2.11.patch
#)

#src_install() {
#				sed -i '/gzip/d' ${WORKDIR}/${P}/Tools/Makefile.postamble
#				sed -i '/gzip/d' ${WORKDIR}/${P}/Tools/make_strings/GNUmakefile.postamble
#				if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
#					emake DESTDIR="${D}" install
#				fi
#}
