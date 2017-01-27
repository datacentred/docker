DOMAIN=sal01.datacentred.co.uk
VCSREF=$(shell git rev-parse --short HEAD)
REGISTRY=registry.datacentred.services:5000

PDB=puppet docker build --rocker --label-schema \
		--module-path modules --cmd '/usr/bin/supervisord,-n' \
		--factfile=env/$(DOMAIN).txt \
		--image-name $@

all:	keystone glance cinder horizon nova neutron telemetry
.PHONY: all keystone glance cinder horizon nova neutron telemetry clean

keystone:
		$(PDB) --expose=5000,35357
		docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

glance:
		$(PDB) --expose=9191,9292
		docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

cinder:
		$(PDB) --expose=8776
		docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

nova:
		$(PDB) --expose=8774,8775 --from ubuntu:14.04
		docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

neutron:
		$(PDB) --expose=9696 --from ubuntu:14.04
		docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

horizon:
		$(PDB) --expose=80
		docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

telemetry:
		$(PDB) --expose=8042,8777
		docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)

clean:
		yes | docker image prune
