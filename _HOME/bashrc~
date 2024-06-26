# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc


if which host-spawn &> /dev/null; then
# Container shell only commands

	# Force commands to be executed on the host
	host-override() {
		for i in $@; do
			alias "$i"="host-spawn $i"
		done
	}

	# Force commands to be executed in the container
	host-block() {
		_HOST_BLOCK_LIST+=($@)
	}

	# Adds flatpak applications as commands executed on the host
	flatpak_host_redirect() {
		for i in $(host-spawn flatpak list --app --columns=application | sed 1d | sed 's/\r$//g'); do
			alias "$i"="host-spawn flatpak run $i"
		done

		unset flatpak_host_redirect
	}
	
	# If command isn't found try on the host shell
	command_not_found_handle() {
		for i in ${_HOST_BLOCK_LIST[@]}; do
			[ "$i" = "$1" ] && echo "[📦] Comando non trovato: $1" > /dev/stderr && return 127
		done

		not_found_handle_cmd="$@"
		host-spawn bash -c "exec $not_found_handle_cmd"
		unset not_found_handle_cmd
	}

	# Get current git branch
	_get_git_branch() {
		git_repo=$(git branch --show-current 2> /dev/null)

		test -n "$git_repo" && printf " ($git_repo)"
		unset git_repo
	}

	# Get current dir
	_get_short_cwd() {
		cwd=$(basename "$PWD")

		test "$PWD" == "$HOME" && cwd='~'

		printf "$cwd"

		unset cwd

	}

	PS1='📦[$USER@$(hostname) $(_get_short_cwd)]$(_get_git_branch)$ '

	flatpak_host_redirect

	host-override systemctl journalctl reboot poweroff shutdown flatpak

	host-block vi vim nvim emacs nano

#else
# Host shell only commands
fi

export PATH="/var/lib/flatpak/exports/bin/:$PATH"
test -e /home/linuxbrew/.linuxbrew/bin/brew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
