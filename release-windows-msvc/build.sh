#!/bin/sh

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <image-name>"
fi

base_image_name=$1

. $(dirname $0)/../build-include.source

build_target() {
    local image_name=$1
    local target=$2

    local arch=${target}

    local image_name="${image_name}:windows-${arch}-msvc"

    build_windows ${image_name} "--build-arg" "ARCH=${arch}"
}

read_targets ${base_image_name}
