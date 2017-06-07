# Building DataCentred Docker images

This repository contains Puppet configuration code and data required to build various Docker images for use at DataCentred.

## Overview

This process uses the Puppet Labs [image_build](https://forge.puppet.com/puppetlabs/image_build) module (or a fork of it) to generate Docker-compatible images.

Under the hood, images are built using Puppet via `puppet apply`;  Puppet applies once during the build process and configures all functionality required to run a particular application in a container.

This process makes use of a tool called ['Rocker'](https://github.com/grammarly/rocker) which provides additional options during the build process such as the ability to mount volumes that persist across build as well as templating capability.  Rocker is a pre-requisite for building any of these images.

## Setup

In order to build images in this repository, you'll need to install the following:

* Puppet
* puppetlabs-image_build
* Rocker

For now, the puppet-image_build needs to be installed via [this fork](https://github.com/yankcrime/puppetlabs-image_build) as it includes a couple of extras necessary for things like deep merge behaviour and encrypted YAML to work.

### Building and installing the image_build module

Until proposed changes are merged upstream, you'll need to build and install this module [from this fork](https://github.com/yankcrime/puppetlabs-image_build) locally.  Steps to do this are:

1. Clone the repo
2. Build a module package:
```bash
$ cd puppetlabs-image_build
$ puppet module build .
Notice: Building /Users/nick/src/puppetlabs-image_build for release
Module built: /Users/nick/src/puppetlabs-image_build/pkg/puppetlabs-image_build-0.4.0.tar.gz

$ puppet module install pkg/puppetlabs-image_build-0.4.0.tar.gz
Notice: Preparing to install into /Users/nick/.puppetlabs/etc/code/modules ...
Notice: Downloading from https://forgeapi.puppet.com ...
Notice: Installing -- do not interrupt ...
/Users/nick/.puppetlabs/etc/code/modules
└── puppetlabs-image_build (v0.4.0)

$ puppet docker --version
4.9.3
```

## Building an image

All images to be built, along with any of their configurable parameters, are defined in a `Makefile`.  As an example, to build Horizon for testing locally do:

```
make horizon DOMAIN="vagrant.test"
```

