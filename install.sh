#!/usr/bin/env bash

CONFIG_DIR="$PWD/config"

if ! command -v go &> /dev/null || ! command -v git &> /dev/null; then
    echo "Install script requires golang and git to be installed."
    exit 1
fi

function symLinkConfigFile() {
    configFilepath="$CONFIG_DIR/$1"
    configHomeFilepath="$HOME/$2"

    if [ ! -f "$configHomeFilepath" ]; then
        echo "Symlinking $configHomeFilepath"
        ln -s "$configFilepath" "$configHomeFilepath"
    else
        echo "$configHomeFilepath already exists. Skipping..."
    fi
}

configFileList=(".profile" ".gitconfig" ".vimrc")
for configFilename in "${configFileList[@]}"; do
    symLinkConfigFile $configFilename $configFilename
done

if [ ! -f "$(go env GOPATH)/bin/go-prompt" ]; then
    echo "Installing Loyen/go-prompt"
    go get github.com/Loyen/go-prompt
else
    echo "Loyen/go-prompt is already installed. Skipping..."
fi

echo "Setting up go-prompt-theme"
if [ ! -f "$HOME/.config/go-prompt-theme" ]; then
    if [ ! -d "$HOME/.config" ]; then
        mkdir -p "$HOME/.config"
    fi
    symLinkConfigFile "go-prompt-theme" ".config/go-prompt-theme"
else
    echo "$HOME/.config/go-prompt-theme already exists. Skipping..."
fi
