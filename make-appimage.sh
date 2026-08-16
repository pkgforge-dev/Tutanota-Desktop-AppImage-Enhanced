#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook:fix-namespaces.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun ./AppDir/bin/* \
             /usr/lib/libsecret*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the final app
quick-sharun --test ./dist/*.AppImage
