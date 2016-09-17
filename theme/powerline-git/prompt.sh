#!/bin/bash



prompt_generate() {
	CMDROOT=`cd "$(dirname ${BASH_SOURCE[0]})" && pwd`
	[[ -f "${CMDROOT}/modifiers.sh" ]] && . "${CMDROOT}/modifiers.sh"
	[[ -f "${CMDROOT}/git.sh" ]] && . "${CMDROOT}/git.sh"
	[[ -f "${CMDROOT}/powerline.sh" ]] && . "${CMDROOT}/powerline.sh"
	[[ -f "${CMDROOT}/config.sh" ]] && . "${CMDROOT}/config.sh"

	PS1=`prompt_layout`
}

prompt_init() {
	[[ -n "${PROMPT_COMMAND}" ]] && PROMPT_COMMAND+=';'
	PROMPT_COMMAND='prompt_generate'
}

prompt_init