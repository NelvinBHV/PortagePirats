# Copyright 2026
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit python-single-r1 desktop xdg gnome2-utils

DESCRIPTION="Web Application Manager (Linux Mint XApp)"
HOMEPAGE="https://github.com/linuxmint/webapp-manager"
SRC_URI="https://github.com/linuxmint/webapp-manager/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}/webapp-manager-${PV}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	sys-devel/gettext
"

RDEPEND="
	${PYTHON_DEPS}
	>=x11-libs/xapp-1.4[introspection]
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/tldextract[${PYTHON_USEDEP}]
	')
"

DEPEND="${RDEPEND}"

src_prepare() {
	default
	python_fix_shebang usr/lib/webapp-manager

	# Upstream uses Linux Mint specific "xsi-*" icon names.  On plain
	# Gentoo/GNOME those names are usually not available and GTK falls back
	# to a generic image icon.  Use freedesktop/Adwaita compatible names.
	sed -i \
		-e 's/xsi-list-add-symbolic/list-add-symbolic/g' \
		-e 's/xsi-list-remove-symbolic/list-remove-symbolic/g' \
		-e 's/xsi-document-edit-symbolic/document-edit-symbolic/g' \
		-e 's/xsi-web-browser-symbolic/web-browser-symbolic/g' \
		-e 's/xsi-insert-image-symbolic/insert-image-symbolic/g' \
		-e 's/xsi-open-menu-symbolic/open-menu-symbolic/g' \
		-e 's/xsi-keyboard-shortcuts-symbolic/preferences-desktop-keyboard-shortcuts-symbolic/g' \
		-e 's/xsi-help-about-symbolic/help-about-symbolic/g' \
		-e 's/xsi-exit-symbolic/application-exit-symbolic/g' \
		usr/share/webapp-manager/webapp-manager.ui \
		usr/lib/webapp-manager/webapp-manager.py || die
}

src_compile() {
	emake buildmo
}

src_install() {
        # Launcher
        dobin usr/bin/webapp-manager

        # Python app files
        insinto /usr/lib/webapp-manager
        doins -r usr/lib/webapp-manager/.

        # Hauptprogramm muss executable sein, sonst "Permission denied"
        exeinto /usr/lib/webapp-manager
        doexe usr/lib/webapp-manager/webapp-manager.py

        # Desktop entry
        domenu usr/share/applications/*.desktop
        sed -i -e '/^\[Desktop Entry\]/,/^\[/{s/\(^Categories=.*\)Application;*/\1/}' \
                "${ED}/usr/share/applications/webapp-manager.desktop" || die

        # Icons
        insinto /usr/share/icons
        doins -r usr/share/icons/.

    # UI
    insinto /usr/share/webapp-manager
    doins -r usr/share/webapp-manager/.


        # XDG menu integration
        insinto /etc/xdg
        doins -r etc/xdg/.

        # GSettings schema
        insinto /usr/share/glib-2.0/schemas
        doins usr/share/glib-2.0/schemas/*.gschema.xml

        # Locales produced by buildmo
        insinto /usr/share/locale
        doins -r usr/share/locale/.
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
