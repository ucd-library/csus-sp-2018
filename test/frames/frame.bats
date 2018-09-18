#!/usr/bin/env bats

setup() {
	load ../env
	load ../jwt/fin_jwt
	load ../core/fin_core
	load ../helpers
	# Argh, some LDP need full path
	R=`jq -r .basePath < ~/.fccli`

}

@test "Create service/frame" {
	as admin
	fin_mkdir /service
	fin_mkdir /service/frame
}

@test "Add our ES frame" {
  fin http put -@ $BATS_TEST_DIRNAME/es_binary.json \
			-H "Content-Type:text/json" service/frame/es_binary
	ttl=$(sed -e "s|<>|<$R/service/frame/es_binary>|g" < $BATS_TEST_DIRNAME/es_binary.json.ttl |\
					tr -d '\n')
	run fin http put -t "$ttl" -H "prefer:return=minimal" service/frame/es_binary/fcr:metadata
	[ "$status" -eq 0 ]
}

@test "Verify we can retreive that frame" {
	as Agent
	fin http get -P b service/frame/es_binary > $BATS_TMPDIR/es_binary.json
	diff -q $BATS_TEST_DIRNAME/es_binary.json $BATS_TMPDIR/es_binary.json
	[ "$status" -eq 0 ]
}

@test "Use that frame on our data" {
	run jsonld frame --omit-default=true --frame=$BATS_TEST_DIRNAME/es_binary.json \
			$BATS_TEST_DIRNAME/B-10004.json > $BATS_TEST_DIRNAME/B-10004_es.json
	[ "$status" -eq 0 ]
}
