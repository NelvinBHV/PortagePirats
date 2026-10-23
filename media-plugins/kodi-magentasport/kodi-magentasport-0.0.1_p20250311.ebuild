# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT="125a83bce10b4dde500e851529d4a645e935f040"
ADDON_ID="plugin.video.magentasport"

DESCRIPTION="MagentaSport Kodi Addon (MRLB Fork)"
HOMEPAGE="https://github.com/MRLB/kodi-magentasport"
SRC_URI="https://github.com/MRLB/kodi-magentasport/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86 ~arm ~arm64"
IUSE=""

RDEPEND="
	media-tv/kodi
	media-plugins/kodi-inputstream-adaptive
"

S="${WORKDIR}/kodi-magentasport-${MY_COMMIT}"

src_prepare() {
	default

	# === FIX: Python 3.13 DeprecationWarning (Robustere Methode) ===
	# Wir definieren eine Helper-Funktion am Anfang der Datei und leiten
	# alle Aufrufe darauf um. Das vermeidet Probleme mit Klammern/Regex.
	
	local PATCH_FILE="default.py"

	# 1. Wir fügen Importe und die Helper-Funktion ganz oben ein.
	# Die Funktion 'gentoo_fix_utc' übernimmt den Timestamp und nutzt timezone.utc
	sed -i '1i from datetime import timezone, datetime\ndef gentoo_fix_utc(ts):\n    return datetime.fromtimestamp(ts, timezone.utc)' "${PATCH_FILE}" || die "Sed header failed"

	# 2. Wir ersetzen den Aufruf 'datetime.utcfromtimestamp' durch unsere Funktion 'gentoo_fix_utc'.
	# Damit wird aus "datetime.utcfromtimestamp( ... )" -> "gentoo_fix_utc( ... )"
	# Das funktioniert sicher, egal wie die Argumente aussehen.
	sed -i 's/datetime\.utcfromtimestamp/gentoo_fix_utc/g' "${PATCH_FILE}" || die "Sed replace failed"
	
	# === FIX ENDE ===
}

src_install() {
	insinto /usr/share/kodi/addons/${ADDON_ID}
	doins -r .
	fperms -R a+rX /usr/share/kodi/addons/${ADDON_ID}
}
