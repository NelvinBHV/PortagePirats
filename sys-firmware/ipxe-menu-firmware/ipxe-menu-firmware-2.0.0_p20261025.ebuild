# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

COMMIT="39a440d082a65a5b8e11e734cd6caf0991b70771"

DESCRIPTION="iPXE BIOS and x86_64 UEFI firmware with graphical PNG menu support"
HOMEPAGE="https://ipxe.org/ https://github.com/ipxe/ipxe"
SRC_URI="https://github.com/ipxe/ipxe/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ipxe-${COMMIT}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"
RESTRICT="strip"

BDEPEND="
	dev-lang/perl
	cross-x86_64-pc-linux-gnu/binutils
	cross-x86_64-pc-linux-gnu/gcc
"

src_configure() {
	cat > config/local/general.h <<-'EOF_GENERAL' || die
		#undef BANNER_TIMEOUT
		#define BANNER_TIMEOUT 0
		#define CONSOLE_CMD
		#define IMAGE_PNG
	EOF_GENERAL

	cat > config/local/console.h <<-'EOF_CONSOLE' || die
		#define CONSOLE_FRAMEBUFFER
	EOF_CONSOLE

	# EFI builds disable this driver by default and rely on the firmware
	# console.  Use iPXE's native driver so keyboards remain usable after
	# iPXE takes ownership of xHCI controllers on USB-3-only systems.
	cat > config/local/usb.h <<-'EOF_USB' || die
		#define USB_KEYBOARD
	EOF_USB
}

src_compile() {
	export NO_WERROR=1

	# Absolute paths deliberately bypass Portage's /usr/lib/distcc/bin
	# wrappers.  The remote hosts do not provide this cross-toolchain; target
	# objects and native build helpers must therefore be compiled on Hermes.
	emake \
		CROSS=/usr/bin/x86_64-pc-linux-gnu- \
		HOST_CC="/usr/bin/$(tc-getBUILD_CC)" \
		VERSION="${PV}" \
		bin/undionly.kpxe

	# iPXE derives one architecture per make invocation.  Mixing pcbios and
	# x86_64-efi targets in one call incorrectly combines host/target paths.
	emake \
		CROSS=/usr/bin/x86_64-pc-linux-gnu- \
		HOST_CC="/usr/bin/$(tc-getBUILD_CC)" \
		VERSION="${PV}" \
		bin-x86_64-efi/ipxe.efi
}

src_install() {
	local info="${T}/BUILD-INFO"

	{
		printf 'upstream=https://github.com/ipxe/ipxe\n'
		printf 'commit=%s\n' "${COMMIT}"
		printf 'compiler=%s\n' "$(x86_64-pc-linux-gnu-gcc -dumpfullversion)"
		printf 'builder=arm64-cross-x86_64\n'
		printf 'features=CONSOLE_CMD IMAGE_PNG CONSOLE_FRAMEBUFFER USB_KEYBOARD\n'
		sha256sum bin/undionly.kpxe bin-x86_64-efi/ipxe.efi |
			sed -e 's#bin/##' -e 's#bin-x86_64-efi/ipxe.efi#ipxe-x86_64.efi#'
	} > "${info}" || die

	insinto /srv/pxe
	doins "${info}" bin/undionly.kpxe
	newins bin-x86_64-efi/ipxe.efi ipxe-x86_64.efi
}

pkg_postinst() {
	elog "iPXE was compiled from source on Hermes with its local cross-toolchain."
	elog "The firmware is installed directly below /srv/pxe for secure TFTP."
}
