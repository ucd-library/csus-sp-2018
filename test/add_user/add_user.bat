#!/usr/bin/env bats

setup() {
	load ../env
	load ../helpers
	load ../shims/fin_core
	load ../shims/fin_jwt
	load ../shims/acl
	load ../shims/fin_user
	# Our functions expect $R to point to the Base
	R=`jq -r .basePath < ~/.fccli`

}

@test "Admin deletes user bob" {
	as admin
	fin_delete -f /user/bob
	# Remove Bob from system .acl
	for i in $(fin ls /.acl); do
		b=$(fin http get -P b /.acl/$i);
		if [[ -n "$(grep agent <<< "$b" | grep bob)" ]];
		then fin_delete /.acl/$i ;fi ;
	done
}

@test "Admin adds user bob" {
	as admin
	fin_add_user bob
	run fin http get -P h /user/bob
	[ $(expr "${lines[0]}" : ".*200") -ne 0 ]
}

@test "bob can write to /user/bob" {
	as bob
	fin_mkdir /user/bob/bobcan
	run fin http get -P h /user/bob/bobcan
	[ $(expr "${lines[0]}" : ".*200") -ne 0 ]
}
