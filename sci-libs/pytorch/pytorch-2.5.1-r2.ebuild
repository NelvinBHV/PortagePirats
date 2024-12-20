# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1
inherit distutils-r1 prefix

DESCRIPTION="PyTorch deep learning framework with ROCm support"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/pytorch/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE="rocm cuda cpu"
KEYWORDS="~amd64"
RESTRICT="test"

REQUIRED_USE=${PYTHON_REQUIRED_USE}
RDEPEND="
	${PYTHON_DEPS}
	rocm? (
		dev-libs/rocm-opencl-runtime
		sci-libs/rocBLAS
		dev-util/hip
		sci-libs/miopen
	)
	cuda? (
		dev-libs/cudnn
		dev-util/nvidia-cuda-toolkit
	)
	cpu? (
		sci-libs/mkl
	)

	sci-libs/openblas
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"

S=${WORKDIR}/pytorch-${PV}

src_prepare() {
	eapply \
		"${FILESDIR}"/${P}-dontbuildagain.patch \
		"${FILESDIR}"/${P}-setup.patch

	# Set build dir for pytorch's setup
	sed -i \
		-e "/BUILD_DIR/s|build|/var/lib/caffe2/|" \
		tools/setup_helpers/env.py \
		|| die
	distutils-r1_src_prepare

	# Get object file from caffe2
	cp /var/lib/caffe2/functorch.so functorch/functorch.so || die

	hprefixify tools/setup_helpers/env.py
}

src_configure() {
	local mycmakeargs=(
		-DUSE_CUDA=$(usex cuda)
		-DUSE_ROCM=$(usex rocm)
		-DUSE_MKLDNN=$(usex cpu)
		-DUSE_OPENMP=ON
		-DBUILD_TEST=OFF
	)

	cmake_src_configure
}

src_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	CMAKE_BUILD_DIR="${BUILD_DIR}" \
	cmake_src_compile
}

src_install() {
	cmake_src_install

	# Install additional Python bindings
	local site_packages=$(python_get_sitedir)
	cp -r ${S}/torch ${D}${site_packages}/
}

python_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	USE_SYSTEM_LIBS=ON \
	distutils-r1_python_compile develop sdist
}

default_src_test() {
	if use rocm; then
		echo "Running ROCm tests..."
		python3 test/test_rocm.py || die "ROCm tests failed"
	fi

	if use cuda; then
		echo "Running CUDA tests..."
		python3 test/test_cuda.py || die "CUDA tests failed"
	fi
}

