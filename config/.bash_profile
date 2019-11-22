# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Append history always
#PROMPT_COMMAND='history -a'

# Save multi-line commands as one command
shopt -s cmdhist

# Append to the history file, don't overwrite it
shopt -s histappend

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=50000
HISTFILESIZE=10000

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Update window size after every command
shopt -s checkwinsize

# Set default editor
export EDITOR='vim'

# Stop update on every call
export HOMEBREW_NO_AUTO_UPDATE=1 

# Add user local bin
export PATH="${HOME}/.local/bin:$PATH" 
# Add composer bin
[[ -d "${HOME}/.composer/vendor/bin" ]] && export PATH="${HOME}/.composer/vendor/bin:$PATH" 

# Add bash completion
[[ -f "$(brew --prefix)/etc/bash_completion" ]] && source "$(brew --prefix)/etc/bash_completion"

# Add bash theme
[[ -f "$HOME/.bash/theme/powerline-git/prompt.sh" ]] && source "$HOME/.bash/theme/light-git/prompt.sh"

# Add bash aliases
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# Add bash user vars
[[ -f "$HOME/.bash_vars" ]] && source "$HOME/.bash_vars"
