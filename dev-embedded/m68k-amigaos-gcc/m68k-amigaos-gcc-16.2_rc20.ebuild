# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TOP_COMMIT="eb491b131b36a363e569587400a7f49f3391cac7"
AMIGAPORTS="https://github.com/AmigaPorts"

DESCRIPTION="Complete GCC cross-development toolchain for classic m68k AmigaOS"
HOMEPAGE="https://github.com/AmigaPorts/m68k-amigaos-gcc"
SRC_URI="
	${AMIGAPORTS}/m68k-amigaos-gcc/archive/${TOP_COMMIT}.tar.gz -> ${PN}-${PV}-sources-eb491b131b36a363e569587400a7f49f3391cac7.tar.gz
	${AMIGAPORTS}/amiga-netinclude/archive/a2529359b2e06bf9b0a92765f73a5f172378fe8b.tar.gz -> ${PN}-${PV}-amiga-netinclude-a2529359b2e06bf9b0a92765f73a5f172378fe8b.tar.gz
	${AMIGAPORTS}/binutils-gdb/archive/cfea48603ed5cb9fb923b7090916e5d301e7a947.tar.gz -> ${PN}-${PV}-binutils-cfea48603ed5cb9fb923b7090916e5d301e7a947.tar.gz
	${AMIGAPORTS}/clib2/archive/23413f883508aae8f0ad47cff83ed30288927847.tar.gz -> ${PN}-${PV}-clib2-23413f883508aae8f0ad47cff83ed30288927847.tar.gz
	${AMIGAPORTS}/fd2pragma/archive/bcffac5c89295baf1db033addc984312b4b4a722.tar.gz -> ${PN}-${PV}-fd2pragma-bcffac5c89295baf1db033addc984312b4b4a722.tar.gz
	${AMIGAPORTS}/fd2sfd/archive/a0ae60d140fdfd30f889810faea07cc6968d1fd0.tar.gz -> ${PN}-${PV}-fd2sfd-a0ae60d140fdfd30f889810faea07cc6968d1fd0.tar.gz
	${AMIGAPORTS}/gcc/archive/ea5d817439e82475e48f3437685ab43fc3742ba4.tar.gz -> ${PN}-${PV}-gcc-ea5d817439e82475e48f3437685ab43fc3742ba4.tar.gz
	${AMIGAPORTS}/ira/archive/bb7c11384a32c409341fdb0d16d715b7959a0290.tar.gz -> ${PN}-${PV}-ira-bb7c11384a32c409341fdb0d16d715b7959a0290.tar.gz
	${AMIGAPORTS}/ixemul/archive/8cc9dce25172ebf3382bf3bc8a50fd4a0bb96ae2.tar.gz -> ${PN}-${PV}-ixemul-8cc9dce25172ebf3382bf3bc8a50fd4a0bb96ae2.tar.gz
	${AMIGAPORTS}/lha/archive/979815dc8699a9c5018de067946737c83ec6f697.tar.gz -> ${PN}-${PV}-lha-979815dc8699a9c5018de067946737c83ec6f697.tar.gz
	${AMIGAPORTS}/libdebug/archive/76c7dbfeaac79516117dc810e3ba9b34d5f54a69.tar.gz -> ${PN}-${PV}-libdebug-76c7dbfeaac79516117dc810e3ba9b34d5f54a69.tar.gz
	${AMIGAPORTS}/libnix/archive/b64aee37baf9b34daab53b1b7850d178b7bad92e.tar.gz -> ${PN}-${PV}-libnix-b64aee37baf9b34daab53b1b7850d178b7bad92e.tar.gz
	${AMIGAPORTS}/newlib-cygwin/archive/4d7568eca293c37b8d126c8423a3b2e23064d16a.tar.gz -> ${PN}-${PV}-newlib-cygwin-4d7568eca293c37b8d126c8423a3b2e23064d16a.tar.gz
	${AMIGAPORTS}/sfdc/archive/4c670c89a1e56708371b5e863421b10302a2e2c1.tar.gz -> ${PN}-${PV}-sfdc-4c670c89a1e56708371b5e863421b10302a2e2c1.tar.gz
	${AMIGAPORTS}/vasm/archive/de93f7dd067001532cff663730133601edb274cb.tar.gz -> ${PN}-${PV}-vasm-de93f7dd067001532cff663730133601edb274cb.tar.gz
	${AMIGAPORTS}/vbcc/archive/8a1ea8062b7ab1301d3a2822ef4188b917fa57f5.tar.gz -> ${PN}-${PV}-vbcc-8a1ea8062b7ab1301d3a2822ef4188b917fa57f5.tar.gz
	${AMIGAPORTS}/vlink/archive/ce46ccfda0e30eda5b12b9a5d0259d8eaefdefe9.tar.gz -> ${PN}-${PV}-vlink-ce46ccfda0e30eda5b12b9a5d0259d8eaefdefe9.tar.gz
	${AMIGAPORTS}/aros-stuff/archive/0d35eff497aa1a831c9ca9ff62a976ebda2ca629.tar.gz -> ${PN}-${PV}-aros-stuff-0d35eff497aa1a831c9ca9ff62a976ebda2ca629.tar.gz
	https://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.2.1.tar.bz2 -> ${PN}-${PV}-gmp-6.2.1.tar.bz2
	https://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.2.1.tar.gz -> ${PN}-${PV}-mpc-1.2.1.tar.gz
	https://gcc.gnu.org/pub/gcc/infrastructure/mpfr-4.1.0.tar.bz2 -> ${PN}-${PV}-mpfr-4.1.0.tar.bz2
	https://aminet.net/dev/misc/NDK3.2.lha -> ${PN}-${PV}-NDK3.2.lha
	https://aminet.net/util/libs/ixemul-sdk.lha -> ${PN}-${PV}-ixemul-sdk.lha
	https://aminet.net/util/libs/ixemul-000s.lha -> ${PN}-${PV}-ixemul-000s.lha
	https://aminet.net/dev/c/vbcc_target_m68k-amiga.lha -> ${PN}-${PV}-vbcc_target_m68k-amigaos.lha
	https://aminet.net/dev/c/vbcc_target_m68k-kick13.lha -> ${PN}-${PV}-vbcc_target_m68k-kick13.lha
	https://github.com/madler/zlib/releases/download/v1.3.2/zlib-1.3.2.tar.gz -> ${PN}-${PV}-zlib-1.3.2.tar.gz
	https://sourceforge.net/projects/libpng/files/libpng16/1.6.58/libpng-1.6.58.tar.xz -> ${PN}-${PV}-libpng-1.6.58.tar.xz
	https://downloads.sourceforge.net/project/freetype/freetype2/2.12.1/freetype-2.12.1.tar.xz -> ${PN}-${PV}-freetype-2.12.1.tar.xz
	https://github.com/sidick/volamos/releases/download/v0.13/volamos-v0.13-x86_64-unknown-linux-musl.tar.gz -> ${PN}-${PV}-volamos-v0.13-x86_64-unknown-linux-musl.tar.gz
	https://github.com/sidick/volamos/releases/download/v0.13/volamos-v0.13-aarch64-unknown-linux-musl.tar.gz -> ${PN}-${PV}-volamos-v0.13-aarch64-unknown-linux-musl.tar.gz
	https://github.com/sidick/volamos/releases/download/v0.13/volamos-v0.13-aarch64-apple-darwin.tar.gz -> ${PN}-${PV}-volamos-v0.13-aarch64-apple-darwin.tar.gz
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
	"amiga-netinclude|amiga-netinclude|a2529359b2e06bf9b0a92765f73a5f172378fe8b"
	"binutils|binutils-gdb|cfea48603ed5cb9fb923b7090916e5d301e7a947"
	"clib2|clib2|23413f883508aae8f0ad47cff83ed30288927847"
	"fd2pragma|fd2pragma|bcffac5c89295baf1db033addc984312b4b4a722"
	"fd2sfd|fd2sfd|a0ae60d140fdfd30f889810faea07cc6968d1fd0"
	"gcc|gcc|ea5d817439e82475e48f3437685ab43fc3742ba4"
	"ira|ira|bb7c11384a32c409341fdb0d16d715b7959a0290"
	"ixemul|ixemul|8cc9dce25172ebf3382bf3bc8a50fd4a0bb96ae2"
	"lha|lha|979815dc8699a9c5018de067946737c83ec6f697"
	"libdebug|libdebug|76c7dbfeaac79516117dc810e3ba9b34d5f54a69"
	"libnix|libnix|b64aee37baf9b34daab53b1b7850d178b7bad92e"
	"newlib-cygwin|newlib-cygwin|4d7568eca293c37b8d126c8423a3b2e23064d16a"
	"sfdc|sfdc|4c670c89a1e56708371b5e863421b10302a2e2c1"
	"vasm|vasm|de93f7dd067001532cff663730133601edb274cb"
	"vbcc|vbcc|8a1ea8062b7ab1301d3a2822ef4188b917fa57f5"
	"vlink|vlink|ce46ccfda0e30eda5b12b9a5d0259d8eaefdefe9"
	"aros-stuff|aros-stuff|0d35eff497aa1a831c9ca9ff62a976ebda2ca629"
)

