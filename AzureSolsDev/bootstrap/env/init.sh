#!/bin/bash

set_packagemgr {
	# Figure out what OS is being used and either update or install
	OSVer=$(uname)
	if [ "$OSVer" = "Darwin" ]; then 
		BREW=true
		brew -v >/dev/null 2>&1 || BREW=false
		if [ "$BREW" = "true" ];then
			echo "Homebrew installed. Updating."
			brew update && brew upgrade
			brew cleanup
		else
			echo 'Homebrew not found! Installing.'
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		fi
		PKGMGR=brew
		PKGINSTALL=install
	fi

	if [ "$OSVer" = "Linux" ]; then
		YUM=true;APTGET=true;RPM=true;APK=true
		PKGINSTALL="install -y"
		which yum >/dev/null 2>&1 || YUM=false
		which apt-get >/dev/null 2>&1 || APTGET=false
		which rpm >/dev/null 2>&1 || RPM=false
		which apk >/dev/null 2>&1 || APK=false
		if [ "$YUM" = "true" ]; then
		PKGMGR="yum"
		elif [ "$APTGET" = "true" ]; then
		PKGMGR="apt-get"
		elif [ "$RPM" = "true" ]; then
		PKGMGR="rpm"
		elif [ "$APK" = "true" ];then
		PKGMGR="apk"
		PKGINSTALL="add -y --no-cache"
		fi

		sudo $PKGMGR update
	fi

	export PKGMGR
	export PKGINSTALL
}