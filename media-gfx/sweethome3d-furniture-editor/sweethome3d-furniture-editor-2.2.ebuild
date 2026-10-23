# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 xdg

MY_PN="FurnitureLibraryEditor"

DESCRIPTION="Sweet Home 3D furniture editor and manufacturer model importer"
HOMEPAGE="https://www.sweethome3d.com/import-models/"
SRC_URI="https://downloads.sourceforge.net/project/sweethome3d/FurnitureLibraryEditor/${MY_PN}-${PV}.jar"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror strip"

RDEPEND="
	>=virtual/jre-1.8
	app-arch/libarchive
	media-gfx/sweethome3d
	media-libs/assimp
"
BDEPEND="app-arch/unzip"

src_unpack() {
	cp "${DISTDIR}/${MY_PN}-${PV}.jar" "${S}/" || die
	unzip -p "${DISTDIR}/${MY_PN}-${PV}.jar" \
		com/eteks/furniturelibraryeditor/resources/frameIcon.png \
		> "${S}/${PN}.png" || die
}

src_install() {
	java-pkg_newjar "${MY_PN}-${PV}.jar" "${PN}.jar"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar"

	dobin "${FILESDIR}/sweethome3d-manufacturer-import"
	dodoc "${FILESDIR}/HERSTELLERQUELLEN.md"
	newicon -s 32 "${PN}.png" "${PN}.png"
	make_desktop_entry \
		"${PN}" \
		"Sweet Home 3D Bibliothekseditor" \
		"${PN}" \
		"Graphics;3DGraphics;"
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "Herstellerarchive vorbereiten:"
	einfo "  sweethome3d-manufacturer-import --manufacturer NAME --input ARCHIV"
	einfo "Anschliessend die aufgelisteten Modelle im Bibliothekseditor importieren."
}

pkg_postrm() {
	xdg_pkg_postrm
}
