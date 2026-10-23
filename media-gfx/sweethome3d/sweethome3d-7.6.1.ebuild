# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 xdg

DESCRIPTION="Interior design application for drawing house plans in 2D and 3D"
HOMEPAGE="https://www.sweethome3d.com/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/SweetHome3D-source/SweetHome3D-${PV}-src/SweetHome3D-${PV}-src.zip"
S="${WORKDIR}/SweetHome3D-${PV}-src"

LICENSE="GPL-2+ Apache-2.0 BSD LGPL-2.1 MPL-1.1 Free-Art-1.3 CC-BY-3.0 CC-BY-SA-3.0 all-rights-reserved"
SLOT="0"
KEYWORDS="amd64"

# The Java application is compiled from source. Upstream's Java 3D, JOGL,
# JMF and YafaRay runtime payload contains prebuilt amd64 native libraries.
RESTRICT="bindist mirror strip"
QA_PREBUILT="
	usr/lib*/sweethome3d/java3d/*.so
	usr/lib*/sweethome3d/yafaray/*.so
	usr/lib*/sweethome3d/yafaray/yafaray-plugins/*.so
"

BDEPEND="
	app-arch/unzip
	dev-java/ant
	>=virtual/jdk-1.8:*
"
RDEPEND="
	dev-java/java-config:2
	>=virtual/jre-1.8:*
	media-libs/mesa
	x11-libs/libX11
	x11-libs/libXrender
	x11-libs/libXxf86vm
"

src_compile() {
	eant -Dversion="${PV}" \
		application furniture textures examples help jogl-java3d
}

src_prepare() {
	default
	sed "s|@GENTOO_LIBDIR@|$(get_libdir)|g" \
		"${FILESDIR}/${PN}" >"${T}/${PN}" || die
	chmod 0755 "${T}/${PN}" || die
}

src_install() {
	local app_dir=/usr/share/${PN}/lib
	local native_dir=/usr/$(get_libdir)/${PN}

	insinto "${app_dir}"
	doins \
		build/{SweetHome3D,Furniture,Textures,Examples,Help}.jar \
		lib/{batik-svgpathparser-1.7,freehep-vectorgraphics-svg-2.1.1c,iText-2.1.7,jeksparser-calculator,jmf,sunflow-0.07.3i}.jar \
		lib/java3d-1.6/{j3dcore,j3dutils,vecmath,gluegen-rt}.jar \
		build/java3d-1.6/jogl-java3d.jar \
		libtest/jnlp.jar

	insinto "${native_dir}/java3d"
	doins lib/java3d-1.6/linux/amd64/*.so

	insinto "${native_dir}/yafaray"
	doins lib/yafaray/linux/x64/*.so
	insinto "${native_dir}/yafaray/yafaray-plugins"
	doins lib/yafaray/linux/x64/yafaray-plugins/*.so

	dobin "${T}/${PN}"

	newicon -s 128 \
		src/com/eteks/sweethome3d/swing/resources/aboutIcon.png \
		${PN}.png
	make_desktop_entry --eapi9 ${PN} \
		--args "%f" \
		--name "Sweet Home 3D" \
		--icon ${PN} \
		--categories "Graphics;2DGraphics;3DGraphics;" \
		--entry "MimeType=application/x-sweethome3d;application/x-sweethome3d-furniture-library;application/x-sweethome3d-textures-library;application/x-sweethome3d-plugin;application/x-sweethome3d-language-library;" \
		--entry "Keywords=home;house;interior;design;floor;plan;3D;"

	insinto /usr/share/mime/packages
	doins "${FILESDIR}/${PN}.xml"

	dodoc README.TXT LICENSE.TXT THIRDPARTY-LICENSE-*
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "The default Java heap limit is 4 GiB on this amd64 package."
	einfo "Override it per launch with SWEETHOME3D_JAVA_OPTS if required."
}

pkg_postrm() {
	xdg_pkg_postrm
}
