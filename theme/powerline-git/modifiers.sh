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

# Background

bgcolor_black='40'
bgcolor_red='41'
bgcolor_green='42'
bgcolor_yellow='43'
bgcolor_blue='44'
bgcolor_purple='45'
bgcolor_cyan='46'
bgcolor_white='107'

bgcolor_darkgray='100'

bgcolor_lightgray='47'
bgcolor_lightred='101'
bgcolor_lightgreen='102'
bgcolor_lightyellow='103'
bgcolor_lightblue='104'
bgcolor_lightpurple='105'
bgcolor_lightcyan='106'

# Foreground

fgcolor_black='30'
fgcolor_red='31'
fgcolor_green='32'
fgcolor_yellow='33'
fgcolor_blue='34'
fgcolor_purple='35'
fgcolor_cyan='36'
fgcolor_white='97'

fgcolor_darkgray='90'

fgcolor_lightgray='37'
fgcolor_lightred='91'
fgcolor_lightgreen='92'
fgcolor_lightyellow='93'
fgcolor_lightblue='94'
fgcolor_lightpurple='95'
fgcolor_lightcyan='96'

reset() {
	[[ $PS -eq 1 ]] && printf "\["
	printf "\e[0m"
	[[ $PS -eq 1 ]] && printf "\]"
}

background_color() {
	if [ -n "$1" ]; then
		color="bgcolor_$(printf $1 | tr 'A-Z' 'a-z')"
		[[ $PS -eq 1 ]] && printf "\["
		printf "\e[%dm" ${!color}
		[[ $PS -eq 1 ]] && printf "\]"
	else
		reset
	fi
}

text_color() {
	if [ -n "$1" ]; then
		color="fgcolor_$(printf $1 | tr 'A-Z' 'a-z')"
		[[ $PS -eq 1 ]] && printf "\["
		printf "\e[%dm" ${!color}
		[[ $PS -eq 1 ]] && printf "\]"
	else
		reset
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
