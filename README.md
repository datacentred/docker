# Building DataCentred Docker images

This repository contains configuration code and data required to build various Docker images for use at DataCentred.

## Overview

Images are built using Puppet via `puppet apply`;  Puppet applies once during the build process and configures all functionality required to run a particular application in a container.

This process makes use of a tool called ['Rocker'](https://github.com/grammarly/rocker) which provides additional options during the build process such as the ability to mount volumes that persist across build as well as templating capability.  Rocker is a pre-requisite for building any of these images.

All images are generated from the same base configuration and Dockerfile template that exists in `common`.

Puppet code resides under `puppet`, and includes Hiera (configuraton) data.

Per-image Puppetfiles under `puppet/r10k`.  This approach facilitates module version independance across image build, but duplication is kept to a minimum thanks to Rocker's shared volumes.

## Building an image

All images to be built, along with any of their configurable parameters, are defined in a `Makefile`.  As an example, to build Horizon for testing locally do:

```
make horizon DOMAIN="vagrant.test"
```

After a couple of minutes you'll end up with an image like `horizon:mitaka-3038390` with configuration tailored for running locally in a Vagrant development environment.

Another slightly more advanced example would be:

```
make nova BASE='ubuntu:14.04' UBUNTU_CODENAME='trusty' DATE="121216" RELEASE="liberty" DOMAIN="vagrant.test"
```

This will build a Nova image based off Ubuntu 14.04 configured for running in a Vagrant test environment.

_NB_: The `RELEASE` option doesn't actually affect anything other than what the image is tagged as.


