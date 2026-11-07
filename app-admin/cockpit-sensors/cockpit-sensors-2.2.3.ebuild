# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="This is the Cockpit user interface for sensors"
HOMEPAGE="https://github.com/ocristopfer/cockpit-sensors"
KEYWORDS="amd64"
SRC_URI="https://github.com/ocristopfer/cockpit-sensors/releases/download/2.2.3/cockpit-sensors-2.2.3.tar.xz -> cockpit-sensors-2.2.3.tar.xz"

S="${WORKDIR}/cockpit-sensors"
LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND="sys-devel/gettext"

RDEPEND="${DEPEND}
	>=app-admin/cockpit-137
	sys-apps/lm-sensors
"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
