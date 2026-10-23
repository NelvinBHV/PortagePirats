# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official additional furniture libraries for Sweet Home 3D"
HOMEPAGE="https://www.sweethome3d.com/import-models/"
MODEL_URI="https://downloads.sourceforge.net/project/sweethome3d/SweetHome3D-models/3DModels-${PV}"
SRC_URI="
	blendswap-cc0? ( ${MODEL_URI}/3DModels-BlendSwap-CC-0-${PV}.zip )
	blendswap-cc-by? ( ${MODEL_URI}/3DModels-BlendSwap-CC-BY-${PV}.zip )
	contributions? ( ${MODEL_URI}/3DModels-Contributions-${PV}.zip )
	katorlegaz? ( ${MODEL_URI}/3DModels-KatorLegaz-${PV}.zip )
	lucapresidente? ( ${MODEL_URI}/3DModels-LucaPresidente-${PV}.zip )
	scopia? ( ${MODEL_URI}/3DModels-Scopia-${PV}.zip )
"
S="${WORKDIR}/${P}"

LICENSE="
	blendswap-cc0? ( CC0-1.0 )
	blendswap-cc-by? ( CC-BY-3.0 )
	contributions? ( Free-Art-1.3 )
	katorlegaz? ( CC-BY-3.0 )
	lucapresidente? ( Free-Art-1.3 )
	scopia? ( CC-BY-3.0 )
"
SLOT="0"
KEYWORDS="amd64"
IUSE="
	+blendswap-cc0
	+blendswap-cc-by
	+contributions
	+katorlegaz
	+lucapresidente
	+scopia
"
REQUIRED_USE="|| ( blendswap-cc0 blendswap-cc-by contributions katorlegaz lucapresidente scopia )"

BDEPEND="app-arch/unzip"
RDEPEND="media-gfx/sweethome3d"

unpack_library() {
	local library=${1}
	local archive="3DModels-${library}-${PV}.zip"

	mkdir -p "${S}/${library}" || die
	unzip -q "${DISTDIR}/${archive}" -d "${S}/${library}" ||
		die "Unpacking ${archive} failed"
}

src_unpack() {
	use blendswap-cc0 && unpack_library BlendSwap-CC-0
	use blendswap-cc-by && unpack_library BlendSwap-CC-BY
	use contributions && unpack_library Contributions
	use katorlegaz && unpack_library KatorLegaz
	use lucapresidente && unpack_library LucaPresidente
	use scopia && unpack_library Scopia
}

install_library() {
	local library=${1}

	doins "${S}/${library}"/*.sh3f
	newdoc "${S}/${library}/LICENSE.TXT" "LICENSE-${library}.TXT"
}

src_install() {
	insinto /usr/share/sweethome3d/furniture
	use blendswap-cc0 && install_library BlendSwap-CC-0
	use blendswap-cc-by && install_library BlendSwap-CC-BY
	use contributions && install_library Contributions
	use katorlegaz && install_library KatorLegaz
	use lucapresidente && install_library LucaPresidente
	use scopia && install_library Scopia

	# README.TXT is identical in all upstream archives.
	local library
	for library in BlendSwap-CC-0 BlendSwap-CC-BY Contributions KatorLegaz LucaPresidente Scopia; do
		if [[ -f ${S}/${library}/README.TXT ]]; then
			dodoc "${S}/${library}/README.TXT"
			break
		fi
	done
}

pkg_postinst() {
	einfo "The selected furniture libraries are loaded automatically by Sweet Home 3D."
	einfo "User-imported libraries remain in ~/.eteks/sweethome3d/furniture."
}
