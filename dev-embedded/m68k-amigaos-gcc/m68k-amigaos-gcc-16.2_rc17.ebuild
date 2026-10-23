# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TOP_COMMIT="b5e1ac638d8ebdc4ffa161bc6da33fd12a4904c7"
AMIGAPORTS="https://github.com/AmigaPorts"

DESCRIPTION="Complete GCC cross-development toolchain for classic m68k AmigaOS"
HOMEPAGE="https://github.com/AmigaPorts/m68k-amigaos-gcc"
SRC_URI="
	${AMIGAPORTS}/m68k-amigaos-gcc/archive/${TOP_COMMIT}.tar.gz -> ${PN}-${PV}-sources.tar.gz
	${AMIGAPORTS}/amiga-netinclude/archive/7d155ca3a3090afe3466f819dd178f2af6f5c176.tar.gz -> ${PN}-${PV}-amiga-netinclude.tar.gz
	${AMIGAPORTS}/binutils-gdb/archive/15f4b0aa860f74022c6aff7ace15bc0a307d5510.tar.gz -> ${PN}-${PV}-binutils.tar.gz
	${AMIGAPORTS}/clib2/archive/78e05e255495382bbf880d0d37d20763d129f01e.tar.gz -> ${PN}-${PV}-clib2.tar.gz
	${AMIGAPORTS}/fd2pragma/archive/bcffac5c89295baf1db033addc984312b4b4a722.tar.gz -> ${PN}-${PV}-fd2pragma.tar.gz
	${AMIGAPORTS}/fd2sfd/archive/a0ae60d140fdfd30f889810faea07cc6968d1fd0.tar.gz -> ${PN}-${PV}-fd2sfd.tar.gz
	${AMIGAPORTS}/gcc/archive/02e276f976146d6fdcb9fa426b831e94c6bf228d.tar.gz -> ${PN}-${PV}-gcc.tar.gz
	${AMIGAPORTS}/ira/archive/bb7c11384a32c409341fdb0d16d715b7959a0290.tar.gz -> ${PN}-${PV}-ira.tar.gz
	${AMIGAPORTS}/ixemul/archive/f0dd997994263c6ac783b563222a9f53a00c013c.tar.gz -> ${PN}-${PV}-ixemul.tar.gz
	${AMIGAPORTS}/lha/archive/979815dc8699a9c5018de067946737c83ec6f697.tar.gz -> ${PN}-${PV}-lha.tar.gz
	${AMIGAPORTS}/libdebug/archive/76c7dbfeaac79516117dc810e3ba9b34d5f54a69.tar.gz -> ${PN}-${PV}-libdebug.tar.gz
	${AMIGAPORTS}/libnix/archive/a1d73457a10ec2aaa307dfb0c9f0bdd410c5feec.tar.gz -> ${PN}-${PV}-libnix.tar.gz
	${AMIGAPORTS}/newlib-cygwin/archive/3940038465f770096a19f9f324739034c2ee39f7.tar.gz -> ${PN}-${PV}-newlib-cygwin.tar.gz
	${AMIGAPORTS}/sfdc/archive/4e7afc044c1ff129574fcf3b839c3351edcfe2fb.tar.gz -> ${PN}-${PV}-sfdc.tar.gz
	${AMIGAPORTS}/vasm/archive/de93f7dd067001532cff663730133601edb274cb.tar.gz -> ${PN}-${PV}-vasm.tar.gz
	${AMIGAPORTS}/vbcc/archive/55a487d500dccccad806cf3916e90bcd95189ec9.tar.gz -> ${PN}-${PV}-vbcc.tar.gz
	${AMIGAPORTS}/vlink/archive/ce46ccfda0e30eda5b12b9a5d0259d8eaefdefe9.tar.gz -> ${PN}-${PV}-vlink.tar.gz
	${AMIGAPORTS}/aros-stuff/archive/5b101b2c3e5004e9245fab28b29c89c6c441ed52.tar.gz -> ${PN}-${PV}-aros-stuff.tar.gz
	https://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.2.1.tar.bz2 -> ${PN}-${PV}-gmp-6.2.1.tar.bz2
	https://gcc.gnu.org/pub/gcc/infrastructure/mpfr-4.1.0.tar.bz2 -> ${PN}-${PV}-mpfr-4.1.0.tar.bz2
	https://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.2.1.tar.gz -> ${PN}-${PV}-mpc-1.2.1.tar.gz
	https://aminet.net/dev/c/vbcc_target_m68k-kick13.lha -> ${PN}-${PV}-vbcc_target_m68k-kick13.lha
	https://aminet.net/dev/c/vbcc_target_m68k-amiga.lha -> ${PN}-${PV}-vbcc_target_m68k-amigaos.lha
	https://github.com/madler/zlib/releases/download/v1.3.2/zlib-1.3.2.tar.gz -> ${PN}-${PV}-zlib-1.3.2.tar.gz
	https://sourceforge.net/projects/libpng/files/libpng16/1.6.58/libpng-1.6.58.tar.xz -> ${PN}-${PV}-libpng-1.6.58.tar.xz
	https://download-mirror.savannah.gnu.org/releases/freetype/freetype-2.12.1.tar.xz -> ${PN}-${PV}-freetype-2.12.1.tar.xz
	https://aminet.net/dev/misc/NDK3.2.lha -> ${PN}-${PV}-NDK3.2.lha
	https://aminet.net/util/libs/ixemul-sdk.lha -> ${PN}-${PV}-ixemul-sdk.lha
