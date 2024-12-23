EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 python3_12 )

inherit distutils-r1

DESCRIPTION="TensorBoard is a suite of web applications for inspecting and understanding your TensorFlow runs and graphs."
HOMEPAGE="https://github.com/tensorflow/tensorboard"
SRC_URI="https://github.com/tensorflow/tensorboard/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
    $(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/absl-py[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/markdown[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/protobuf[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/six[${PYTHON_USEDEP}]')
    "

DEPEND="${RDEPEND}
    $(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/wheel[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/setuptools-scm[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/build[${PYTHON_USEDEP}]')
"

DISTUTILS_USE_PEP517=setuptools

distutils_enable_tests pytest

src_prepare() {
    distutils-r1_src_prepare
    eapply_user
}

src_test() {
    pytest || die "Tests failed"
}

