# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Simple Signed Certificate Generator"
HOMEPAGE="https://github.com/sgallagher/sscg"

KEYWORDS="amd64"
SRC_URI="https://github.com/sgallagher/sscg/archive/sscg-4.0.4.tar.gz -> sscg-4.0.4.tar.gz"

S="${WORKDIR}/sscg-sscg-4.0.4"
LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	sys-libs/talloc
	>=dev-libs/popt-1.14
	>=dev-libs/openssl-3.0.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
"

DOCS=( README.md )
