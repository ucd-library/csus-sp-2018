: <<=cut
=pod
=head 1 NAME
  fin_add_user - Shim for standard user Addition

=head 1 USAGE
  fin_add_user $name

=cut
fin_add_user () {
    local u=$1
    fin_mkdir /user/$u
    # Add to system so Even if user removes local .acl, they still have access.
    auth_add --acl=/.acl --agent=user:$u --mode=acl:Read,acl:Write --to="<$R/user/$u>"
    # Create a user definable .acl for this user.
    acl_create --dir=/user/$u
    # Add to system so Even if user removes local .acl, they still have access.
    auth_add --acl=/.acl --agent=user:$u --mode=acl:Read,acl:Write --to="<$R/user/$u>"
    auth_add --acl=/.acl --agent="\"$u\"" --mode=acl:Read,acl:Write --to="<$R/user/$u>"

    # Add to Read/Write for user, Read for users
    auth_add --acl=/user/$u/.acl --agent=user:$u --mode=acl:Read,acl:Write --to="<$R/user/$u>"
    auth_add --acl=/user/$u/.acl --agent="\"$u\"" --mode=acl:Read,acl:Write --to="<$R/user/$u>"
    auth_add --acl=/user/$u/.acl --agent=foaf:Agent --mode=acl:Read --to="<$R/user/$u>"
}

: <<=cut
=pod
=head 2 add_group
Passed the user_id (as in user/quinn).  Creates a new user in the appropriate location
=cut
fin_add_group () {
    local u=$1
    local file
    if [[ -n $2 ]]; then
        file="--file=$2"
    fi
    fin_mkdir $file /collection/$u
    # Create a user definable .acl for this user.
    acl_create --dir=/collection/$u --default
    fin_mkdir /collection/$u/group
    fin http put /collection/$u/group/admin -t '<> a foaf:Group ; foaf:member "quinn","jrmerz" "enebeker" .'
    # Add to Read/Write for user, Read for users
    auth_add --acl=/collection/$u/.acl --group="<$R/collection/$u/group/admin>" --mode=acl:Read,acl:Write --to="<$R/collection/$u>"
    auth_add --acl=/collection/$u/.acl --agent=foaf:Agent --mode=acl:Read --to="<$R/collection/$u>"
    # members is where the data goes.
    fin_mkdir --hasMember=pcdm:hasMember --isMemberOf=pcdm:memberOf --resource="<$R/collection/$u>" /collection/$u/members
}

: <<=cut
=pod
This is the main initialization program. Eventually, the above functions will be gone, and
we will just have
=cut
