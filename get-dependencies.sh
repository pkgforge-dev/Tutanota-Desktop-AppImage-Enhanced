#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
make-aur-package tutanota-desktop

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

mkdir -p ./AppDir/bin
cp -rv /opt/tutanota-desktop/*                                        ./AppDir/bin
cp -v  /usr/share/applications/tutanota-desktop.desktop               ./AppDir
cp -v  /usr/share/icons/hicolor/512x512/apps/tutanota-desktop.png     ./AppDir/.DirIcon
