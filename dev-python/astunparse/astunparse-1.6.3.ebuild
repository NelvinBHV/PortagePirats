# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 python3_12 )

inherit distutils-r1

DESCRIPTION="A Python library for un-parsing Python AST back into source code"
HOMEPAGE="https://github.com/simonpercivall/astunparse"
SRC_URI="https://github.com/simonpercivall/astunparse/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

DEPEND="
    test? ( $(python_gen_cond_dep 'dev-python/pytest[${PYTHON_USEDEP}]') )
"

RDEPEND="
    $(python_gen_cond_dep 'dev-python/six[${PYTHON_USEDEP}]')
"

DISTUTILS_USE_PEP517=setuptools

src_prepare() {
    distutils-r1_src_prepare
    if use test; then
       eapply_user
    fi
}

src_test() {
    if use test; then
        pytest || die "Tests failed"
    fi
}

