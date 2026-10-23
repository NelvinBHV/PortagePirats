# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs xdg-utils

DATA_COMMIT="179b8762c3754594dde9c40f2b3ef1fcaee028e4"
DATA_P="GloomAmiga-${DATA_COMMIT}"

DESCRIPTION="Reimplementation of the Amiga FPS Gloom"
HOMEPAGE="https://github.com/Swizpig/ZGloom"
SRC_URI="
	https://github.com/Swizpig/ZGloom/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/earok/GloomAmiga/archive/${DATA_COMMIT}.zip -> ${DATA_P}.zip
"
S="${WORKDIR}/ZGloom-${PV}"

SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror test"

RDEPEND="
	media-libs/libpng:0=
	media-libs/libxmp
	media-libs/libsdl2[joystick,sound,video]
	media-libs/sdl2-mixer
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.0-amd64.patch"
)

src_compile() {
	emake \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LIBS="-lSDL2 -lSDL2_mixer -lxmp -lpng"
}

src_install() {
	exeinto /usr/libexec/${PN}
	doexe ZGloom

	newbin "${FILESDIR}"/zgloom-wrapper zgloom
	newicon screenshots/organs.png ${PN}.png
	make_desktop_entry zgloom ZGloom ${PN} Game

	insinto /usr/share/games/${PN}
	doins -r \
		"${WORKDIR}/${DATA_P}/maps" \
		"${WORKDIR}/${DATA_P}/misc" \
		"${WORKDIR}/${DATA_P}/objs" \
		"${WORKDIR}/${DATA_P}/pics" \
		"${WORKDIR}/${DATA_P}/sfxs" \
		"${WORKDIR}/${DATA_P}/txts"

	insinto /usr/share/games/${PN}/hd
	newins "${FILESDIR}"/HD-README.txt README.txt
	doins -r "${FILESDIR}"/hd-pack/hd/effects
	doins -r "${FILESDIR}"/hd-pack/hd/misc
	doins -r "${FILESDIR}"/hd-pack/hd/objs
	doins -r "${FILESDIR}"/hd-pack/hd/pics
	doins -r "${FILESDIR}"/hd-pack/hd/txts

	dodoc README.md "${WORKDIR}/${DATA_P}/README.md"
}

pkg_postinst() {
	elog "Optional kannst du das Datenverzeichnis auch ueber ZGLOOM_DATA_DIR"
	elog "auf einen anderen Pfad umbiegen."
	elog "Benutzerkonfiguration und Laufzeitlinks liegen unter"
	elog "  \${XDG_DATA_HOME:-~/.local/share}/zgloom"
	elog
	elog "Mitinstalliert werden die klassischen Gloom-Daten aus dem verlinkten"
	elog "GloomAmiga-Archiv. Zombie-Massacre-Daten sind damit nicht enthalten."
	elog
	elog "Ein generiertes Basis-HD-Pack fuer Texturen und Sprites wurde ebenfalls"
	elog "installiert. Eigene Overrides kannst du unter"
	elog "  \${XDG_DATA_HOME:-~/.local/share}/zgloom/hd"
	elog "ablegen."

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
