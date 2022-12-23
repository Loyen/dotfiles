# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi

    # Add aliases file
    if [ -f "$HOME/.bash_aliases" ] ; then
        . "$HOME/.bash_aliases"
    fi

    # Add variables file
    if [ -f "$HOME/.bash_variables" ] ; then
        . "$HOME/.bash_variables"
    fi

    # Include bash prompt theme
    #export BASH_THEME='powerline-git'
    #export BASH_THEME_PATH="$HOME/Repositories/github/loyen/dotfiles/theme/$BASH_THEME/prompt.sh"
    #if [ -f "$BASH_THEME_PATH" ]; then
    #    . "$BASH_THEME_PATH"
    #fi

    if [ -f "$HOME/.config/go-prompt-theme" ]; then
        . $HOME/.config/go-prompt-theme
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# Add GOLANG bin to path
if [ -d "$HOME/go/bin" ] ; then
    PATH="$PATH:$HOME/go/bin"
fi

# Add composer and symfony bin to path

if [ -d "$HOME/.composer/bin" ] ; then
    PATH="$HOME/.composer/bin:$PATH"
fi

if [ -d "$HOME/.symfony/bin" ] ; then
    PATH="$HOME/.symfony/bin:$PATH"
fi
