#! /usr/bin/make
SHELL:=/bin/bash

PORT:=3000
project:=dams$(shell date +%j)
yml:=${project}.yml
env:=${project}.env
dc:=docker-compose -f ${yml} -p ${project}

me:=quinn@ucdavis.edu
admins:=$(patsubst %,%@ucdavis.edu,quinn jrmerz enebeker)


# These parameters are saved to the host
host=dams-sandbox.library.ucdavis.edu
FIN_URL:=http://${host}
FIN_ALLOW_ORIGINS:=${host}
FIN_ENV:=prod
JWT_ISSUER:=library.ucdavis.edu

include ${env}

.PHONY: token up down clean initialize add-admins add-server-info

alias:
	@echo 'alias ${project}="${dc}"'

up: ${env} ${yml}
	${dc} up -d

down:
	${dc} down

kill:
	${dc} down -v
	rm -f ${env} ${yml}

initialize: add-admins add-server-info

add-admins:
	for user in ${admins}; do \
	  ${dc} exec server node app/cli admin add-admin -u $$user; \
	done

add-server-info: token
	fin http put -H prefer:return=minimal -H "Content-Type:text/turtle" -@ server.ttl -P h /

# Mint a token
token:
	fin config set host ${FIN_URL}
	fin config set basePath "/fcrepo/rest"
	fin cd /
	source ${env}; fin jwt encode --admin --save=true $${JWT_SECRET} $${JWT_ISSUER} ${me}

test:
	fin http get -P b /

${yml}: docker-compose.m4
	m4 -DPORT=${PORT} -DENV=${env} $< > $@

${env}:
	@echo -e "FIN_URL=${FIN_URL}\nFIN_ALLOW_ORIGINS=${FIN_ALLOW_ORIGINS}\nFIN_ENV=${FIN_ENV}\nJWT_ISSUER=${JWT_ISSUER}\nJWT_SECRET=$(shell uuidgen -r)\n" > $@

