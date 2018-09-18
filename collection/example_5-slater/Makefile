#! /usr/bin/make -f
SHELL:=/bin/bash

c:=fin collection

col:=example_5-slater

items:=$(shell find items/* -type d)
ttl:=$(patsubst %,%/metadata.ttl,${items})
ldp:=$(patsubst %,%/ldp.ttl,${items})

INFO:
	echo items: ${items}
	@echo ${ark}

.PHONY: ark ttl ldp update
ttl:${ttl}
ldp:ldp.ttl ${ldp} add-workExample
ark:${ark}
ldp-update:${ldp-update}

ldp.ttl: agents:= quinn enebeker
ldp.ttl: schema:=http://www.schema.org
ldp.ttl:
	$c delete -f ${col};\
	$c create ${col} index.ttl;\
  $c acl group add ${col} admins rw $(patsubst %,--agent %@ucdavis.edu,${agents});\
  $c relation add-container ${col} items -T part;\
	fin http get -P b /collection/${collection}/${col} > $@

add-workExample: s:=http://schema.org
add-workExample:
	$c relation add-properties ${col} ${s}/workExample items/D394.4.3.6/media/images/Davis1_8_16-018 ${s}/exampleOfWork


${ldp}:items/%/ldp.ttl:items/%/metadata.ttl
	$c resource delete ${col} items/$*;\
	$c resource add ${col} $< items/$*;\
	$c relation add-container -T media ${col} items/$*/media;\
	$c resource add ${col} image_list.ttl items/$*/media/images; \
	fin cd /collection/${col}/items/$*
	fin http patch --data-string "PREFIX s: <http://schema.org/> PREFIX ldp: <http://www.w3.org/ns/ldp#> INSERT {<> ldp:hasMemberRelation s:hasPart ; ldp:isMemberOfRelation s:partOf; ldp:membershipResource <>. } WHERE {} " -P h media/images ; \
  let p=0; first='';\
  for f in items/$*/*.jpg; do \
    b=$$(basename $$f .jpg); \
    let p+=1 ; \
	  if [[ -z $$first ]]; then first=$$b; fi;\
    fin collection resource add --type MediaObject ${col} $$f items/$*/media/images/$$b;\
    ins="INSERT {<> <http://schema.org/position> $$p } WHERE {}";\
    fin http patch --data-string "$$ins" -P h media/images/$$b/fcr:metadata ;\
  done;\
  fin collection relation add-properties ${col} http://schema.org/workExample items/$*/media/images/$$first http://schema.org/exampleOfWork items/$*
	fin http get -P b . > $@

clean:
	@rm -f ldp.ttl ${ldp}
