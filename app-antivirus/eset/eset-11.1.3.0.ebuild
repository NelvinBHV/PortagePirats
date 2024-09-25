
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
RESTRICT="mirror"

inherit systemd

DESCRIPTION="ESET Endpoint Antivirus für Linux"
HOMEPAGE="https://www.eset.com"
SRC_URI="https://download.eset.com/com/eset/apps/business/eea/linux/g2/latest/eeau_x86_64.bin"

LICENSE="eset-EULA"
SLOT="0"
KEYWORDS="~amd64"

IUSE="systemd"
REQUIRED_USE="systemd"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
src_unpack() {
	cd ${WORKDIR}
	bash ${DISTDIR}/eeau_x86_64.bin -n -y > /dev/null 2>&1
	rm *.rpm
	unpack ${WORKDIR}/*.deb
	mkdir -p ${S}
	tar xf  ${WORKDIR}/data.tar.gz -C "${S}"
}
src_prepare() {
	default
	patchelf --set-rpath "/opt/eset/eea/lib" "${S}/opt/eset/eea/lib/libprotobuf.so.32"
}

src_install() {
	dodir /opt/eset/
	cp -r "${S}/opt/eset/" "${D}/opt/"
	dodir /var/opt/eset
	cp -r "${S}/var/opt/eset" "${D}/var/opt/"
	keepdir /var/log/eset/eea
	dodir /var/log/eset/eea
	keepdir /var/opt/eset/eea/modules_notice
	dodir /var/opt/eset/eea/modules_notice
	systemd_dounit "${S}/opt/eset/eea/etc/systemd/eea.service"
	systemd_dounit "${S}//opt/eset/eea/etc/systemd/eea_upgrade.service"
	systemd_dounit "${S}//opt/eset/eea/etc/systemd/eea-user-agent.service"
}
