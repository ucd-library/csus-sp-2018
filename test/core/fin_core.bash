#! /bin/bash

# This example assumes that you already have your fin-cli setup with a user with administrative permissions.
fin_delete() {
     OPTS=`getopt -o f  --long force,tombstone -n 'inf4 delete' -- "$@"`
    if [ $? != 0 ] ; then echo "Bad delete options." >&2 ; exit 1 ; fi
    eval set -- "$OPTS"
    tombstone=
    while true; do
    	case $1 in
	    -f | --force | --tombstone) tombstone=1; shift;;
	    --) shift; break;;
    	*) break;;
    	esac
    done
    if [[ -n $1 ]]; then
        fin http delete $1;
        if [[ -n $tombstone ]]; then
            fin http delete $1/fcr:tombstone
        fi
    fi
}

fin_mkdir() {
    OPTS=`getopt -o @:P: --long check-status,print:,file:,hasMember:,isMemberOf:,resource: -n 'mkdir [options]' -- mkdir "$@"`
    if [ $? != 0 ] ; then echo "Bad mkdir options." >&2 ; return 1 ; fi
    eval set -- "$OPTS"
    local a="<> a ldp:BasicContainer ."
    local file=
    local hasMember=
    local isMemberOf=
    local resource='..'
		local opts=
    while true; do
    	case $1 in
        -@ | --file ) file=$2; shift 2;;
				--check-status) opts+=' --check-status '; shift;;
				--hasMember) hasMember=$2; shift 2;;
				--isMemberOf) isMemberOf=$2; shift 2;;
				--resource) resource=$2; shift 2;;
				-P | --print) opts+=" -P $2 "; shift 2;;
				--) shift; break;;
    		*) break;;
    	esac
    done
    shift;

    if [[ -n $1 ]]; then
      if [[ -n $file ]]; then
        fin http put $opts -@ $file $1
      elif [[ -n $hasMember ]] ; then
				if [[ -n $isMemberOf ]]; then
          a="<> a ldp:DirectContainer; ldp:hasMemberRelation $hasMember; ldp:membershipResource $resource; ldp:isMemberOfRelation $isMemberOf ."
				else
          a="<> a ldp:DirectContainer; ldp:hasMemberRelation $hasMember; ldp:membershipResource $resource ."
        fi
			elif [[ -n $isMemberOf ]]; then
        a="<> a ldp:DirectContainer; ldp:isMemberOfRelation $isMemberOf; ldp:membershipResource $resource ."
			fi
			echo "opts:$opts" 1>&2
      fin http put $opts -t "$a" $1
    fi
}
