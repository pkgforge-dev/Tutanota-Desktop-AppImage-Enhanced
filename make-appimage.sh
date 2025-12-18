#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(cat ~/version)
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun ./AppDir/bin/* \
             /usr/lib/libsecret*

# Turn AppDir into AppImage
quick-sharun --make-appimage
