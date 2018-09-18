#!/usr/bin/env bats

setup() {
	load ../env
	load fin_jwt
	# Our functions expect $R to point to the Base
	R=`jq -r .basePath < ~/.fccli`
}

@test "Mint a jwt token" {
	local jwt=$(fin_jwt --user=bob --SECRET=foo)
	[ -n $jwt ]
}

@test "Verify It's Bob" {
	local jwt=$(fin_jwt --user=bob --SECRET=foo --decode)
	bob=$(jq -r '.username' <<< "$jwt")
	[ $bob = "bob" ]
}

@test "Save it" {
	fin_jwt --user=bob --SECRET=foo --save
	bob=$(fin_jwt --decode | jq -r '.username')
	[ $bob = "bob" ]
}

@test "Good Secrets are good" {
	bob=$(fin_jwt --SECRET=foo --decode | jq -r '._valid')
	[ $bob = "true" ]
}

@test "Bad Secrets are Bad" {
	bob=$(fin_jwt --SECRET=bad_secret --decode | jq -r '._valid')
	[ $bob = "false" ]
}

@test "No Secret is bad too" {
	bob=$(fin_jwt --decode | jq -r '._valid')
	[ $bob = "false" ]
}

@test "Admins Rule!" {
	local jwt=$(fin_jwt --user=bob --SECRET=foo --admin --decode)
	bob=$(jq -r '.admin' <<< "$jwt")
	[ $bob = "true" ]
}

@test "Users Drool!" {
	local jwt=$(fin_jwt --user=bob --SECRET=foo  --decode)
	bob=$(jq -r '.admin' <<< "$jwt")
	[ $bob = "false" ]
}
