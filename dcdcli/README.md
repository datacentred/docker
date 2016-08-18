# DataCentred OpenStack CLI tools

This Dockerfile generates an image that you can then run and interact with the OpenStack APIs using the official Python tooling.  It makes use of a JS-based terminal so that you can point your browser at `http://localhost:8000` to login to the container.

## Setup

(Optionally[^1]) Build the image with:

`$ docker build -t datacentred/dcdcli .`

Run it with:

`$ docker run --name datacentred/dcdcli --hostname dcdcli -p 8000:8000 dcdcli`

[^1]: If you don't want to build from scratch, the run command will pull automatically the prebuilt image from `hub.docker.com`.

## Usage

Point your browser to `http://localhost:8000` and login using `datacentred` as the username and `TyukFevakok9` as the password.  Protip:  You can copy and paste into your browser window.

You should then be prompted for your various project-related credentials, after which you can then run the usual OpenStack CLI commands.

## TODO

Make image smaller (!).