"
S="${WORKDIR}/m68k-amigaos-gcc-${TOP_COMMIT}"

LICENSE="GPL-2+ LGPL-2+ MPL-2.0 MIT BSD public-domain"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror strip test"

RDEPEND="
	dev-libs/gmp:0=
	dev-libs/mpc:0=
	dev-libs/mpfr:0=
	sys-libs/ncurses:0=
	sys-libs/readline:0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/lha
	dev-build/autoconf
	dev-build/automake
	dev-build/make
	sys-apps/gawk
	sys-apps/texinfo
	sys-devel/gettext
	sys-devel/bison
	sys-devel/flex
	sys-devel/gcc
	sys-devel/patch
	sys-process/procps
	net-misc/rsync
"

MODULE_SOURCES=(
	"amiga-netinclude|amiga-netinclude|7d155ca3a3090afe3466f819dd178f2af6f5c176"
	"binutils|binutils-gdb|15f4b0aa860f74022c6aff7ace15bc0a307d5510"
	"clib2|clib2|78e05e255495382bbf880d0d37d20763d129f01e"
	"fd2pragma|fd2pragma|bcffac5c89295baf1db033addc984312b4b4a722"
	"fd2sfd|fd2sfd|a0ae60d140fdfd30f889810faea07cc6968d1fd0"
	"gcc|gcc|02e276f976146d6fdcb9fa426b831e94c6bf228d"
	"ira|ira|bb7c11384a32c409341fdb0d16d715b7959a0290"
	"ixemul|ixemul|f0dd997994263c6ac783b563222a9f53a00c013c"
	"lha|lha|979815dc8699a9c5018de067946737c83ec6f697"
	"libdebug|libdebug|76c7dbfeaac79516117dc810e3ba9b34d5f54a69"
	"libnix|libnix|a1d73457a10ec2aaa307dfb0c9f0bdd410c5feec"
	"newlib-cygwin|newlib-cygwin|3940038465f770096a19f9f324739034c2ee39f7"
	"sfdc|sfdc|4e7afc044c1ff129574fcf3b839c3351edcfe2fb"
	"vasm|vasm|de93f7dd067001532cff663730133601edb274cb"
	"vbcc|vbcc|55a487d500dccccad806cf3916e90bcd95189ec9"
	"vlink|vlink|ce46ccfda0e30eda5b12b9a5d0259d8eaefdefe9"
	"aros-stuff|aros-stuff|5b101b2c3e5004e9245fab28b29c89c6c441ed52"
)

