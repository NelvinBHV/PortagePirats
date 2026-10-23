# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_13 )

inherit distutils-r1 pypi

DESCRIPTION="FastAPI framework, high performance, easy to learn, ready for production"
HOMEPAGE="https://fastapi.tiangolo.com/ https://github.com/fastapi/fastapi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	>=dev-python/annotated-doc-0.0.2[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/starlette-1.0.1[${PYTHON_USEDEP}]
	<dev-python/starlette-2[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/typing-inspection-0.4.2[${PYTHON_USEDEP}]
"
