# PortagePirats

An additional ebuild repository for Gentoo Linux, providing desktop applications,
media tools, Amiga development tools, and selected system utilities.

## Requirements

- A working Gentoo Linux installation with Portage.
- The official Gentoo repository, which this overlay uses as its master.
- Git (`dev-vcs/git`) for repository synchronization.

Run the following setup commands as root. If Git is not installed:

```sh
emerge --ask dev-vcs/git
```

## Add the repository

Create `/etc/portage/repos.conf/PortagePirats.conf` with the following contents:

```ini
[PortagePirats]
location = /var/db/repos/PortagePirats
sync-type = git
sync-uri = https://github.com/NelvinBHV/PortagePirats.git
auto-sync = yes
```

If `/etc/portage/repos.conf` is an existing configuration file rather than a
directory, add this section to that file instead.

Synchronize the repository:

```sh
emaint sync -r PortagePirats
```

The repository is public. No GitHub account, access token, or SSH key is needed.

## Install packages

Search for a package, for example:

```sh
emerge --search gridcraft
```

Preview and install a package by specifying its repository. For example:

```sh
emerge --ask --pretend app-office/gridcraft::PortagePirats
emerge --ask app-office/gridcraft::PortagePirats
```

Architecture support, keywords, USE flags, licenses, and dependencies vary by
package. Review Portage's proposed changes before accepting them. Some packages
may require explicit keyword or license acceptance; configure these for the
individual package rather than enabling them for the entire overlay.

## Keep the repository up to date

Because `auto-sync` is enabled, normal synchronization includes PortagePirats:

```sh
emaint sync --auto
```

To synchronize only this repository:

```sh
emaint sync -r PortagePirats
```

Synchronizing refreshes ebuilds; it does not install or upgrade packages.
Use your normal Gentoo update workflow to apply package updates.

## Scope and support

PortagePirats is an independently maintained overlay, separate from the official
Gentoo repository. Package availability does not guarantee successful builds on
every architecture or system configuration. Review package-specific installation
messages and configuration requirements.

Report problems through [GitHub Issues](https://github.com/NelvinBHV/PortagePirats/issues).
Include the package atom and version, relevant USE flags, `emerge --info`, and the
relevant build log. Remove passwords, tokens, and other private information before
posting logs.

Ebuilds reference the licenses applicable to their upstream software. Consult each
package's `LICENSE` metadata and upstream license terms.
