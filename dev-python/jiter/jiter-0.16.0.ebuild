# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_13 )

RUST_MIN_VER="1.88.0"

inherit cargo distutils-r1

DESCRIPTION="Fast iterable JSON parser"
HOMEPAGE="https://github.com/pydantic/jiter https://pypi.org/project/jiter/"
SRC_URI="
	https://github.com/pydantic/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/fasys-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz
"
S="${WORKDIR}/${P}/crates/jiter-python"

LICENSE="MIT Apache-2.0 Apache-2.0-with-LLVM-exceptions MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/jiter/jiter.*.so"
