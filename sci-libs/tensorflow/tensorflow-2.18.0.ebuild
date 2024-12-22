# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )

PYTHON_COMPAT=( python3_10 python3_11 python3_12 )

inherit python-single-r1 cuda llvm-r1 toolchain-funcs

DESCRIPTION="Open Source Machine Learning Framework by Google"
HOMEPAGE="https://www.tensorflow.org/"
SRC_URI="https://github.com/tensorflow/tensorflow/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="cuda rocm xla test opt"

RDEPEND="
    dev-build/bazelisk
    $(python_gen_cond_dep 'dev-python/absl-py[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/astor[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/astunparse[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/wheel[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/gast[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/flatbuffers[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/google-pasta[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/grpcio[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/h5py[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/jax[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/keras[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/protobuf[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/scipy[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/six[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/tensorboard[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/tensorboard-data-server[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/typing-extensions[${PYTHON_USEDEP}]')
    $(python_gen_cond_dep 'dev-python/wrapt[${PYTHON_USEDEP}]')
    cuda? ( dev-util/nvidia-cuda-toolkit )
    rocm? (
        dev-libs/rocr-runtime
        dev-libs/rocm-device-libs
        sci-libs/rocBLAS
        dev-libs/rocm-comgr
    )
"

DEPEND="${RDEPEND}"

src_prepare() {
    eapply_user
    use cuda && cuda_sanitize
    llvm_gen_dep llvm-config
}

src_configure() {
    # Konfiguration mit Python
    python_setup

    export PYTHON_BIN_PATH="$(python_get_interpreter)"
    export USE_DEFAULT_PYTHON_LIB_PATH=1
    export TF_NEED_CUDA=$(usex cuda 1 0)
    export TF_NEED_ROCM=$(usex rocm 1 0)
    export TF_ENABLE_XLA=$(usex xla 1 0)

    if use rocm; then
        export ROCM_PATH="/opt/rocm"
        export HIP_PLATFORM="rocclr"
        export TF_ROCM_AMDGPU_TARGETS="${AMDGPU_TARGETS// /,}"
        export LLVM_PREFIX="$(get_llvm_prefix)"
    fi

    ./configure.py || die "Configuration failed"
}

src_compile() {
    local build_opts="--config=opt"
    use rocm && build_opts+=" --config=rocm"
    use cuda && build_opts+=" --config=cuda"
    use xla && build_opts+=" --config=xla"
    use opt && build_opts+=" --copt=-march=native --copt=-O2"

    # Manuelles Setzen von Bazel-Optionen
    bazel --batch build ${build_opts} //tensorflow/tools/pip_package:build_pip_package || die "Build failed"
}

src_test() {
    use test || return
    bazel test --test_output=all //tensorflow/... || die "Tests failed"
}

src_install() {
    # Erstelle Pip-Paket und installiere es
    bazel-bin/tensorflow/tools/pip_package/build_pip_package ${D}/usr/lib/python${EPYTHON}/site-packages
}

