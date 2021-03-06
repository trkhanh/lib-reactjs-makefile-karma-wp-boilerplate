#!/bin/bash

if [ ! -z "`git status -s`" ]; then
    echo "Working tree is not clean"
    git status -s
    read -p "Proceed? [Y/n] " OK
    if [[ "$OK" -eq "n" || "$OK" -eq "N" || -z "$OK" ]]; then
	echo "Stopping publish"
	exit 1
    fi
fi