#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	emscripten         \
	nodejs             \
	npm                \
	rustup

# emscripten is only added to PATH by /etc/profile.d in login shells
export PATH="/usr/lib/emscripten:$PATH"

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building Tuta Mail from source..."
echo "---------------------------------------------------------------"
git clone https://github.com/tutao/tutanota ./tutanota && (
	cd ./tutanota

	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep '^tutanota-desktop-release-' | head -1)
	git checkout "$TAG"
	echo "${TAG#tutanota-desktop-release-}" > ~/version

	git submodule init
	git submodule sync --recursive
	git submodule update --init --recursive

	# upstream only enables arm64 for macOS
	git apply ../patches/linux-arm64.patch

	# the app and its wasm modules are built with Rust 1.84.0
	rustup default 1.84.0
	rustup target add wasm32-unknown-unknown

	# npm refuses to fetch git dependencies by default
	npm ci --allow-git=all

	node desktop --custom-desktop-release --unpacked
)

mkdir -p ./AppDir/bin
cp -rv ./tutanota/artifacts/desktop/*-unpacked/* ./AppDir/bin/
cp -v ./AppDir/bin/resources/icons/icon/512.png ./AppDir/.DirIcon
cp -v ./AppDir/bin/resources/icons/icon/512.png ./AppDir/tutanota-desktop.png
