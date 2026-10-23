# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official additional texture libraries for Sweet Home 3D"
HOMEPAGE="https://www.sweethome3d.com/import-textures/"
TEXTURE_URI="https://downloads.sourceforge.net/project/sweethome3d/SweetHome3D-textures/Textures-${PV}"
SRC_URI="
	contributions? ( ${TEXTURE_URI}/Textures-Contributions-${PV}.zip )
	eteks-scopia? ( ${TEXTURE_URI}/Textures-eTeksScopia-${PV}.zip )
"
S="${WORKDIR}/${P}"

LICENSE="CC-BY-4.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="+contributions +eteks-scopia"
REQUIRED_USE="|| ( contributions eteks-scopia )"

BDEPEND="app-arch/unzip"
RDEPEND="media-gfx/sweethome3d"

unpack_library() {
	local library=${1}
	local archive="Textures-${library}-${PV}.zip"

	mkdir -p "${S}/${library}" || die
	unzip -q "${DISTDIR}/${archive}" -d "${S}/${library}" ||
		die "Unpacking ${archive} failed"
}

src_unpack() {
	use contributions && unpack_library Contributions
	use eteks-scopia && unpack_library eTeksScopia
}

install_library() {
	local library=${1}

	doins "${S}/${library}"/*.sh3t
	newdoc "${S}/${library}/LICENSE.TXT" "LICENSE-${library}.TXT"
}

src_install() {
	insinto /usr/share/sweethome3d/textures
	use contributions && install_library Contributions
	use eteks-scopia && install_library eTeksScopia

	# README.TXT ist in beiden Upstream-Archiven identisch.
	local library
	for library in Contributions eTeksScopia; do
		if [[ -f ${S}/${library}/README.TXT ]]; then
			dodoc "${S}/${library}/README.TXT"
			break
		fi
	done
}

pkg_postinst() {
	einfo "The selected texture libraries are loaded automatically by Sweet Home 3D."
	einfo "User-imported libraries remain in ~/.eteks/sweethome3d/textures."
}
