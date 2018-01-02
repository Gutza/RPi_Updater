#!/bin/sh

echoerr ()
{
	echo ""
	echo "$@" 1>&2
}

echo ""
echo "Updating the package list"
echo "========================="
sudo apt-get update -y || {
	echoerr "Failed updating the package list; aborting."
	exit 1
}

echo ""
echo "Applying the updates"
echo "===================="
sudo apt-get dist-upgrade -y || {
	echoerr "Failed applying the updates; aborting"
	exit 1
}

echo ""
echo "Removing unnecessary packages"
echo "============================="
sudo apt-get autoremove --purge -y || {
	echoerr "Failed removing unnecessary packages; aborting."
	exit 1
}

command -v deborphan > /dev/null || {
	echo ""
	echo "Installing deborphan"
	echo "===================="
	sudo apt-get install deborphan -y || {
		echoerr "Failed installing debophpan; aborting."
		exit 1
	}
}

echo ""
echo "Removing orphaned packages"
echo "=========================="
sudo apt-get remove `deborphan` --purge || {
	echoerr "Failed removing orphaned packages; aborting."
	exit 1
}

echo ""
echo "----------------------------"
echo "Update script exited cleanly"
echo "----------------------------"

