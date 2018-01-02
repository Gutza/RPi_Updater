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
sudo apt autoremove -y || {
	echoerr "Failed removing unnecessary packages; aborting."
	exit 1
}

echo ""
echo "----------------------------"
echo "Update script exited cleanly"
echo "----------------------------"

