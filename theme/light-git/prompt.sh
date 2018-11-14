## Colors

# Reset
Default='\[\033[00m\]'       # Text Reset

# Regular Colors
Black='\[\033[0;30m\]'        # Black
Red='\[\033[0;31m\]'          # Red
Green='\[\033[0;32m\]'        # Green
Yellow='\[\033[0;33m\]'       # Yellow
Blue='\[\033[0;34m\]'         # Blue
Purple='\[\033[0;35m\]'       # Purple
Cyan='\[\033[0;36m\]'         # Cyan
White='\[\033[0;37m\]'        # White

Colors=("$Red" "$Green" "$Yellow" "$Blue" "$Purple" "$Cyan")
Rainbow=${Colors[$RANDOM % ${#Colors[@]} ]}

rainbow_gen() {
	echo ${Colors[$RANDOM % ${#Colors[@]} ]}
}


## Customization

# Git related
GIT_PREFIX=""
GIT_SUFFIX="\n"

GIT_DIFF_PREFIX=" "
GIT_DIFF_SUFFIX=""

GIT_SYM_SEPARATOR=" "

GIT_SYM_BRANCH="${Red}"
GIT_SYM_CLEAN="${Green}✓"
GIT_SYM_CHANGED="${Green}•"
GIT_SYM_CONFLICTS="${Red}✕"
GIT_SYM_STAGED="${Yellow}⌃"
GIT_SYM_UNTRACKED="${Blue}⌅"
GIT_SYM_DELETED="${Red}⌄"
GIT_SYM_STASHED="${Yellow}✭"

# Path related
PATH_PREFIX=" "
PATH_SUFFIX="\n"
PATH_DEFAULT="${Rainbow}"
PATH_USER="${Rainbow}${USER}"
PATH_ROOT="${Red}root"

# Prompt related
PROMPT_USER="${Rainbow}\$ "
PROMPT_ROOT="${Red}# "

## Path functions
__prompt_dir_current() {
	local dir="$(pwd)"
	local path=""
	path+="${PATH_PREFIX}${Default}"
	if [ "${dir}" == '/' ]; then
		path+="${PATH_ROOT}${Default}"
	elif [[ ${dir:0:${#HOME}} == $HOME ]]; then
		path+="${PATH_USER}"
		path+="${dir:${#HOME}}"
		path+="${Default}"
	else
		path+="${dir}"
	fi
	path+="${PATH_SUFFIX}${Default}"

	echo "${path}"
}

## User functions

__prompt_user_type() {
	# If sudo, use '$USER_SU'
	if [ ${UID} -eq 0 ]; then
		echo "${PROMPT_ROOT}${Default}"
	# Else use '$USER_U'
	else
		echo "${PROMPT_USER}${Default}"
	fi
}

## Git functions

__prompt_git_is_repo() {
	if [ -e "$(git rev-parse --git-dir 2> /dev/null)" ]; then
		echo 1
	else
		echo 0
	fi
}

__prompt_git_branch() {
	echo "$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
}

__prompt_git_status() {
	local gitstatus=$(git status --porcelain)

	local num_changed=0
	local num_conflicts=0
	local num_deleted=0
	local num_staged=0
	local num_untracked=0

	if [ -n "${gitstatus}" ]; then
		while IFS='' read -r line || [[ -n "$line" ]]; do
			status=${line:0:2}
			case "$status" in
				\#\#) branch_line="${line/\.\.\./^}" ;;
				?M) ((num_changed++)) ;;
				?D) ((num_deleted++)) ;;
				?U) ((num_conflicts++)) ;;
				\?\?) ((num_untracked++)) ;;
				*) ((num_staged++)) ;;
			esac
		done <<< "${gitstatus}"
	fi

	num_stashed=0
	if [[ "$__GIT_PROMPT_IGNORE_STASH" != "1" ]]; then
		stash_file="$( git rev-parse --git-dir )/logs/refs/stash"
		if [[ -e "${stash_file}" ]]; then
			while IFS='' read -r wcline || [[ -n "$wcline" ]]; do
				((num_stashed++))
			done < ${stash_file}
		fi
	fi

	echo "${num_changed} ${num_conflicts} ${num_staged} ${num_untracked} ${num_deleted} ${num_stashed}"
}

# Generate prompt appearance
__prompt_git_prompt() {
	if [ $(__prompt_git_is_repo) -eq 1 ]; then
		local GIT_PROMPT="${GIT_SYM_BRANCH}$(__prompt_git_branch)${Default}"

		# If any changes
		local GIT_STATUS=($(__prompt_git_status))
		local GIT_CHANGES=""

		if [ -n "${GIT_STATUS}" ]; then
			# Changes
			if [ ${GIT_STATUS[0]} -gt 0 ]; then
				GIT_CHANGES+="${GIT_SYM_CHANGED}${GIT_STATUS[0]}${Default}"
			fi

			# Conflicts
			if [ ${GIT_STATUS[1]} -gt 0 ]; then
				[[ -n "${GIT_CHANGES}" ]] && GIT_CHANGES+="${GIT_SYM_SEPARATOR}${Default}"
				GIT_CHANGES+="${GIT_SYM_CONFLICTS}${GIT_STATUS[1]}${Default}"
			fi

			# Stages
			if [ "${GIT_STATUS[2]}" != "0" ]; then
				[[ -n "${GIT_CHANGES}" ]] && GIT_CHANGES+="${GIT_SYM_SEPARATOR}${Default}"
				GIT_CHANGES+="${GIT_SYM_STAGED}${GIT_STATUS[2]}${Default}"
			fi

			# Untracked
			if [ ${GIT_STATUS[3]} -gt 0 ]; then
				[[ -n "${GIT_CHANGES}" ]] && GIT_CHANGES+="${GIT_SYM_SEPARATOR}${Default}"
				GIT_CHANGES+="${GIT_SYM_UNTRACKED}${GIT_STATUS[3]}${Default}"
			fi

			# Deleted
			if [ ${GIT_STATUS[4]} -gt 0 ]; then
				[[ -n "${GIT_CHANGES}" ]] && GIT_CHANGES+="${GIT_SYM_SEPARATOR}${Default}"
				GIT_CHANGES+="${GIT_SYM_DELETED}${GIT_STATUS[4]}${Default}"
			fi

			# Stashed
			if [ ${GIT_STATUS[5]} -gt 0 ]; then
				[[ -n "${GIT_CHANGES}" ]] && GIT_CHANGES+="${GIT_SYM_SEPARATOR}${Default}"
				GIT_CHANGES+="${GIT_SYM_STASHED}${GIT_STATUS[5]}${Default}"
			fi

			# Add statuses to prompt
			if [ -n "${GIT_CHANGES}" ]; then
				GIT_PROMPT+="${GIT_DIFF_PREFIX}${Default}${GIT_CHANGES}${GIT_DIFF_SUFFIX}${Default}"
			else
				GIT_PROMPT+="${GIT_DIFF_PREFIX}${Default}${GIT_SYM_CLEAN}${Default}${GIT_DIFF_SUFFIX}${Default}"
			fi
		else
			GIT_PROMPT+="${GIT_DIFF_PREFIX}${Default}${GIT_SYM_CLEAN}${Default}${GIT_DIFF_SUFFIX}${Default}"
		fi

		if [ -n "${GIT_PROMPT}" ]; then
			echo "${GIT_PREFIX}${Default}${GIT_PROMPT}${GIT_SUFFIX}${Default}"
		fi
	fi
}

## Create PS1 output

# Generate prompt
__prompt_generate() {
	local PROMPT=""
	# Choose output priority
	PROMPT+="$(date "+%H:%M:%S")"
	PROMPT+="$(__prompt_dir_current)"
	PROMPT+="$(__prompt_git_prompt)"
	PROMPT+="$(__prompt_user_type)"

	PS1="${PROMPT}"
	#PS1=$(echo -e "${PROMPT}" | sed -E 's/(\\([0-9]+|e)\[([0-9]+\;)?[0-9]+m)/\\[\1\\]/g')
}

# Init
__prompt_init() {
	[[ -n "${PROMPT_COMMAND}" ]] && PROMPT_COMMAND+=';'
	PROMPT_COMMAND+='__prompt_generate'
}

# Run init
__prompt_init