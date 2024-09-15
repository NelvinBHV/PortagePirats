# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs flag-o-matic 
RESTRICT="mirror"
MY_PV=$(ver_rs 1- _)
DESCRIPTION="The makefile package write makefiles for a GNUstep-based project"
HOMEPAGE="https://github.com/gnustep/tools-make"
SRC_URI="https://github.com/gnustep/tools-make/releases/download/make-${MY_PV}/gnustep-make-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm64 ~amd64"

DEPEND="dev-build/make
		sys-devel/gcc:*[objc]"

RDEPEND="${DEPEND}"
BDEPEND=""
src_install() {
				sed -i '/which gzip/d' ${WORKDIR}/${P}/GNUmakefile.in
				LINE=$(grep -n '/man7"; \\' ${WORKDIR}/${P}/GNUmakefile.in | tail -n1 | cut -d ":" -f1)
				echo $LINE
				sed -i ''$LINE's/man7"; \\/man7"; \)/' ${WORKDIR}/${P}/GNUmakefile.in
				sed -i 's/ (and compressing) / /' ${WORKDIR}/${P}/GNUmakefile.in
				if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
					emake DESTDIR="${D}" install
				fi
}
