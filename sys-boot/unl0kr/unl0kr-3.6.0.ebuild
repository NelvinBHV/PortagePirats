# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

LVGL_COMMIT="85aa60d18b3d5e5588d7b247abf90198f07c8a63"
LVGL_SHORT="85aa60d18b3d"

DESCRIPTION="LVGL based graphical disk unlocker for initramfs"
HOMEPAGE="https://gitlab.postmarketos.org/postmarketOS/buffybox"
SRC_URI="
	https://gitlab.postmarketos.org/postmarketOS/buffybox/-/archive/${PV}/buffybox-${PV}.tar.bz2 -> buffybox-${PV}.tar.bz2
	https://github.com/lvgl/lvgl/archive/${LVGL_COMMIT}.tar.gz -> lvgl-${LVGL_SHORT}.tar.gz
"

LICENSE="GPL-3+ Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="doc drm dracut fbdev-force-refresh"

S="${WORKDIR}/buffybox-${PV}"

BDEPEND="
	dev-build/meson
	virtual/pkgconfig
	doc? ( app-text/scdoc )
"
DEPEND="
	dev-libs/inih
	dev-libs/libinput
	sys-apps/systemd
	x11-libs/libxkbcommon
	drm? ( x11-libs/libdrm )
"
RDEPEND="
	${DEPEND}
	dracut? (
		sys-fs/cryptsetup
		sys-kernel/dracut
	)
"

src_prepare() {
	default

	rm -rf lvgl || die
	mv "${WORKDIR}/lvgl-${LVGL_COMMIT}" lvgl || die
}

src_configure() {
	local backends="framebuffer"
	use drm && backends="framebuffer,drm"

	local emesonargs=(
		-Dsystemd=true
		-Dlvgl_backends="${backends}"
		-Dman="$(usex doc true false)"
	)
	meson_src_configure
}

src_compile() {
	meson compile -C "${BUILD_DIR}" unl0kr/unl0kr unl0kr/unl0kr-agent || die
}

src_install() {
	meson install -C "${BUILD_DIR}" --tags=unl0kr --destdir "${D}" || die

	insinto /etc
	doins "${FILESDIR}/unl0kr.conf"

	if use fbdev-force-refresh; then
		insinto /etc/unl0kr.conf.d
		newins "${FILESDIR}/unl0kr-fbdev-force-refresh.conf" 10-fbdev-force-refresh.conf
	fi

	if use dracut; then
		exeinto /usr/lib/dracut/modules.d/91unl0kr-agent
		doexe "${FILESDIR}/module-setup.sh"

		insinto /usr/lib/dracut/modules.d/91unl0kr-agent
		doins "${FILESDIR}/unl0kr-agent.path" "${FILESDIR}/unl0kr-agent.service"

		insinto /etc/dracut.conf.d
		doins "${FILESDIR}/91-unl0kr-agent.conf"
	fi
}

pkg_postinst() {
	elog "unl0kr was installed as a graphical password agent for the initramfs."
	elog ""
	elog "Configuration files:"
	elog "  /etc/unl0kr.conf"
	elog "  /etc/unl0kr.conf.d/*.conf"
	elog ""
	elog "Recommended USE flags for a dracut/systemd initramfs:"
	elog "  sys-boot/unl0kr drm dracut"
	elog ""
	elog "USE flag notes:"
	elog "  drm                 Use the DRM/KMS display backend. This is preferred on most modern systems."
	elog "  dracut              Install the 91unl0kr-agent dracut module."
	elog "  fbdev-force-refresh Only use as fallback if the framebuffer display does not refresh."
	elog "  doc                 Build man pages."
	elog ""
	if use dracut; then
		elog "dracut integration:"
		elog "  The dracut module was installed as:"
		elog "    /usr/lib/dracut/modules.d/91unl0kr-agent"
		elog "  The module is enabled by:"
		elog "    /etc/dracut.conf.d/91-unl0kr-agent.conf"
		elog ""
		elog "Requirements:"
		elog "  The initramfs must use systemd, because unl0kr-agent answers"
		elog "  systemd ask-password requests from systemd-cryptsetup."
		elog ""
		elog "Boot loader / kernel command line:"
		elog "  Keep using the normal dracut/systemd LUKS parameters, for example:"
		elog "    rd.luks.uuid=<UUID>"
		elog "  unl0kr does not replace cryptsetup; it only provides the password UI."
		elog ""
		elog "After changing USE flags, /etc/unl0kr.conf, crypttab or kernel parameters:"
		elog "    dracut -f"
		elog ""
		elog "Before rebooting, verify that the initramfs contains unl0kr:"
		elog "    lsinitrd | grep -E 'unl0kr|91unl0kr-agent'"
		elog ""
		elog "Keep a known-good boot entry or rescue medium available until the"
		elog "new initramfs has successfully unlocked the root filesystem once."
	else
		elog "USE=dracut is disabled. No dracut module was installed."
		elog "Enable USE=dracut if this package should be used during early boot."
	fi
}
