# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="ensurepip(-)"

inherit ninja-utils python-any-r1 toolchain-funcs

QEMU_VERSION="11.0.1"
AMIBERRY_RELEASE="11.0.1-amiberry.7"

DESCRIPTION="QEMU-based PowerPC plugin for UAE-compatible Amiga emulators"
HOMEPAGE="https://github.com/BlitterStudio/amiberry-qemu-uae https://www.qemu.org/"
SRC_URI="
	https://download.qemu.org/qemu-${QEMU_VERSION}.tar.xz -> ${P}-qemu.tar.xz
	https://github.com/BlitterStudio/amiberry-qemu-uae/archive/refs/tags/v${AMIBERRY_RELEASE}.tar.gz -> ${P}-patches.tar.gz
"
S="${WORKDIR}/qemu-${QEMU_VERSION}"

LICENSE="GPL-2 LGPL-2 BSD-2 GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="+slirp"

RESTRICT="test"

RDEPEND="
	dev-libs/glib:2
	virtual/zlib:=
	slirp? ( net-libs/libslirp:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/distlib[${PYTHON_USEDEP}]
	')
	app-alternatives/ninja
	dev-build/meson
	dev-lang/perl
	virtual/pkgconfig
"

PATCH_ROOT="${WORKDIR}/amiberry-qemu-uae-${AMIBERRY_RELEASE}"

python_check_deps() {
	python_has_version "dev-python/distlib[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	local patches=( "${PATCH_ROOT}"/patches/*.patch )
	eapply "${patches[@]}"
	chmod +x configure-qemu-uae || die
}

src_configure() {
	local myconf=(
		--prefix=/usr
		--libdir=/usr/$(get_libdir)
		--disable-download
		--python="${PYTHON}"
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
		--host-cc="$(tc-getBUILD_CC)"
		$(use_enable slirp)
	)

	./configure-qemu-uae "${myconf[@]}" || die "configure-qemu-uae failed"
}

src_compile() {
	eninja -C build qemu-uae.so
}

src_install() {
	local plugin_dir="/usr/$(get_libdir)/fs-uae/plugins/QEMU-UAE"

	insinto "${plugin_dir}"
	doins build/qemu-uae.so

	cat > "${T}/Plugin.ini" <<-EOF_PLUGIN || die
	[plugin]
	name = QEMU-UAE
	version = 3.8.2
	EOF_PLUGIN
	doins "${T}/Plugin.ini"

	dodoc "${PATCH_ROOT}/README.md" "${PATCH_ROOT}/patches/README.md"
}

pkg_postinst() {
	einfo "QEMU-UAE 3.8.2 wurde systemweit installiert."
	einfo "FS-UAE 3.2 muss diesen Pfad als plugins_dir verwenden:"
	einfo "/usr/$(get_libdir)/fs-uae/plugins"
}
