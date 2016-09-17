#!/bin/bash

# How text modifiers work:
#
# To start a text modifier you start with "\e[" or "\033["
# To end use "m"
# For PSx, you have to enclose the modifier inside of escaped brackets ("\[" and "\]")
# This isolates the modifier from messing with cursor positions, otherwise you may run
# into issues where you can remove characters you shouldn't be able to.
#
# For text styles:
#	1 = Bold
#	3 = Italic
#	4 = Underline
#	5 = Blink
#	7 = "Inverted", default makes background light and foreground dark
#
# Colors are:
#	x0 = black
#	x1 = Red
#	x2 = Green
#	x3 = Yellow
#	x4 = Blue
#	x5 = Purple
#	x6 = Cyan
#	x7 = White
#
# For foreground color, x = 3
# For background color, x = 4
#
# You can combine multiple states by using semicolon
# \e[31;44m = Red text on blue background
#
# Some other modifiers:
#	* 2K = Delete line
#
# For more information, read up on console codes

# Escape console codes?
PS=0

# Color codes
color_black='0'
color_red='1'
color_green='2'
color_yellow='3'
color_blue='4'
color_purple='5'
color_cyan='6'
color_white='7'

export color_recent_bg=''
export color_recent_fg=''


reset() {
	[[ $PS -eq 1 ]] && printf "\["
	printf "\e[0m"
	[[ $PS -eq 1 ]] && printf "\]"
}

background_color() {
	if [ -n "$1" ]; then
		color="color_$(printf $1 | tr 'A-Z' 'a-z')"
		[[ $PS -eq 1 ]] && printf "\["
		printf "\e[4%dm" ${!color}
		[[ $PS -eq 1 ]] && printf "\]"

		export color_recent_bg="${1}"
	else
		reset
		export color_recent_bg=''
	fi
}

text_color() {
	if [ -n "$1" ]; then
		color="color_$(printf $1 | tr 'A-Z' 'a-z')"
		[[ $PS -eq 1 ]] && printf "\["
		printf "\e[3%dm" ${!color}
		[[ $PS -eq 1 ]] && printf "\]"

		export color_recent_fg="${1}"
	else
		reset
		export color_recent_fg=''
	fi
}

text_style() {
	stylename=`printf "$1" | tr 'A-Z' 'a-z')`
	if [ "$stylename" == "bold" ]; then
		style=1
	elif [ "$stylename" == "italic" ]; then
		style=3
	elif [ "$stylename" == "underline" ]; then
		style=4
	elif [ "$stylename" == "blink" ]; then
		style=5
	else
		style=0
	fi

	[[ $PS -eq 1 ]] && printf "\["
	printf "\e[%dm" ${style}
	[[ $PS -eq 1 ]] && printf "\]"
}

current_background() {
	printf "$color_recent_bg"
}