#!/bin/bash

PS=0

# Powerline separators

PL_SEPARATOR=''
PL_SEPARATOR_ALTERNATIVE=''
PL_SEPARATOR_LIGHT=''
PL_SEPARATOR_LIGHT_ALTERNATIVE=''

##
# Layout
##

# Git

last_color='white'

git_layout() {
	[[ -e `git_is_repo` ]] && exit 1

	local gitstatus=`git_status`

	local output=''

	output+=`text_color "$last_color"`
	last_color='black'
	output+=`background_color "$last_color"`
	output+=`powerline_separator`
	output+=`text_color 'white'`
	output+=" `git_branch` "

	i=0
	if [ -n "${gitstatus}" ]; then
		while IFS='' read -r line || [[ -n "$line" ]]; do
			data=($line)
			type=${data[0]}
			amount=${data[1]}

			output+=`text_color "$last_color"`
			case "$type" in
				changed)
					last_color='green'
					output+=`background_color "$last_color"`
					output+=`powerline_separator`
					output+=`text_color 'black'`
					output+=" Changed $amount "
					;;
				conflicts)
					last_color='red'
					output+=`background_color "$last_color"`
					output+=`powerline_separator`
					output+=`text_color 'black'`
					output+=" Conflicts $amount "
					;;
				staged)
					last_color='yellow'
					output+=`background_color "$last_color"`
					output+=`powerline_separator`
					output+=`text_color 'black'`
					output+=" Staged $amount "
					;;
				untracked)
					last_color='blue'
					output+=`background_color "$last_color"`
					output+=`powerline_separator`
					output+=`text_color 'white'`
					output+=" Untracked $amount "
					;;
				deleted)
					last_color='red'
					output+=`background_color "$last_color"`
					output+=`powerline_separator`
					output+=`text_color 'white'`
					output+=" Deleted $amount "
					;;
				stashed)
					last_color='cyan'
					output+=`background_color "$last_color"`
					output+=`powerline_separator`
					output+=`text_color 'black'`
					output+=" Stashed $amount "
					;;
			esac

			i=$(($i+1))
		done <<< "${gitstatus}"
	fi

	output+=`reset`
	output+=`text_color "$last_color"`
	output+=`powerline_separator`
	output+=`reset`

	printf "$output"
	exit 0
}

# Prompt
prompt_layout() {
	local output=''

	last_color='white'
	output+=`background_color "$last_color"`
	output+=`text_color 'black'`
	output+=" `date '+%H:%M:%S'` "
	output+=`reset`

	if [ $(git_is_repo) -eq 1 ]; then
		output+=`git_layout`
		output+="\n"
	else
		output+=`text_color "$last_color"`
		output+=`powerline_separator`
		output+="\n"
	fi
	output+="$ "
	output+=`reset`

	printf "$output"
}