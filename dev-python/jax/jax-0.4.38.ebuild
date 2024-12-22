# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Numerical computing library for Python with GPU/TPU acceleration"
HOMEPAGE="https://github.com/google/jax"
SRC_URI="https://github.com/google/jax/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
    dev-python/numpy[${PYTHON_USEDEP}]
    dev-python/absl-py[${PYTHON_USEDEP}]
    dev-python/scipy[${PYTHON_USEDEP}]
    dev-python/opt-einsum[${PYTHON_USEDEP}]
    dev-python/ml-dtypes[${PYTHON_USEDEP}]
"

DEPEND="
    ${RDEPEND}
    test? (
        dev-python/pytest[${PYTHON_USEDEP}]
    )
"

DISTUTILS_USE_PEP517=setuptools

S="${WORKDIR}/jax-jax-v${PV}"

src_prepare() {
    distutils-r1_src_prepare
}

src_test() {
    pytest -v || die "Tests failed"
}

