# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A filesystem browser for Cockpit"
HOMEPAGE="https://cockpit-project.org/"
KEYWORDS="amd64"
SRC_URI="https://github.com/cockpit-project/cockpit-files/releases/download/47/cockpit-files-47.tar.xz -> cockpit-files-47.tar.xz"

S="${WORKDIR}/cockpit-files"
LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND="sys-devel/gettext"

RDEPEND="
	>=app-admin/cockpit-318
"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
