# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{13..15} )

inherit distutils-r1

DESCRIPTION="Tools for development with classic Amiga m68k systems"
HOMEPAGE="https://github.com/AmigaPorts/amitools https://pypi.org/project/amitools/"
SRC_URI="https://files.pythonhosted.org/packages/bc/15/7b93329a86880c73709f746fe5701d0116c6c5ee73bead802c7747e17e7c/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="test"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

python_install() {
	distutils-r1_python_install

	# FS-UAE Launcher bundles an older private amitools copy in the normal
	# site-packages directory. Keep the developer tools isolated so both
	# implementations have unambiguous Portage ownership and cannot mix.
	local site_dir=$(python_get_sitedir)
	local private_dir="/usr/lib/amitools/${EPYTHON}"
	dodir "${private_dir}"
	mv "${ED}${site_dir}/amitools" "${ED}${private_dir}/" || die
	mv "${ED}${site_dir}/${P}.dist-info" "${ED}${private_dir}/" || die

	local launcher
	for launcher in "${ED}/usr/lib/python-exec/${EPYTHON}"/*; do
		sed -i "/^import sys$/a sys.path.insert(0, '${private_dir}')" 			"${launcher}" || die
	done
}
