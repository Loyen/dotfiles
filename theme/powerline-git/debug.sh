#!/bin/bash

CMDROOT=`dirname $0`

# Include files

[[ -f "${CMDROOT}/modifiers.sh" ]] && . "${CMDROOT}/modifiers.sh"
[[ -f "${CMDROOT}/git.sh" ]] && . "${CMDROOT}/git.sh"
[[ -f "${CMDROOT}/powerline.sh" ]] && . "${CMDROOT}/powerline.sh"
[[ -f "${CMDROOT}/config.sh" ]] && . "${CMDROOT}/config.sh"

prompt_generate() {
	prompt_layout
}

prompt_init() {
	prompt_generate
}

#prompt_init
prompt_layout
