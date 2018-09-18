#!/usr/bin/env bash

base64_encode()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl enc -base64 -A
}

base64_decode()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl enc -base64 -d -A
}

hmacsha256_sign()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${SECRET}"
}

hmacsha256_encode()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${SECRET}"
}

verify_signature()
{
	expected=$(echo ${1} | hmacsha256_encode |  base64_encode)
	actual=${2}

	if [ "${expected}" = "${actual}" ]
	then
		echo true
	else
		echo false
	fi
}

function decode() {
	now=$(date +%s)
	IFS='.' read -ra pieces <<< "$1"
	local header=${pieces[0]}
	local payload=${pieces[1]}
	local signature=${pieces[2]}
	local v=$(verify_signature "${header}.${payload}" "${signature}")
	payload=$(base64_decode ${payload})
	echo $payload | jq --arg v $v --argjson now $now '._valid=$v | ._now=$now'
}

<<=cut

=head1 USAGE

 fin jwt [options]

=head1 OPTIONS

=over 4

=item B<--SECRET=>I<serversecret> This allows for server testing when you have a
 secret. If passed, this will create a local jwt token with the passed
 parameters.  This should be a good indicator that it's important to keep your secrets secret.

=item B<--user=>I<username>
 This is the user logging logging into the server.

=item B<--admin>
If the user has admin privledges, they can specify a token with admin privledges as well. You cannot use the I<admin> and I<agent> tokens together.

=item B<--decode>
This will decode your token. Note that even if you don't know your SECRET, this will show you your payload, as per JWT tokens.

=item B<--save>
This saves your token to your ~/.fccli file.


=back
=cut

function fin_jwt() {
    OPTS=`getopt --long SECRET:,user:,admin,save,decode -n 'jwt [options]' -- login "$@"`
    if [ $? != 0 ] ; then echo "Bad login options." >&2 ; return 1 ; fi
    eval set -- "$OPTS"
    local SECRET=
    local user=
		local decode=
    local admin='false'
		local save=
		local payload=
		local header='{ "typ": "JWT", "alg": "HS256" }'
		local signature=

    while true; do
    	case $1 in
        --SECRET) SECRET=$2; shift 2;;
				--decode) decode=1; shift;;
				--user) user=$2; shift 2;;
				--admin) admin='true'; shift;;
				--save) save=1; shift;;
				*) break;;
    	esac
    done
    shift;

		iat=$(date +%s)

		if [[ -n $user ]]; then
			exp=$(date --date='now + 1 day' +%s)

			payload=$(printf '{ "iss":"library.ucdavis.edu","username":"%s","admin":%s,"iat":%s,"exp":%s}' $user $admin $iat $exp)

			header_base64=$(echo $header | base64_encode)
			payload_base64=$(echo $payload  | base64_encode)

			header_payload=$(echo "${header_base64}.${payload_base64}")
			signature=$(echo "${header_payload}" | hmacsha256_sign | base64_encode)

			jwt="${header_payload}.${signature}"
		else
			jwt=$(jq -r .jwt < ~/.fccli)
		fi

		if [[ -n $save ]]; then
			old=$(cat ~/.fccli)
			echo $old | jq --arg jwt "${jwt}" '.jwt=$jwt' > ~/.fccli
		else
			if [[ -n $decode ]]; then
				decode $jwt
			else
				echo "${jwt}"
			fi
		fi
}
