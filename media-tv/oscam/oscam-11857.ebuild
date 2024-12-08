
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3
RESTRICT="mirror"
DESCRIPTION="oscam: Open Source Conditional Access Modul"
HOMEPAGE="https://git.streamboard.tv/common/oscam"
EGIT_REPO_URI="https://git.streamboard.tv/common/oscam.git"
EGIT_COMMIT="527d8e1a9bab59b77216083e45742c61cd0ed7d1"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 arm"

IUSE_ADDON="webif webif_livelog webif_jquery with_compress_webif with_ssl have_dvbapi with_extended_cw with_neutrino read_sdt_charsets cs_anticasc with_debug module_monitor with_lb cs_cacheex cs_cacheex_aio cw_cycle_check lcdsupport ledsupport clockfix ipv6support with_arm_neon with_signing"
IUSE_MODULE="module_camd33 module_camd35 module_camd35_tcp module_newcamd module_cccam module_cccshare module_gbox module_radegast module_scam module_serial module_constcw module_pandora module_ghttp module_streamrelay"
IUSE_READER="reader_nagra reader_nagra_merlin reader_irdeto reader_conax reader_cryptoworks reader_seca reader_viaccess reader_videoguard reader_dre reader_tongfang reader_bulcrypt reader_griffin reader_dgcrypt"
IUSE_CARD="cardreader_phoenix cardreader_internal cardreader_sc8in1 cardreader_mp35 cardreader_smargo cardreader_db2com cardreader_stapi cardreader_stapi5 cardreader_stinger cardreader_drecas"

IUSE="systemd ${IUSE_ADDON} ${IUSE_MODULE} ${IUSE_READER} ${IUSE_CARD}"

DEPEND="dev-build/cmake"
RDEPEND="dev-libs/openssl"

BDEPEND=""

src_configure() {
	cd ${S}
	USEFLAGS=$(echo ${USE} | tr [:lower:] [:upper:])
	echo $USEFLAGS
	./config.sh --disable all --enable ${USEFLAGS}
}
src_compile () {
	emake OSCAM_BIN=oscam CONF_DIR=/etc/oscam
}
src_install () {
	dobin "${FILESDIR}/oscam_watchdog.sh" || die "dobin oscam_watchdog.sh failed"
	dobin "oscam"
	insinto "/etc/${PN}"
	doins -r Distribution/doc/example/*
	if use systemd ; then
		insinto /lib/systemd/system
        	newins ${FILESDIR}/${PN}.service ${PN}.service
	else
		newinitd "${FILESDIR}/${PN}.initd" oscam
		newconfd "${FILESDIR}/${PN}.confd" oscam
	fi
	keepdir "/var/log/${PN}/emm"
}

pkg_postinst() {
	systemctl daemon-reload
	if systemctl is-active --quiet oscam; then
		systemctl restart oscam
		echo "Der Service oscam wurde neu gestartet."
	fi
}
