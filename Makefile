DOMAIN=sal01.datacentred.co.uk
BASE='ubuntu:16.04'
DIST_CODENAME='xenial'
VCSREF=$(shell git rev-parse --short HEAD)
DATE=$(shell date --rfc-3339=date)
REGISTRY=registry.datacentred.services:5000

all:	keystone glance cinder horizon nova
.PHONY: all keystone glance cinder horizon nova clean

keystone:
		NAME=$@ DATE=$(DATE) VCSREF=$(VCSREF) \
		rocker build --no-cache -f common/Rockerfile --vars common/common.yaml --var EXPOSE="5000 35357" \
		--var DOCKER_BUILD_DOMAIN=$(DOMAIN) --var TAG=$@:$(VCSREF) --var ROLE=$@ .
		docker tag $@:$(VCSREF) $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

glance:
		NAME=$@ DATE=$(DATE) VCSREF=$(VCSREF) \
		rocker build --no-cache -f common/Rockerfile --vars common/common.yaml --var EXPOSE="9191 9292" \
		--var DOCKER_BUILD_DOMAIN=$(DOMAIN) --var TAG=$@:$(VCSREF) --var ROLE=$@ .
		docker tag $@:$(VCSREF) $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

cinder:
		NAME=$@ DATE=$(DATE) VCSREF=$(VCSREF) \
		rocker build --no-cache -f common/Rockerfile --vars common/common.yaml --var EXPOSE="8776" \
		--var DOCKER_BUILD_DOMAIN=$(DOMAIN) --var TAG=$@:$(VCSREF) --var ROLE=$@ .
		docker tag $@:$(VCSREF) $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

nova:
		NAME=$@ DATE=$(DATE) VCSREF=$(VCSREF) \
		rocker build --no-cache -f common/Rockerfile --vars common/common.yaml --var EXPOSE="8774 8775" \
		--var BASE=$(BASE) --var DIST_CODENAME=$(DIST_CODENAME) \
		--var DOCKER_BUILD_DOMAIN=$(DOMAIN) --var TAG=$@:$(VCSREF) --var ROLE=$@ .
		docker tag $@:$(VCSREF) $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

neutron:
		NAME=$@ DATE=$(DATE) VCSREF=$(VCSREF) \
		rocker build --no-cache -f common/Rockerfile --vars common/common.yaml --var EXPOSE="9696" \
		--var BASE=$(BASE) --var DIST_CODENAME=$(DIST_CODENAME) \
		--var DOCKER_BUILD_DOMAIN=$(DOMAIN) --var TAG=$@:$(VCSREF) --var ROLE=$@ .
		docker tag $@:$(VCSREF) $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

horizon:
		NAME=$@ DATE=$(DATE) VCSREF=$(VCSREF) \
		rocker build --no-cache -f common/Rockerfile --vars common/common.yaml --var EXPOSE="80" \
		--var DOCKER_BUILD_DOMAIN=$(DOMAIN) --var TAG=$@:$(VCSREF) --var ROLE=$@ .
		docker tag $@:$(VCSREF) $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

clean:
		yes | docker image prune
