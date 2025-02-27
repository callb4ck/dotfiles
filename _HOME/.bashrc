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

export XDG_DATA_HOME="$HOME/.local/share"

COLOR_RESET=$(printf "\033[0m")
GREEN=$(printf "\033[32m")
BRIGHT_WHITE="\033[37;1m"
PRIMARY_COLOR="$GREEN"

if test "$CONTAINER_ID"; then
# Container shell only commands

	# BEGIN functions

	# Force commands to be executed on the host
	host-override() {
		for i in $@; do
			alias "$i"="distrobox-host-exec $i"
		done
	}

	# Force commands to be executed in the container
	host-block() {
		_HOST_BLOCK_LIST+=($@)
	}

	# Force command spawn in container (useful in init containers).
	# Difference with `command` is that it doesn't call command_not_found_handle (hence it doesn't silently get out of the container)
	local-spawn() {
		local_cmd=$(which --skip-alias "$1" 2> /dev/null) || (echo "$_CMD_NOT_FOUND_MSG $1" && unset local_cmd && exit)
		local_args="${@:2}"
		$local_cmd $local_args
		unset local_cmd
		unset local_args
	}

	# Adds flatpak applications as commands executed on the host
	flatpak_host_redirect() {
		for i in $(distrobox-host-exec flatpak list --app --columns=application | sed 1d | sed 's/\r$//g'); do
			alias "$i"="distrobox-host-exec flatpak run $i"
		done

		unset flatpak_host_redirect
	}

	# If command isn't found try on the host shell
	command_not_found_handle() {
		for i in ${_HOST_BLOCK_LIST[@]}; do
			[ "$i" = "$1" ] && echo "$_CMD_NOT_FOUND_MSG $1" > /dev/stderr && return 127
		done

		not_found_handle_cmd="$@"
		distrobox-host-exec bash -c "exec $not_found_handle_cmd"
		unset not_found_handle_cmd
	}

	# Get current git branch
	_get_git_branch() {
		git_repo=$(git branch --show-current 2> /dev/null)

		test -n "$git_repo" && printf " ($BRIGHT_WHITE$git_repo$COLOR_RESET$PRIMARY_COLOR)"
		unset git_repo
	}

	# Get current dir
	_get_short_cwd() {
		cwd=$(basename "$PWD")

		test "$PWD" == "$HOME" && cwd='~'

		printf "$BRIGHT_WHITE$cwd$COLOR_RESET$PRIMARY_COLOR"

		unset cwd

	}

	_get_container() {

		test "$CONTAINER_ID" = "$_DEFAULT_CONTAINER" && return
		printf "{$BRIGHT_WHITE$CONTAINER_ID$COLOR_RESET$PRIMARY_COLOR}"
	}

	# END functions

	# BEGIN vars

	_DEFAULT_CONTAINER='default'
	_CMD_NOT_FOUND_MSG="[📦] Comando non trovato:"

	PS1=$([ "$TERM_PROGRAM" = "vscode" ] \
		&& echo '$ ' \
		|| echo '📦\[$PRIMARY_COLOR\]$(_get_container)[\[$USER\]@$(hostname) $(_get_short_cwd)]$(_get_git_branch)\$\[$COLOR_RESET\] ')

	# END vars

	# BEGIN aliases

	alias hsudo='distrobox-host-exec sudo'
	alias dss='distrobox enter'
	alias dstop='distrobox stop'

	alias ls='ls --color'

	unina-cluster() {
		_login=$(sed '1q;d' .config/clustercreds)
		_pw=$(sed '2q;d' .config/clustercreds)
		uk.org.greenend.chiark.sgtatham.putty -load "unina" -l $_login -pw $_pw
		#sshpass -p "${_pw}" ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-rsa "${_login}@ui-studenti.scope.unina.it"
		unset _pw
		unset _login
	}

	svgto11() { 
		for arg in $@; do
			svgcheck -a $arg -o $arg
		done
	}

	# END aliases


	# BEGIN config-apply

	flatpak_host_redirect

	host-override systemctl journalctl reboot poweroff shutdown flatpak podman

	host-block vi vim nvim emacs nano visudo pip pip3

	test -e .boxrc && source .boxrc

	# END config-apply


	# BEGIN distro-specific
	
	_DISTRO="$(grep '^ID' '/etc/os-release' | tr -d 'ID=')"

	case "$_DISTRO" in
		arch)
			command -v commando &>/dev/null && \
				com() {
					commando -v "$1" && echo
				}
			;;
	esac

	unset _DISTRO

	# END distro-specific

else
# Host shell only commands
	export PATH="/var/userbin/:$PATH"
fi

export PATH="/var/lib/flatpak/exports/bin/:$PATH"
export PATH="/var/home/sec/.cargo/bin:$PATH"
test -e /home/linuxbrew/.linuxbrew/bin/brew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
