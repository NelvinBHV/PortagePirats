# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Deep learning library for Python built on TensorFlow"
HOMEPAGE="https://github.com/keras-team/keras"
SRC_URI="https://github.com/keras-team/keras/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
    dev-python/numpy[${PYTHON_USEDEP}]
    dev-python/h5py[${PYTHON_USEDEP}]
    dev-python/pyyaml[${PYTHON_USEDEP}]
    dev-python/scipy[${PYTHON_USEDEP}]
"

DEPEND="
    ${RDEPEND}
"

DISTUTILS_USE_PEP517=setuptools

src_prepare() {
    distutils-r1_src_prepare
}

src_test() {
    pytest -v || die "Tests failed"
}

