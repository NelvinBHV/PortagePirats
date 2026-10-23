# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_13 )

inherit distutils-r1 pypi

DESCRIPTION="Library for automatically generating command line interfaces"
HOMEPAGE="https://github.com/google/python-fire https://pypi.org/project/fire/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="dev-python/termcolor[${PYTHON_USEDEP}]"
