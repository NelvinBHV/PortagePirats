# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="This is the Cockpit user interface for podman containers"
HOMEPAGE="https://cockpit-project.org/"
KEYWORDS="amd64"
SRC_URI="https://github.com/cockpit-project/cockpit-podman/releases/download/133/cockpit-podman-133.tar.xz -> cockpit-podman-133.tar.xz"

S="${WORKDIR}/cockpit-podman"
LICENSE="LGPL-2.1"
SLOT="0"

BDEPEND="sys-devel/gettext"

RDEPEND="${DEPEND}
	app-admin/cockpit
	app-containers/podman
"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
