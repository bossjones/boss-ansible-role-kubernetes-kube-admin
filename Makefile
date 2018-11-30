.PHONY: list help

PR_SHA                := $(shell git rev-parse HEAD)

define ASCILOGO
boss-ansible-role-kubernetes-kubeadm
=======================================
endef

export ASCILOGO

# http://misc.flogisoft.com/bash/tip_colors_and_formatting

RED=\033[0;31m
GREEN=\033[0;32m
ORNG=\033[38;5;214m
BLUE=\033[38;5;81m
NC=\033[0m

export RED
export GREEN
export NC
export ORNG
export BLUE

# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))


export PATH := ./venv/bin:$(PATH)

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
MAKE := make

list_allowed_args := product ip command role tier

help:
	@printf "\033[1m$$ASCILOGO $$NC\n"
	@printf "\033[21m\n\n"
	@printf "=======================================\n"
	@printf "\n"

list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

download-roles:
	ansible-galaxy install -r requirements.yml --roles-path ./roles/

raw:
	$(call check_defined, product, Please set product)
	$(call check_defined, command, Please set command)
	@ansible localhost -i inventory-$(product)/ ${PROXY_COMMAND} -m raw -a "$(command)" -f 10

# Compile python modules against homebrew openssl. The homebrew version provides a modern alternative to the one that comes packaged with OS X by default.
# OS X's older openssl version will fail against certain python modules, namely "cryptography"
# Taken from this git issue pyca/cryptography#2692
install-virtualenv-osx:
	ARCHFLAGS="-arch x86_64" LDFLAGS="-L/usr/local/opt/openssl/lib" CFLAGS="-I/usr/local/opt/openssl/include" pip install -r requirements.txt

docker-run:
	@virtualization/docker/docker-run.sh

destroy:
	molecule destroy

install-cidr-brew:
	pip install cidr-brewer

install-test-deps-pre:
	pip install docker-py
	pip install molecule --pre

install-test-deps:
	pip install docker-py
	pip install molecule

ci:
	molecule test

test:
	molecule test --destroy=always

bootstrap:
	echo bootstrap

travis:
	tox

# travis-osx:
# 	$(MAKE) venv-osx
# 	$(MAKE) upgrade-setuptools
# 	$(MAKE) venv-osx
# 	$(MAKE) ci

pip-tools-osx:
	ARCHFLAGS="-arch x86_64" LDFLAGS="-L/usr/local/opt/openssl/lib" CFLAGS="-I/usr/local/opt/openssl/include" pip install pip-tools pipdeptree

pip-tools:
	pip install pip-tools pipdeptree

# travis-osx:
# 	$(MAKE) ci

# SOURCE: https://github.com/freedomofpress/ansible-role-jenkins-config/blob/master/requirements.txt
# This file is autogenerated by pip-compile
# To update, run:
#
#    pip-compile --output-file requirements.txt requirements.in
#
.PHONY: pip-compile-upgrade-all
pip-compile-upgrade-all: pip-tools
	pip-compile --output-file requirements.txt requirements.in --upgrade
	pip-compile --output-file requirements-dev.txt requirements-dev.in --upgrade
	pip-compile --output-file requirements-test.txt requirements-test.in --upgrade

.PHONY: pip-compile
pip-compile: pip-tools
	pip-compile --output-file requirements.txt requirements.in
	pip-compile --output-file requirements-dev.txt requirements-dev.in
	pip-compile --output-file requirements-test.txt requirements-test.in

.PHONY: install-deps-all
install-deps-all:
	pip install -r requirements.txt
	pip install -r requirements-dev.txt

# travis-bootstrap:
# 	pip install tox-travis
# tox-install-all-notest:
# 	tox -e py36 --notest

up:
	@bash ./scripts/up.sh

rollback:
	@bash ./scripts/rollback.sh

commit:
	vagrant sandbox commit

reload:
	@vagrant reload

run-ansible:
	@ansible-playbook -i inventory.ini vagrant_playbook.yml -v

run-ansible-docker:
	@ansible-playbook -i inventory.ini vagrant_playbook.yml -v --tags docker-provision --flush-cache

ping:
	@ansible -i inventory.ini all -m ping

# [ANSIBLE0013] Use shell only when shell functionality is required
ansible-lint-role:
	bash -c "find .* -type f -name '*.y*ml' ! -name '*.venv' -print0 | xargs -I FILE -t -0 -n1 ansible-lint -x ANSIBLE0006,ANSIBLE0007,ANSIBLE0010,ANSIBLE0013 FILE"

yamllint-role:
	bash -c "find .* -type f -name '*.y*ml' ! -name '*.venv' -print0 | xargs -I FILE -t -0 -n1 yamllint FILE"
