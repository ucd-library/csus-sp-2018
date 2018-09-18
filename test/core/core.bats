#!/usr/bin/env bats

load env
load shims/fin_core
load shims/fin_jwt

@test "Make a /test" {
	# As an Admin
	fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin --save
	fin cd /
	fin_mkdir test
	run fin http get -P h test
	[ $(expr "${lines[0]}" : ".*200") -ne 0 ]
}

@test "Add /test/test2 directory" {
	fin_mkdir test/test2
	run fin http get -P h test/test2
	[ $(expr "${lines[0]}" : ".*200") -ne 0 ]
}

@test "cd /test ; see test2 make test3" {
	fin cd test
	run fin http get -P h test2
	[ $(expr "${lines[0]}" : ".*200") -ne 0 ]
}

@test "make test3" {
	fin_mkdir test3
	run fin http get -P h test3
	[ $(expr "${lines[0]}" : ".*200") -ne 0 ]
}

@test "Add to that directory" {
	fin_mkdir test/test2
	run fin http get -P h test/test2
	[ $(expr "NTTP/1.1 200 OK" : ".*200") -ne 0 ]
}

@test "Delete /test" {
	fin_delete -f test
	fin_
}

# Still Admin
@test "Add user bob" {
	fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin --save
	fin_add_user bob
	run fin http get -P h /user/bob
	[ $(expr "NTTP/1.1 200 OK" : ".*200") -ne 0 ]
}
