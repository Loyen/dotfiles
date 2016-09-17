#!/bin/bash

PL_SEPARATOR=''
PL_SEPARATOR_ALTERNATIVE=''
PL_SEPARATOR_LIGHT=''
PL_SEPARATOR_LIGHT_ALTERNATIVE=''

powerline_separator() {
	if [ -n "$1" ]; then
		printf "$PL_SEPARATOR_ALTERNATIVE"
	else
		printf "$PL_SEPARATOR"
	fi
}

powerline_separator_light() {
	if [ -n "$1" ]; then
		printf "$PL_SEPARATOR_LIGHT_ALTERNATIVE"
	else
		printf "$PL_SEPARATOR_LIGHT"
	fi
}
