#! /usr/bin/env bash
as() {
	if [[ "$1" = "admin" ]]; then
		fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin --save
	elif [[ "$1" = "Agent" ]]; then
		# This isn't exactly right, but will behave right
		fin_jwt --user='foaf:Agent' --SECRET=$JWT_SECRET --save
	else
		fin_jwt --user=$1 --SECRET=$JWT_SECRET --save
	fi;
}
