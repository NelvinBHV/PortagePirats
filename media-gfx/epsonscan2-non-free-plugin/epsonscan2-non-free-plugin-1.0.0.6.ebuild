# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
RESTRICT="mirror"
inherit desktop flag-o-matic xdg-utils rpm

DESCRIPTION="Epson Scan 2 Non Free Plugins"
HOMEPAGE="https://support.epson.net/linux/en/epsonscan2.php"
SRC_URI="https://download.ebz.epson.net/dsc/du/02/DriverDownloadInfo.do?LG2=JA&CN2=US&CTI=171&PRN=Linux%20rpm%2064bit%20package&OSC=LX&DL -> epsonscan-bundle.rpm.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
src_unpack() {
		unpack ${A}
		mv epsonscan2* ${P}
		cd ${S}
		rpm_unpack ./plugins/epsonscan2-non-free-plugin-${PV}-1.x86_64.rpm

}
src_install() {
		insopts -m0755
		cd ${S}/usr/lib64/epsonscan2
		insinto	/usr/lib64/epsonscan2/
		doins -r libexec non-free-exec
		cd ${S}/usr/lib64
		insinto /usr/lib64
		doins -r epsonscan2-ocr
		cd ${S}/usr/libexec
		insinto /usr/libexec
		doins -r epsonscan2-ocr
		cd ${S}/usr/share/
		insinto /usr/share
		doins -r epsonscan2 epsonscan2-ocr
}
