#!/bin/bash
set -e

mkdir -p build
cd build

if [ -d vcpkg.linux/.git ]; then
    echo "Using existing vcpkg checkout: $(pwd)/vcpkg.linux"
elif [ -e vcpkg.linux ]; then
    echo "ERROR: $(pwd)/vcpkg.linux already exists but is not a git checkout." >&2
    echo "Please remove or rename it before rerunning this script." >&2
    exit 1
else
    git clone https://github.com/Microsoft/vcpkg.git vcpkg.linux
fi

cd vcpkg.linux
git checkout 2022.05.10
./bootstrap-vcpkg.sh

./vcpkg install \
	boost-exception:x64-linux \
	boost-program-options:x64-linux \
	boost-stacktrace:x64-linux \
	freetype:x64-linux \
	glfw3:x64-linux \
	glm:x64-linux \
	imgui:x64-linux \
	stb:x64-linux \
	tinyobjloader:x64-linux
