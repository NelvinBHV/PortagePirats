# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for ESET EEA Update Daemon"
ACCT_USER_HOME="/opt/eset/eea"
ACCT_USER_SHELL="/sbin/nologin"
ACCT_USER_GROUPS=( eset-eea-daemons )
ACCT_USER_ID="-1"

acct-user_add_deps
