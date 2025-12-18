#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q tutanota-desktop | awk '{print $2; exit}')
VERSION=${VERSION#*:}
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun ./AppDir/bin/*

# Turn AppDir into AppImage
quick-sharun --make-appimage
