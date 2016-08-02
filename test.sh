#!/bin/bash



if which apt-get &> /dev/null; then
	echo "apt-get"
elif which pacman &> /dev/null; then
	echo "pacman"
fi
