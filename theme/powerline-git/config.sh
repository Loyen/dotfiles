#!/bin/bash

PS=1

# Powerline separators

PL_SEPARATOR=''
PL_SEPARATOR_ALTERNATIVE=''
PL_SEPARATOR_LIGHT=''
PL_SEPARATOR_LIGHT_ALTERNATIVE=''

##
# Layout
##

# Git

git_layout() {
	[[ -e `git_is_repo` ]] && exit 1

	local gitstatus=`git_status`

	local output=''

	output+=`text_color "$bgcolor"`
	bgcolor="$1"
	fgcolor="$2"
	output+=`background_color "$bgcolor"`
	output+=`powerline_separator`
	output+=`text_color "$fgcolor"`
	output+="`git_branch` "

	i=0
	if [ -n "${gitstatus}" ]; then
		while IFS='' read -r line || [[ -n "$line" ]]; do
			data=($line)
			type=${data[0]}
			amount=${data[1]}

			output+=`text_color "$fgcolor"`
			output+=`powerline_separator_light`

			case "$type" in
				changed)
					output+=`text_color 'lightgreen'`
					output+=" ✚ $amount "
					;;
				conflicts)
					output+=`text_color 'lightred'`
					output+=" ✖ $amount "
					;;
				staged)
					output+=`text_color 'lightgreen'`
					output+=" ● $amount "
					;;
				untracked)
					output+=`text_color 'lightblue'`
					output+=" ✚ $amount "
					;;
				deleted)
					output+=`text_color 'lightred'`
					output+=" ✖ $amount "
					;;
				stashed)
					output+=`text_color 'lightcyan'`
					output+=" ⚑ $amount "
					;;
			esac

			i=$(($i+1))
		done <<< "${gitstatus}"
	fi

	output+=`reset`

	printf "$output"
}

# Prompt
prompt_layout() {
	local output=''

	# Time
	bgcolor='lightyellow'
	output+=`background_color "$bgcolor"`
	output+=`text_color 'black'`
	output+=" `date '+%H:%M:%S'` "
	output+=`reset`

	# Git
	if [ $(git_is_repo) -eq 1 ]; then
		output+=`text_color "$bgcolor"`

		bgcolor='black'
		fgcolor='white'

		output+=`background_color "$bgcolor"`
		output+=`powerline_separator`

		output+=`git_layout "$bgcolor" "$fgcolor"`
	fi



	# Directory
	output+=`text_color "$bgcolor"`

	bgcolor='cyan'
	fgcolor='black'

	output+=`background_color "$bgcolor"`
	output+=`powerline_separator`

	output+=`text_color "$fgcolor"`

	output+=" `pwd` "

	output+=`reset`

	# End
	output+=`text_color "$bgcolor"`
	output+=`powerline_separator`
	output+=`reset`

	# Prompt line
	output+="\n$ "
	output+=`reset`

	printf "$output"
}
