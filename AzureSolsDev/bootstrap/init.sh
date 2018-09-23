#!/bin/bash

IDE=vscode    # Values: vs, vscode, sublime
SCRIPTING=sh  # Values: sh, ps
test -z $1 || IDE=$1
test -z $2 || SCRIPTING=$2
echo "IDE selected: $IDE"
echo "Scripting language selected: $SCRIPTING"
./env/init.sh
set_packagemgr
echo "Installing packages..."
./util/packages.sh
echo "Installing IDE: $1"
./ide/install.sh $PKGMGR $PKGINSTALL $1
echo "Installing custom utilities..."
./custom/custom.sh
echo "Done."