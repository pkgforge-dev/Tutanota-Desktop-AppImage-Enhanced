#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Downloading and extracting Tutanota tar file..."
echo "---------------------------------------------------------------"

TAR_LINK=$(curl -s https://api.github.com/repos/tutao/tutanota/releases | 
           grep -oP '"name": "\K[^"]*Desktop[^"]*' | 
           head -n 1 | 
           xargs -I {} curl -s https://api.github.com/repos/tutao/tutanota/releases | 
           grep -oP '"browser_download_url": "\K[^"]*\.tar\.gz' |
           head -n 1)

VERSION=$(echo "$TAR_LINK" | grep -oP 'tutanota-desktop-release-\K[^/]+')

if ! wget --retry-connrefused --tries=30 "$TAR_LINK" -O ./tuta.tar.gz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

tar -xvf ./tuta.tar.gz
rm -f ./tuta.tar.gz

mkdir -p ./AppDir/bin
cp -rv ./linux-unpacked/* ./AppDir/bin/
cp -v ./linux-unpacked/resources/icons/icon/512.png ./AppDir/.DirIcon

cat << 'EOF' > ./AppDir/tutanota-desktop.desktop
[Desktop Entry]
Name=Tuta Mail
Exec=tutanota-desktop
Terminal=false
Type=Application
Icon=tutanota-desktop
StartupWMClass=tutanota-desktop
Comment=The desktop client for Tutanota, the secure e-mail service.
MimeType=x-scheme-handler/mailto;
Categories=Network;
EOF

echo "$VERSION" > ~/version

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm nspr nss

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano
