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

# $1 repo
# $2 stage, empty by default
function build() {
	export DEB_BUILD_PROFILES=${2}
	cd ${1}
	echo "Building ${1}"
	gbp buildpackage --git-no-pristine-tar
	cd ..
}

function build_all() {
	for repo in ${repos}; do
		build ${repo%_*} ${repo#*_}
	done
}

[ -z ${1} ] && build_all || build_repo ${1}
