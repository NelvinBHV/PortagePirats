# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12,13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Ultralytics vision library for YOLO and advanced image/video processing."
HOMEPAGE="https://github.com/ultralytics/ultralytics"
SRC_URI="https://github.com/ultralytics/ultralytics/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="cuda rocm onnx"

RDEPEND="
	sci-libs/pytorch
	sci-libs/torchvision
	dev-python/scipy
	dev-python/shapely
	dev-python/pytz
	dev-python/py-cpuinfo
	dev-python/mpmath
	dev-python/urllib3
	dev-python/tzdata
	dev-python/typing-extensions
	dev-python/tqdm
	dev-python/sympy
	dev-python/six
	dev-python/setuptools
	dev-python/pyyaml
	dev-python/pyparsing
	dev-python/psutil
	dev-python/pillow
	dev-python/packaging
	dev-python/numpy
	dev-python/networkx
	dev-python/markupsafe
	dev-python/kiwisolver
	dev-python/idna
	dev-python/fsspec
	dev-python/fonttools
	dev-python/filelock
	dev-python/cycler
	dev-python/charset-normalizer
	dev-python/certifi
	dev-python/requests
	dev-python/python-dateutil
	media-libs/opencv
	dev-python/jinja2
	dev-python/contourpy
	dev-python/matplotlib
	dev-python/seaborn
	dev-python/pandas
	cuda? ( dev-libs/cudnn )
	rocm? ( sci-libs/caffe2[rocm] )
	onnx? ( sci-libs/onnx )
"
DEPEND="${RDEPEND}"

src_unpack() {
	default
	rm -rf "${S}/tests" || die "Failed to remove tests directory"
}
