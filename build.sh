#!/bin/bash

image=$1

case $image in
base)
    # Build image from Dockerfile
    pushd base
    podman build -t fedora32-wsl2-base:latest .
    ret=$?
    [ $? -ne 0 ] && { echo "$image image build failed"; exit 1; }
    popd
    # Create container to grab filesystem snapshot
    podman run --name fedora-ctr fedora32-wsl2-base cat /etc/fedora-release
    # Grab filesystem snapshot as a tarball
    podman export fedora-ctr > wsl-fedora32-base.tar
    # Cleanup the container
    podman rm fedora-ctr
    ;;
podman)
    # Build image from Dockerfile
    pushd podman
    podman build -t fedora32-wsl2-podman:latest .
    ret=$?
    [ $? -ne 0 ] && { echo "$image image build failed"; exit 1; }
    popd
    # Create container to grab filesystem snapshot
    podman run --name fedora-ctr fedora32-wsl2-podman cat /etc/fedora-release
    # Grab filesystem snapshot as a tarball
    podman export fedora-ctr > wsl-fedora32-podman.tar
    # Cleanup the container
    podman rm fedora-ctr
    ;;    
esac