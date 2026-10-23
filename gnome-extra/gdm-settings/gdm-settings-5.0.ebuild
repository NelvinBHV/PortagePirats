# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

# WICHTIG: gnome2-utils hinzugefügt, damit gnome2_schemas_update funktioniert
inherit meson python-single-r1 xdg gnome2-utils

DESCRIPTION="Ein grafisches Werkzeug zum Anpassen der GDM-Einstellungen (GNOME Display Manager)"
HOMEPAGE="https://github.com/gdm-settings/gdm-settings"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=gui-libs/gtk-4.10:4[introspection]
	>=gui-libs/libadwaita-1.4:1[introspection]
	sys-auth/polkit
	gnome-base/gdm
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
"

BDEPEND="
	${RDEPEND}
	dev-util/blueprint-compiler
	dev-util/glib-utils
	sys-devel/gettext
"

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/bin/gdm-settings"
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
