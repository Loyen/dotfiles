#!/bin/bash

git_is_repo() {
	[[ -e `git rev-parse --git-dir 2> /dev/null` ]] && echo 1 || echo 0
}

git_branch() {
	printf `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

git_status() {
	local gitstatus=`git status --porcelain`

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

	output=''
	[[ $num_staged -gt 0 ]] && output+="staged ${num_staged}\n"
	[[ $num_changed -gt 0 ]] && output+="changed ${num_changed}\n"
	[[ $num_conflicts -gt 0 ]] && output+="conflicts ${num_conflicts}\n"
	[[ $num_untracked -gt 0 ]] && output+="untracked ${num_untracked}\n"
	[[ $num_deleted -gt 0 ]] && output+="deleted ${num_deleted}\n"
	[[ $num_stashed -gt 0 ]] && output+="stashed ${num_stashed}\n"

	printf "$output"
}

