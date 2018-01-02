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
sudo apt-get remove `deborphan` --purge -y || {
	echoerr "Failed removing orphaned packages; aborting."
	exit 1
}

command -v curl > /dev/null &&
command -v lsb_release > /dev/null &&
{
	echo ""
	echo "Checking if you're running the latest distribution"
	echo "=================================================="
	LATEST_ZIP=$(curl --silent --location --head --output /dev/null --write-out '%{url_effective}' -- https://downloads.raspberrypi.org/raspbian_latest) && {
		CURRENT_DISTRO=$(lsb_release -cs) && {
			echo $LATEST_ZIP | grep -q $CURRENT_DISTRO && {
				echo "You're running $CURRENT_DISTRO, which is the latest release."
			} || {
				echo "You're running an old distribution. You're running $CURRENT_DISTRO, but the latest image is $LATEST_ZIP"
				echo "You can edit /etc/apt/sources.list and run the updater again -- but that's dangerous, make sure you back up your SD card first!"
			}
		} || {
			echo "Failed executing lsb_release; skipping distro image check."
		}
	} || {
		echo "Failed retrieving the latest distro image; skipping distro image check."
	}
} || {
	echo "curl and/or lsb_release aren't installed; skipping distro image check. If you want to enable it, run"
	echo "sudo apt-get install curl lsb_release"
	echo "and then run the updater again."
}

echo ""
echo "----------------------------"
echo "Update script exited cleanly"
echo "----------------------------"

