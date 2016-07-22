#!/bin/bash
# Meant for calling by dpkg post buildpackage hook

pkg=${1}
vver=${2}
sver=${3}
uver=${4}
arch=${DEB_TARGET_ARCH}

pkgs=$(grep -E "^Binary:" ${pkg}_${sver}_${arch}.changes | cut -d " " -f 2-)
pkgarchs=$(grep -E "^Architecture:" ${pkg}_${sver}_${arch}.changes | cut -d " " -f 2-)
for p in ${pkgs}; do
	for pa in ${pkgarchs}; do
		deb=${p}_${sver}_${pa}.deb
		[ -f ${deb} ] && sudo dpkg -i ${deb} || continue
	done
done
