#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Downloading and extracting Tutanota tar file..."
echo "---------------------------------------------------------------"

TAR_LINK=$(curl -s https://api.github.com/repos/tutao/tutanota/releases | jq -r '.[] | select(.name | contains("(Desktop)")) | .assets[] | select(.name | endswith(".tar.gz")) | .browser_download_url' | head -n 1)

if ! wget --retry-connrefused --tries=30 "$TAR_LINK" -O /tmp/tuta.tar.gz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

tar -xvf /tmp/data.tar.xz
rm -f /tmp/tuta.tar.gz

mkdir -p ./AppDir/bin
cp -rv /tmp/linux-unpacked/* ./AppDir/bin/
cp -v /tmp/linux-unpacked/resources/icons/icon/512.png ./AppDir/.DirIcon

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

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano
