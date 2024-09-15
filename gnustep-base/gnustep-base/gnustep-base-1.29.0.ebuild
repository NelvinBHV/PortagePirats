# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic gnustep-base
RESTRICT="mirror"

MY_PV=$(ver_rs 1- _)
DESCRIPTION="The GNUstep Base Library"
HOMEPAGE="https://github.com/gnustep/tools-make"
SRC_URI="https://github.com/gnustep/libs-base/releases/download/base-${MY_PV}/gnustep-base-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm64 ~amd64"

DEPEND="gnustep-base/gnustep-make
		dev-libs/icu
		dev-libs/libffi
		dev-libs/libxml2
		net-libs/gnutls
		sys-devel/gcc:*[objc]"

RDEPEND="${DEPEND}"
BDEPEND=""
PATCHES=(
        "${FILESDIR}"/${PN}-1.29.0-libxml2-2.11.patch
)

src_install() {
				sed -i '/gzip/d' ${WORKDIR}/${P}/Tools/Makefile.postamble
				sed -i '/gzip/d' ${WORKDIR}/${P}/Tools/make_strings/GNUmakefile.postamble
				if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
					emake DESTDIR="${D}" install
				fi
}