src_unpack() {
	unpack "${PN}-${PV}-sources-${TOP_COMMIT}.tar.gz"
	mkdir -p "${S}/projects" "${S}/download" || die
	# Archives have no Git metadata. Supply upstream's supported manifest input.
	printf '# m68k-amigaos-gcc %s %s\n' "${AMIGAPORTS}/m68k-amigaos-gcc" "${TOP_COMMIT}" > "${S}/portage-source-manifest" || die

	local entry module repository revision
	for entry in "${MODULE_SOURCES[@]}"; do
		IFS='|' read -r module repository revision <<< "${entry}"
		unpack "${PN}-${PV}-${module}-${revision}.tar.gz"
		mv "${WORKDIR}/${repository}-${revision}" "${S}/projects/${module}" || die
		printf '%s %s %s\n' "${module}" "${AMIGAPORTS}/${repository}" "${revision}" >> "${S}/portage-source-manifest" || die
	done

	cp "${DISTDIR}/${PN}-${PV}-gmp-6.2.1.tar.bz2" "${S}/download/gmp-6.2.1.tar.bz2" || die
	printf "%s  %s\n" "eae9326beb4158c386e39a356818031bd28f3124cf915f8c5b1dc4c7a36b4d7c" "${S}/download/gmp-6.2.1.tar.bz2" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-mpc-1.2.1.tar.gz" "${S}/download/mpc-1.2.1.tar.gz" || die
	printf "%s  %s\n" "17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459" "${S}/download/mpc-1.2.1.tar.gz" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-mpfr-4.1.0.tar.bz2" "${S}/download/mpfr-4.1.0.tar.bz2" || die
	printf "%s  %s\n" "feced2d430dd5a97805fa289fed3fc8ff2b094c02d05287fd6133e7f1f0ec926" "${S}/download/mpfr-4.1.0.tar.bz2" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-NDK3.2.lha" "${S}/download/NDK3.2.lha" || die
	printf "%s  %s\n" "96cabd4ad683dced632e147bf86dee0f50dcb1254386216c25c362916a6409bb" "${S}/download/NDK3.2.lha" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-ixemul-sdk.lha" "${S}/download/ixemul-sdk.lha" || die
	printf "%s  %s\n" "00b4054283b99d22f6b353194fa8c75917ec0cc08a3a64395a891da446db07fc" "${S}/download/ixemul-sdk.lha" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-ixemul-000s.lha" "${S}/download/ixemul-000s.lha" || die
	printf "%s  %s\n" "b746226db66da298fe22cd7d8e7dd816d90b21ec0fa3bfc6c2b7f84a99bdf2ce" "${S}/download/ixemul-000s.lha" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-vbcc_target_m68k-amigaos.lha" "${S}/download/vbcc_target_m68k-amigaos.lha" || die
	printf "%s  %s\n" "ec734d7115359cdb5d1c70349284ecbd5712ef47e8bc28d4150117c6f8c73289" "${S}/download/vbcc_target_m68k-amigaos.lha" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-vbcc_target_m68k-kick13.lha" "${S}/download/vbcc_target_m68k-kick13.lha" || die
	printf "%s  %s\n" "8815948604eb50ec8b82d4fd2c9d673f5ec59a6623778edfcb29a7df608ea711" "${S}/download/vbcc_target_m68k-kick13.lha" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-zlib-1.3.2.tar.gz" "${S}/download/zlib-1.3.2.tar.gz" || die
	printf "%s  %s\n" "bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16" "${S}/download/zlib-1.3.2.tar.gz" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-libpng-1.6.58.tar.xz" "${S}/download/libpng-1.6.58.tar.xz" || die
	printf "%s  %s\n" "28eb403f51f0f7405249132cecfe82ea5c0ef97f1b32c5a65828814ae0d34775" "${S}/download/libpng-1.6.58.tar.xz" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-freetype-2.12.1.tar.xz" "${S}/download/freetype-2.12.1.tar.xz" || die
	printf "%s  %s\n" "4766f20157cc4cf0cd292f80bf917f92d1c439b243ac3018debf6b9140c41a7f" "${S}/download/freetype-2.12.1.tar.xz" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-volamos-v0.13-x86_64-unknown-linux-musl.tar.gz" "${S}/download/volamos-v0.13-x86_64-unknown-linux-musl.tar.gz" || die
	printf "%s  %s\n" "701e275f66d871aecb318d1afd00fa5fe0a7736f4e98b4d25cb2070b5e244c44" "${S}/download/volamos-v0.13-x86_64-unknown-linux-musl.tar.gz" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-volamos-v0.13-aarch64-unknown-linux-musl.tar.gz" "${S}/download/volamos-v0.13-aarch64-unknown-linux-musl.tar.gz" || die
	printf "%s  %s\n" "dfdc32d526eca139a09dde75a17d37a5f8e434bd8869d6b069a1874dcf77d336" "${S}/download/volamos-v0.13-aarch64-unknown-linux-musl.tar.gz" | sha256sum -c - || die
	cp "${DISTDIR}/${PN}-${PV}-volamos-v0.13-aarch64-apple-darwin.tar.gz" "${S}/download/volamos-v0.13-aarch64-apple-darwin.tar.gz" || die
	printf "%s  %s\n" "a7b3a721fa32021a815b7128205585138ffccc1921fd48c0bc2c1a68bcabd86f" "${S}/download/volamos-v0.13-aarch64-apple-darwin.tar.gz" | sha256sum -c - || die
}

