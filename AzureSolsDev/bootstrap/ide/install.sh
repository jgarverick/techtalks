#!/bin/bash
if [ "$1" = "brew" ]; then
    $1 cask $2 $3
else
    sudo $1 $2 $3
fi