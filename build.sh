#!/bin/bash
#
# Script to update android-tools repos to the latest upstream.
#
# Chirayu Desai
# Android Tools Maintainers

# Assumes you have the below repos cloned to a directory with the same name.
# Runs git clean, so you sure you don't have any unsaved work.

# From https://wiki.debian.org/AndroidTools#Updating_the_source_packages
repos='
android-platform-external-libunwind
android-platform-external-libselinux
android-platform-build_stage1
android-platform-frameworks-native
android-platform-libcore
android-platform-system-core_stage1
android-platform-system-extras
android-platform-libnativehelper
android-platform-frameworks-base
android-platform-dalvik
android-platform-build
android-platform-system-core
'

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

# $1 repo
# $2 stage, empty by default
function build() {
	export DEB_BUILD_PROFILES=${2}
	cd ${1}
	echo "Building ${1} ${2}"
	debuild --post-dpkg-buildpackage-hook="${MY_DIR}/install-packages.sh %p %v %s %u" -b -us -uc
	cd ..
}

function build_all() {
	for repo in ${repos}; do
		build ${repo%_*} ${repo#*_}
	done
}

[ -z ${1} ] && build_all || build ${1%_*} ${1#*_}