src_prepare() {
	default

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

	# libpthread is target code. Pass target flags through the environment so
	# its Makefile can still append -noixemul and its source include path.
	sed -i 's/&& $(MAKE) -f Makefile.gcc6 $(L2)/\&\& CFLAGS="$(CFLAGS_FOR_TARGET)" $(MAKE) -f Makefile.gcc6 $(L2)/' Makefile || die

	touch -t 0001010000 projects/libdebug/configure.ac || die
}

src_compile() {
	local prefix="${WORKDIR}/amiga-prefix"

	# LHA is upstream's installation target, not the host unpacker. Keep its
	# default below PREFIX; use Gentoo's lha for extraction and suppress only
	# the prerequisite that would build the bundled host tool.
	# Portage exports ABI=amd64 on this host. GCC's bundled GMP interprets ABI
	# itself and only accepts "standard", so do not leak Gentoo's ABI setting
	# into the upstream build.
	unset ABI
	emake \
		PREFIX="${prefix}" \
		MANIFEST="${S}/portage-source-manifest" \
		LHA_PREREQ= \
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

	dodoc README.md COPYING-THIRD-PARTY.md
}

pkg_postinst() {
	einfo "Run env-update and start a new shell before using m68k-amigaos-gcc."
	einfo "The complete cross toolchain is installed below /opt/amiga."
}
