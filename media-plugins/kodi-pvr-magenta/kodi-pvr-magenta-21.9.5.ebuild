# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# Der Commit-Hash für Version 21.9.5
MY_COMMIT="af55a16bad506472688c6d17a37ad3055b15f71e"

DESCRIPTION="Magenta PVR client for Kodi"
HOMEPAGE="https://github.com/nirvana-7777/pvr.magenta"
SRC_URI="https://github.com/nirvana-7777/pvr.magenta/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

COMMON_DEPEND="
	=media-tv/kodi-21*
	dev-libs/rapidjson
	dev-libs/tinyxml2
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	media-plugins/kodi-inputstream-adaptive
"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/pvr.magenta-${MY_COMMIT}"

src_prepare() {
	# Standard Gentoo Prepare
	cmake_src_prepare

	# HACK: Das Build-System sucht stur nach 'libtinyxml2.a' in /lib oder /usr/lib.
	# Wir entfernen diese Suche und ersetzen sie durch den generischen Namen 'tinyxml2'.
	# Damit überlassen wir dem Linker (ld) die Arbeit, die richtige .so Datei in /usr/lib64 zu finden.
	
	# Sucht rekursiv nach Dateien, die 'libtinyxml2.a' enthalten, und ersetzt es durch 'tinyxml2'
	grep -rl "libtinyxml2.a" "${S}" | xargs sed -i 's|libtinyxml2.a|tinyxml2|g'
	
	# Falls das Addon ein eigenes FindTinyXML2.cmake mitbringt, löschen wir es,
	# damit CMake das System-Modul von Gentoo nutzt.
	rm -f "${S}"/FindTinyXML2.cmake "${S}"/cmake/FindTinyXML2.cmake
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DBUILD_SHARED_LIBS=ON
		# Wir definieren hier keine TinyXML2 Variablen mehr, da diese ignoriert wurden.
		# Die Korrektur erfolgt nun oben durch 'sed'.
	)
	cmake_src_configure
}
