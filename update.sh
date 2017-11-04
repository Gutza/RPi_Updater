#!/bin/sh

echoerr ()
{
	echo ""
	echo "$@" 1>&2
}

echo ""
echo "Updating the package list"
echo "========================="
apt-get update || {
	echoerr "Failed updating the package list; aborting."
	exit 1
}

echo ""
echo "Applying the updates"
echo "===================="
apt-get dist-upgrade || {
	echoerr "Failed applying the updates; aborting"
	exit 1
}

echo ""
echo "Removing unnecessary packages"
echo "============================="
apt-get autoremove || {
	echoerr "Failed removing unnecessary packages; aborting."
	exit 1
}

echo ""
echo "Updating the firmware"
echo "====================="
rpi-update || {
	echo "Failed updating the firmware! Attempting to install it."
	apt-get install rpi-update || {
		echoerr "Failed installing rpi-update; aborting."
		exit 1
	}
	rpi-update || {
		echoerr "Failed updating the firmware, even after installing rpi-update; aborting."
		exit 1
	}
}

echo ""
echo "----------------------------"
echo "Update script exited cleanly"
echo "----------------------------"

