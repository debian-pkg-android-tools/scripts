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
android-platform-frameworks-native
android-platform-libcore
android-platform-system-extras
android-platform-libnativehelper
android-platform-frameworks-base
android-platform-dalvik
android-platform-build
android-platform-system-core
android-platform-external-doclava
android-platform-external-jsilver
android-platform-development
'

# Updates given repo to latest release
# Arguments:
# $1: repo, like android-platform-build
function update_repo() {
	cd ${1}
	echo "Updating ${1}"
	# Not the cleanest
	if ! git config remote.anonscm.url > /dev/null; then
		git remote add anonscm https://anonscm.debian.org/git/android-tools/${1}
	fi
	git fetch anonscm
	git stash # just in case.
	git clean -fdx
	git checkout anonscm/master
	git branch -D master-update upstream pristine-tar
	git branch master-update anonscm/master
	git branch upstream anonscm/upstream
	git branch pristine-tar anonscm/pristine-tar
	git checkout master-update
	gbp import-orig --uscan --debian-branch=master-update --sign-tags --pristine-tar --no-interactive
	gbp dch --debian-branch=master-update
	cd ..
}

#
function update_all() {
	for repo in ${repos}; do
		update_repo ${repo}
	done
}

[ -z ${1} ] && update_all || update_repo ${1}
