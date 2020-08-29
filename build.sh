#!/bin/bash

function buildDistro()
{
    local dir=$1
    local user=$2
    local version=$3
    local distro=$4

    echo "Building Fedora$version-$distro image with user $user"

    # Build image from Dockerfile
    pushd $dir
    cp Dockerfile.template Dockerfile
    sed -i "s/USER/$user/g" Dockerfile
    sed -i "s/VER/$version/g" Dockerfile
    podman build -t fedora$version-wsl2-$distro:latest .
    ret=$?
    rm -f Dockerfile
    [ $ret -ne 0 ] && { echo "$image image build failed"; exit 1; }
    popd
    # Create container to grab filesystem snapshot
    podman run --name fedora-ctr fedora$version-wsl2-$distro cat /etc/fedora-release
    [ $? -ne 0 ] && { echo "Error creating container using $image image"; exit 1; }
    # Grab filesystem snapshot as a tarball
    podman export fedora-ctr > wsl-fedora$version-$distro.tar
    [ $? -ne 0 ] && { echo "Error exporting filesystem tarball from $image container"; exit 1; }
    # Cleanup the container
    podman rm fedora-ctr

}

function showUsage()
{
    cat << EOT
Usage:
    $(basename $0) [--version <version>][--user <user>] [--distro <distroType>]

--version=<version>     - Fedora version (32+)
--user=<user>           - specify the non-root username which will be created with sudo access
--distro=<distroType>   - specify the type of distro to build:
                            - base   - minimal Fedora distro
                            - podman - Fedora distro with Podman, Buildah (NOTE: work in progress)
EOT
return 1
}

# Parameter defaults
distro=base
user=user
version=32

# Handle command-line arguments
while test $# -gt 0; do
    param="$1"
    if test "${1::1}" = "-"; then
        if test ${#1} -gt 2 -a "${1::2}" = "--" ; then
            param="${1:2}"
        else
            param="${1:1}"
        fi
    else
        break
    fi

    shift

    case $param in
        version=*)
            version=$(echo $param|cut -f2 -d'=')
            ;;
        user=*)
            user=$(echo $param|cut -f2 -d'=')
            ;;
        distro=*)
            distro=$(echo $param|cut -f2 -d'=')
            ;;
        help|h|?|-?)
            showUsage
            exit 0
            ;;
        *)
            echo "Error: Unknown parameter: $param"
            showUsage
            exit 2
            ;;
    esac

done

case $distro in
base)
    buildDistro base "$user" "$version" base
    ;;
podman)
    buildDistro podman "$user" "$version" podman
    ;;
*)
    echo "Unsupported distro type $image"
    exit 1
    ;;  
esac