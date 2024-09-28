
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3

DESCRIPTION="TV streaming server for Linux"
HOMEPAGE="https://tvheadend.org/"
EGIT_REPO_URI="https://github.com/tvheadend/tvheadend.git"
EGIT_COMMIT="28de5c092c657ffbbffa422c2ca3c07ba513c567"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64 amd64 x86"
IUSE="cardclient ccache dbus dvb fdkaac ffmpeg hdhomerun inotify iptv nvenc pcre2 pngquant satip systemd uriparser vaapi xmltv zeroconf zlib"

DEPEND="
	acct-user/tvheadend
	ccache? ( dev-util/ccache )
	dbus? ( sys-apps/dbus )
	dev-vcs/git
	dvb? (
		media-tv/dtv-scan-tables
		media-tv/linuxtv-dvb-apps
		)
	cardclient? ( media-libs/libdvbcsa )
	fdkaac? ( media-libs/fdk-aac )
	ffmpeg? ( media-video/ffmpeg )
	hdhomerun? ( media-libs/libhdhomerun )
	inotify? ( sys-fs/inotify-tools )
	nvenc? ( media-video/nvidia-video-codec )
	pcre2? ( dev-libs/libpcre2 )
	pngquant? ( media-gfx/pngquant )
	systemd? ( sys-apps/systemd )
	uriparser? ( dev-libs/uriparser )
	virtual/libiconv
	vaapi? ( media-libs/libva )
	xmltv? ( media-tv/xmltv )
	zeroconf? ( net-dns/avahi )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	econf \
		--disbale-bundle \
		--disable-dvbscan \
		--disable-ffmpeg_static \
		--disable-hdhomerun_static \
		$(use_enable cardclient cardclient) \
		$(use_enable cardclient tvhcsa) \
		$(use_enable ccache) \
		$(use_enable dbus dbus_1) \
		$(use_enable hdhomerun hdhomerun_client) \
		$(use_enable hdhomerun hdhomerun_server) \
		$(use_enable inotify) \
		$(use_enable iptv) \
		$(use_enable ffmpeg libav) \
		$(use_enable fdkaac libfdkaac) \
		$(use_enable nvenc) \
		$(use_enable pcre2) \
		$(use_enable pngquant) \
		$(use_enable satip satip_server) \
		$(use_enable satip satip_client) \
		$(use_enable uriparser) \
		$(use_enable vaapi) \
		$(use_enable zeroconf avahi) \
		$(use_enable zlib)
}

src_install() {
	default
	newinitd "${FILESDIR}"/tvheadend.initd tvheadend
	newconfd "${FILESDIR}"/tvheadend.confd tvheadend
	if use systemd ; then
		insinto /lib/systemd/system
		newins "${FILESDIR}/${PN}.service" ${PN}.service
		insinto /etc/default
		newins "${FILESDIR}/${PN}.confd" ${PN}
	else
		newinitd "${FILESDIR}/${PN}.initd" ${PN}
		newconfd "${FILESDIR}/${PN}.confd" ${PN}
	fi
}

pkg_postinst() {
	if use systemd ; then
		systemctl daemon-reload
		if systemctl is-active --quiet ${PN}; then
			systemctl restart ${PN}
			echo "Der Service ${PN} wurde neu gestartet."
		fi
		elog "You can find the service configuration at:"
		elog "/etc/default/${PN}"
	else
		elog "You can find the daemon configuration at:"
		elog "/etc/conf.d/${PN}"
	fi
	elog
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."
}
