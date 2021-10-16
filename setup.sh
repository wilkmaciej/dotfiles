#!/bin/bash

if [[ "$(uname)" =~ Darwin ]]; then
	./macos/setup.sh
else
	./linux/setup.sh
fi
