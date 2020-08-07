# fedora-wsl2
Support custom Fedora-based WSL2 distributions.  The distributions are built based on custom Fedora 32 Docker images from which the filesystem is exported as a tarball.

```bash
# ./build.sh [base|podman]
```

The tarball then can be imported as a WSL distribution from Powershell:

```powershell
> wsl --import Base /path/to/<baseWslDir> wsl-fedora32-base.tar

OR

> wsl --import Podman /path/to/<podmanWslDir> wsl-fedora32-podman.tar 
```

## Base image
This is a small image based on the Fedora 32 Docker base image

## Podman image
This image is based on the Fedora 32 Docker base image with packages added to support Podman and Buildah.

- NOTE: this is a work in progress in trying to get rootless Podman working under WSL2.