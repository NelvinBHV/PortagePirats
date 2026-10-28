# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="sqlite,ssl,xml(+)"
DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1 optfeature

COMMIT="46163680fda0cbc976790d5678095d02b39d2b3e"

DESCRIPTION="Download image galleries and collections from several image hosting sites"
HOMEPAGE="https://codeberg.org/mikf/gallery-dl/"
SRC_URI="https://codeberg.org/mikf/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.codeberg.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

RDEPEND="
	>=dev-python/requests-2.11.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	# Tests against real servers are unsuitable for reproducible package tests.
	rm ./test/test_{extractor,results}.py || die
	distutils-r1_src_prepare
}

python_compile() {
	emake completion man
	distutils-r1_python_compile
}

pkg_postinst() {
	optfeature "Pixiv Ugoira to WebM conversion" media-video/ffmpeg
	optfeature "video downloads" net-misc/yt-dlp
}