src_unpack() {
	unpack "${PN}-${PV}-sources.tar.gz"
	mkdir -p "${S}/projects" "${S}/download" || die

	local entry module repository revision
	for entry in "${MODULE_SOURCES[@]}"; do
		IFS='|' read -r module repository revision <<< "${entry}"
		unpack "${PN}-${PV}-${module}.tar.gz"
		mv "${WORKDIR}/${repository}-${revision}" "${S}/projects/${module}" || die
	done

	cp "${DISTDIR}/${PN}-${PV}-NDK3.2.lha" "${S}/download/NDK3.2.lha" || die
	cp "${DISTDIR}/${PN}-${PV}-ixemul-sdk.lha" "${S}/download/ixemul-sdk.lha" || die
	cp "${DISTDIR}/${PN}-${PV}-gmp-6.2.1.tar.bz2" "${S}/download/gmp-6.2.1.tar.bz2" || die
	cp "${DISTDIR}/${PN}-${PV}-mpfr-4.1.0.tar.bz2" "${S}/download/mpfr-4.1.0.tar.bz2" || die
	cp "${DISTDIR}/${PN}-${PV}-mpc-1.2.1.tar.gz" "${S}/download/mpc-1.2.1.tar.gz" || die
	cp "${DISTDIR}/${PN}-${PV}-vbcc_target_m68k-kick13.lha" "${S}/download/vbcc_target_m68k-kick13.lha" || die
	cp "${DISTDIR}/${PN}-${PV}-vbcc_target_m68k-amigaos.lha" "${S}/download/vbcc_target_m68k-amigaos.lha" || die
	cp "${DISTDIR}/${PN}-${PV}-zlib-1.3.2.tar.gz" "${S}/download/zlib-1.3.2.tar.gz" || die
	cp "${DISTDIR}/${PN}-${PV}-libpng-1.6.58.tar.xz" "${S}/download/libpng-1.6.58.tar.xz" || die
	cp "${DISTDIR}/${PN}-${PV}-freetype-2.12.1.tar.xz" "${S}/download/freetype-2.12.1.tar.xz" || die
}

src_prepare() {
	default
	eapply "${FILESDIR}/m68k-amigaos-gcc-libstdcxx-hunk-alignment.patch"

	# These patches are normally applied by upstream's clone recipes. Since
	# Portage already supplied every source tree, apply them explicitly.
	local entry module repository revision patch_file relative
	for entry in "${MODULE_SOURCES[@]}"; do
		IFS='|' read -r module repository revision <<< "${entry}"
		[[ -d patches/${module} ]] || continue
		while IFS= read -r -d '' patch_file; do
			relative=${patch_file#patches/}
			patch -N "projects/${relative%.diff}" "${patch_file}" || die
		done < <(find "patches/${module}" -type f -name '*.diff' -print0)
	done

	touch -t 0001010000 projects/libdebug/configure.ac || die
}

src_compile() {
	local prefix="${WORKDIR}/amiga-prefix"

	# Upstream builds its own lha by cloning it during make. Use Gentoo's
	# native app-arch/lha instead so the compile phase remains offline.
	# Portage exports ABI=amd64 on this host. GCC's bundled GMP interprets ABI
	# itself and only accepts "standard", so do not leak Gentoo's ABI setting
	# into the upstream build.
	unset ABI
	emake \
		PREFIX="${prefix}" \
		LHA=/usr/bin/lha \
		LHA_FOR_BUILD=/usr/bin/lha \
		THREADS=posix \
		VERBOSE=1 \
		all
}

src_install() {
	local prefix="${WORKDIR}/amiga-prefix"

	dodir /opt
	cp -a "${prefix}" "${ED}/opt/amiga" || die

	# GCC is relocatable when its internal directory layout stays intact. Fix
	# generated text configuration files that still contain the staging path.
	while IFS= read -r -d '' file; do
		sed -i "s|${prefix}|/opt/amiga|g" "${file}" || die
	done < <(grep -IlRZ -- "${prefix}" "${ED}/opt/amiga" || true)

	newenvd - 60m68k-amigaos-gcc <<-EOF
		PATH=/opt/amiga/bin
		ROOTPATH=/opt/amiga/bin
	EOF

	dodoc README.md REPORT.md
}

pkg_postinst() {
	einfo "Run env-update and start a new shell before using m68k-amigaos-gcc."
	einfo "The complete cross toolchain is installed below /opt/amiga."
}
