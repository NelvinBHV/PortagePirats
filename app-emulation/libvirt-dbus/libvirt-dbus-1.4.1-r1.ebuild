# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="DBus protocol binding for libvirt native C API"
HOMEPAGE="https://libvirt.org/dbus.html"
SRC_URI="https://gitlab.com/libvirt/libvirt-dbus/-/archive/v1.4.1/libvirt-dbus-v1.4.1.tar.bz2 -> libvirt-dbus-1.4.1.tar.bz2"
S="${WORKDIR}/libvirt-dbus-v1.4.1"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64"

IUSE="systemd"

DEPEND="
	>=app-emulation/libvirt-3.0.0:=
	>=app-emulation/libvirt-glib-0.0.7
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}
	acct-user/libvirtdbus
	sys-auth/polkit
"
BDEPEND="
	dev-python/docutils
"

src_configure() {
	local emesonargs=(
		-Dinit_script=$(usex systemd systemd other)
	)
	meson_src_configure
}
