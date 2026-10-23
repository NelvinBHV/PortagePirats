#!/bin/bash

check() {
	require_binaries unl0kr || return 1

	if ! command -v unl0kr-agent >/dev/null 2>&1 \
		&& [[ ! -x /usr/libexec/unl0kr-agent ]] \
		&& [[ ! -x /usr/lib/buffybox/unl0kr-agent ]]; then
		return 1
	fi

	return 0
}

depends() {
	echo "systemd systemd-ask-password systemd-udevd systemd-cryptsetup"
	return 0
}

installkernel() {
	instmods evdev uinput hid-generic usbhid
	instmods -s input
	instmods -s hid
	instmods -s drm
}

install() {
	local agent

	agent="$(command -v unl0kr-agent 2>/dev/null || true)"
	[[ -n "${agent}" ]] || [[ ! -x /usr/libexec/unl0kr-agent ]] || agent=/usr/libexec/unl0kr-agent
	[[ -n "${agent}" ]] || [[ ! -x /usr/lib/buffybox/unl0kr-agent ]] || agent=/usr/lib/buffybox/unl0kr-agent

	inst_binary unl0kr
	inst_binary "${agent}" /usr/libexec/unl0kr-agent

	inst_simple "${dracutsysrootdir:-}/etc/unl0kr.conf" /etc/unl0kr.conf
	if [[ -d "${dracutsysrootdir:-}/etc/unl0kr.conf.d" ]]; then
		inst_dir /etc/unl0kr.conf.d
		inst_multiple -H -o "${dracutsysrootdir:-}"/etc/unl0kr.conf.d/*.conf
	fi

	inst_simple "${moddir}/unl0kr-agent.path" "${systemdsystemunitdir}/unl0kr-agent.path"
	inst_simple "${moddir}/unl0kr-agent.service" "${systemdsystemunitdir}/unl0kr-agent.service"
	mkdir -p "${initdir}/${systemdsystemunitdir}/paths.target.wants"
	ln_r "${systemdsystemunitdir}/unl0kr-agent.path" "${systemdsystemunitdir}/paths.target.wants/unl0kr-agent.path"

	# Avoid two concurrent password agents in the initramfs.
	mkdir -p "${initdir}/${systemdsystemunitdir}/systemd-ask-password-console.path.d"
	cat > "${initdir}/${systemdsystemunitdir}/systemd-ask-password-console.path.d/90-unl0kr.conf" <<'EOF_DROPIN'
[Unit]
ConditionPathExists=!/run/unl0kr-disable-console-agent
EOF_DROPIN
	mkdir -p "${initdir}/run"
	: > "${initdir}/run/unl0kr-disable-console-agent"

	inst_multiple -o \
		/usr/lib/udev/hwdb.bin \
		/usr/lib/udev/libinput-device-group \
		/usr/lib/udev/libinput-fuzz-extract \
		/usr/lib/udev/libinput-fuzz-to-zero

	inst_rules \
		60-evdev.rules \
		60-input-id.rules \
		65-libwacom.rules \
		70-mouse.rules \
		70-touchpad.rules \
		80-libinput-device-groups.rules \
		90-libinput-fuzz-override.rules

	if [[ -d /usr/share/libinput ]]; then
		find /usr/share/libinput -type f | while read -r file; do
			inst_simple "${file}"
		done
	fi

	if [[ -d /usr/share/X11/xkb ]]; then
		find /usr/share/X11/xkb -type f | while read -r file; do
			inst_simple "${file}"
		done
	fi
}
