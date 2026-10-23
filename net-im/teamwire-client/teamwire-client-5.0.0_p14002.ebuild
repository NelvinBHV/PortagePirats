# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

MY_UPSTREAM_VERSION="${PV%%_p*}"

DESCRIPTION="Secure Teamwire business messenger desktop client"
HOMEPAGE="https://www.teamwire.eu/"
SRC_URI="https://desktop.teamwire.eu/dist/v${MY_UPSTREAM_VERSION}/teamwire-${MY_UPSTREAM_VERSION}-linux-amd64.deb -> ${P}.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ayatana"

RESTRICT="bindist mirror strip"
QA_PREBUILT="opt/Teamwire/**"

BDEPEND="app-arch/dpkg"

RDEPEND="
	app-accessibility/at-spi2-core
	app-crypt/libsecret
	dev-libs/glib
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/util-linux
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils
	ayatana? ( dev-libs/libayatana-appindicator )
"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	cp -a "${S}"/opt "${ED}"/ || die
	cp -a "${S}"/usr "${ED}"/ || die

	# The Debian package uses a non-Gentoo doc path and ships compressed docs.
	rm -rf "${ED}/usr/share/doc/teamwire" || die

	# Upstream bundles native Node prebuilds for multiple operating systems and
	# architectures. Keep the Linux x86_64 payload used by this amd64 ebuild.
	find "${ED}/opt/Teamwire/resources/app.asar.unpacked/node_modules" \
		-path "*/prebuilds/*" -type d \
		! -path "*/prebuilds/linux-x64" \
		! -path "*/prebuilds/linux-x64/*" \
		-prune -exec rm -rf {} + || die

	# Electron needs its sandbox helper setuid root when unprivileged user
	# namespaces are unavailable or disabled.
	fperms 4755 /opt/Teamwire/chrome-sandbox
	fperms 0755 /opt/Teamwire/teamwire
	fperms 0755 /opt/Teamwire/resources/bin/ffmpeg/ffmpeg

	dosym /opt/Teamwire/teamwire /usr/bin/teamwire

	if [[ -f "${ED}/usr/share/applications/teamwire.desktop" ]]; then
		sed -i \
			-e 's|^Exec=/opt/Teamwire/teamwire|Exec=teamwire|' \
			"${ED}/usr/share/applications/teamwire.desktop" || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
