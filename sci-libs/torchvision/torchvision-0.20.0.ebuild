# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12,13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 cmake flag-o-matic

DESCRIPTION="Vision library with C++/CUDA/ROCm extensions for image and video processing."
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/vision-${PV}"
IUSE="cuda rocm"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
    dev-python/numpy
    $(python_gen_cond_dep 'sci-libs/pytorch[${PYTHON_SINGLE_USEDEP}]')
    cuda? ( dev-util/nvidia-cuda-toolkit )
    rocm? ( sci-libs/caffe2[rocm] )
    media-libs/libpng
    media-libs/libjpeg-turbo
"
DEPEND="${RDEPEND}"

PATCHES=( )

src_compile() {
    export MAX_JOBS="$(makeopts_jobs)"
    export MAKEOPTS="-j1"
    if use rocm; then
         addpredict /dev/kfd
    fi
    distutils-r1_src_compile
}


src_install() {
    distutils-r1_src_install
}

python_test() {
    use rocm && check_amdgpu
    rm -rf torchvision || die
    epytest
}
