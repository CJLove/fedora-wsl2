# fedora-wsl2
Support custom Fedora-based WSL2 distributions.  The distributions are built based on custom Fedora 32+ Docker images from which the filesystem is exported as a tarball.

```bash
# ./build.sh [--version=<version>][--user=<user>][--distro=<distroType>]
```

The tarball then can be imported as a WSL distribution from Powershell:

```powershell
> wsl --import Base /path/to/<baseWslDir> wsl-fedora32-base.tar

OR

> wsl --import Podman /path/to/<podmanWslDir> wsl-fedora32-podman.tar 
```

## Base image
This is a small image based on the Fedora 32+ Docker base image

## Podman image
This image is based on the Fedora 32+ Docker base image with packages added to support Podman and Buildah.

Thanks to [Jonathan Bowman's](https://dev.to/bowmanjd/using-podman-on-windows-subsystem-for-linux-wsl-58ji) post for identifying steps to get rootless Podman working under WSL2.

## C++ image
This image adds C++ development tools

## Alternative Docker support
The alternative way to achieve container support within a WSL2 distro is as follows:
1. Install [Docker Desktop for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows), and enable the WSL2 backend.
2. Import the Fedora WSL2 distro as shown above.
3. From the Docker Desktop select Settings -> General -> WSL Integration and choose the Fedora WSL2 distro which was imported.  This will create the `/usr/bin/docker` symlink and add the `docker` group in `/etc/group`.
4. Start the Fedora WSL2 distro.
5. As root or via `sudo` add the non-root user to the `docker` group in `/etc/group`.
