#!/usr/bin/env bats

load env
load shims/fin_core
load shims/fin_jwt
load shims/
load shims/add_user

fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin

@test "Add user bob" {
	# As admin
	fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin --save
	# Create Bob
	fin_add_user
	[ true ]
}
@test "addition using cd" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}

@test "addition using dc" {
  result="$(echo 2 2+p | dc)"
  [ "$result" -eq 4 ]
}
