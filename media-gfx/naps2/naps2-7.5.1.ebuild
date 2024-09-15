
# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
RESTRICT="mirror strip"
inherit desktop flag-o-matic xdg-utils rpm
DESCRIPTION="NAPS2 - Not Another PDF Scanner"
HOMEPAGE="https://www.naps2.com/"

MY_PV=${PV/_beta/b}
SRC_URI="https://github.com/cyanfish/naps2/releases/download/v${MY_PV}/naps2-${MY_PV}-linux-x64.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-dotnet/dotnet-sdk-bin"

RDEPEND="${DEPEND}"
BDEPEND=""
src_unpack() {
		rpm_unpack ${A}
		mkdir ${P}
		mv usr ${P}
}
src_install() {
		#Install libs
		cd ${S}/usr/lib/
		insinto /usr/lib/
		doins -r naps2
		#Install desktop-files
		cd ${S}/usr/share/applications
		insinto /usr/share/applications
		doins naps2.desktop
		#Install icons
		cd ${S}/usr/share/icons/hicolor/128x128/apps
		insinto /usr/share/icons/hicolor/128x128/apps
		doins com.naps2.Naps2.png
		#Install metainfo
		cd ${S}/usr/share/metainfo
		insinto /usr/share/metainfo
		doins com.naps2.Naps2.metainfo.xml
}
pkg_postinst() {
		ln -s /usr/lib/naps2/naps2 /usr/bin/naps2
		chmod 755 /usr/lib/naps2/naps2
		chmod 755 /usr/lib/naps2/apphost
		chmod 755 /usr/lib/naps2/_linux/*
		chmod 755 /usr/lib/naps2/*.a
		chmod 755 /usr/lib/naps2/*.so
		xdg_desktop_database_update
		xdg_icon_cache_update
}
pkg_postrm() {
		rm /usr/bin/naps2
		xdg_desktop_database_update
		xdg_icon_cache_update
}
