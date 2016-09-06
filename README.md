# Building DataCentred Docker images

This repository contains configuration code and data required to build various Docker images for use at DataCentred.

## Overview

Images are built using Puppet via `puppet apply`;  Puppet applies once during the build process and configures all functionality required to run a particular application in a container.

This process makes use of a tool called ['Rocker'](https://github.com/grammarly/rocker) which provides additional options during the build process such as the ability to mount volumes that persist across build as well as templating capability.  Rocker is a pre-requisite for building any of these images.

All images are generated from the same base configuration and Dockerfile template that exists in `common`.

Puppet code resides under `puppet`, and includes Hiera (configuraton) data.

Per-image Puppetfiles under `puppet/r10k`.  This approach facilitates module version independance across image build, but duplication is kept to a minimum thanks to Rocker's shared volumes.

## Building an image

Building an existing image is a case of running `rocker build` with a few options.  From the repository directory:

```shell
$ rocker build -f common/Rockerfile --vars common/common.yaml \
  --var EXPOSE="80" --var TAG=horizon:mitaka --var ROLE=horizon .
```

_NB Don't miss off the trailing `.` as this is used to determine the relative path to various files!_

This command ensures Puppet inherits the `horizon` role which declares various classes and scopes some parameters in Hiera.  If all's well, you'll ned up with a Docker image tagges as `horizon:mitaka`.

The convention follows for all other images:

```shell
$ rocker build -f common/Rockerfile --vars common/common.yaml \
  --var EXPOSE="8774" --var TAG=nova:mitaka --var ROLE=nova .
```

