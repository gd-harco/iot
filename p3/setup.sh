#!/bin/bash
if [ "$1" = "install" ]; then
	bash ./script/install.sh
elif [ "$1" = "uninstall" ]; then
	bash ./script/uninstall.sh
else
	echo "please specify install or uninstall"
	exit 1
fi
exit 0
