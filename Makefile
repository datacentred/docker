SHELL:=/usr/bin/env bash

PUSH=false
DOMAIN=sal01.datacentred.co.uk
VCSREF=$(shell git rev-parse --short HEAD)
REGISTRY=registry.datacentred.services:5000

PDB=puppet docker build --rocker --label-schema \
		--module-path modules --cmd '/usr/bin/supervisord,-n' \
		--factfile=env/$(DOMAIN).txt \
		--image-name $@

all:		all keystone glance cinder horizon nova neutron telemetry heat clean
.PHONY:	all keystone glance cinder horizon nova neutron telemetry heat clean

keystone:
	$(PDB) --expose=5000,35357
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

glance:
	$(PDB) --expose=9191,9292
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

cinder:
	$(PDB) --expose=8776
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

nova:
	$(PDB) --expose=8774,8775 --from ubuntu:14.04
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

neutron:
	$(PDB) --expose=9696
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

horizon:
	$(PDB) --expose=80
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

ceilometer:
	$(PDB) --expose=8777
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

aodh:
	$(PDB) --expose=8042
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

heat:
	$(PDB) --expose=8000,8003,8004
	docker tag $@ $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF)
	@if [ $(PUSH) == true ]; then docker push $(REGISTRY)/$(DOMAIN)/$@:$(VCSREF) ; fi

clean:
	yes | docker image prune
