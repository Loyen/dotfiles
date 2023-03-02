#!/usr/bin/env bash

CONFIG_DIR="$PWD/config"

if [[ -z "$(command -v go)" && -z "$(command -v git)" ]]; then
    echo "Install script requires golang and git to be installed."
    exit 1
fi

function symLinkconfigFile() {
    configFilename="$1"
    configFilepath="$CONFIG_DIR/$configFilename"
    configHomeFilepath="$HOME/$configFilename"

    if [ ! -f "$configHomeFilepath" ]; then
        echo "Symlinking $configHomeFilepath"
        ln -s "$configFilepath" "$configHomeFilepath"
    else
        echo "$configHomeFilepath already exists. Skipping..."
    fi
}

configFileList=(".profile" ".gitconfig" ".vimrc")
for configFilename in "${configFileList[@]}"; do
    symLinkconfigFile $configFilename
done

if [ -n $(command -v go) ]; then
    if [ ! -f "$(go env GOPATH)/bin/go-prompt" ]; then
        echo "Installing Loyen/go-prompt"
        go install github.com/Loyen/go-prompt@main
    else
        echo "Loyen/go-prompt is already installed. Skipping..."
    fi
else
    echo "Golang is not installed. Skipping install of Loyen/go-prompt"
fi
