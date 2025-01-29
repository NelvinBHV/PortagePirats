
# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8




inherit cargo meson gnome2-utils xdg-utils

#RESTRICT="fetch"
DESCRIPTION="Fotema - A photo gallery for Linux"
HOMEPAGE="https://github.com/blissd/fotema"
SRC_URI="${CARGO_CRATE_URIS}
https://github.com/blissd/fotema/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/microsoft/onnxruntime/releases/download/v1.16.0/onnxruntime-linux-x64-1.16.0.tgz"
LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="enable-symlink"

DEPEND="
	dev-libs/openssl:=
	gui-libs/libadwaita
	media-libs/fontconfig
	media-libs/graphene
	media-libs/lcms:2
	media-libs/libshumate:=
	media-libs/opencv:=[contribdnn]
	media-video/ffmpeg:=
	sci-libs/onnx
	sys-libs/libseccomp
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	media-libs/glycin-loaders
"
RDEPEND="${DEPEND}
	gnome-base/dconf
"
BDEPEND="${BDEPEND}
	virtual/pkgconfig"
ECARGO_VENDOR=${S}/vendor
PATCHES=(
	"${FILESDIR}/fotema-${PV}-desktop.patch"
)

src_unpack() {
	default
	cargo_src_unpack
}

src_prepare() {
	# Apply changes for gentoo
	sed -i "/cargo_env = \[ CARGO_HOME= \+ meson.project_build_root() \/ cargo-home \]/d" ${S}/src/meson.build || die "sed failed"
	sed -i "/env,/d" ${S}/src/meson.build || die "sed failed"
	sed -i "/cargo_env,/d" ${S}/src/meson.build || die "sed failed"
	if [ -x "${S}/build-aux/dist-vendor.sh" ]; then
		bash "${S}/build-aux/dist-vendor.sh"
	fi
	if use enable-symlink; then
		eapply "${FILESDIR}/fotema-${PV}-symlink.patch"
	fi
	eapply_user
	default
}

src_configure() {
	export ORT_STRATEGY=system
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
	dodir /usr/lib64
	insinto /usr/lib64
	doins "${WORKDIR}/onnxruntime-linux-x64-1.16.0/lib/libonnxruntime.so" \
	"${WORKDIR}/onnxruntime-linux-x64-1.16.0/lib/libonnxruntime.so.1.16.0"
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_gdk_pixbuf_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_gdk_pixbuf_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
