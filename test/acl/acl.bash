auth_add() {
     OPTS=`getopt --long acl:,mode:,to:,agent:,group: -n 'auth [options]' -- auth "$@"`
    if [ $? != 0 ] ; then echo "Bad auth_add options." >&2 ; exit 1 ; fi
    eval set -- "$OPTS"
    local mode="acl:Read"
    local to=
    local agent="foaf:Agent"
    local group=
    local authname=
    local auth=
    local slug=
    local acl=.acl
    while true; do
    	case $1 in
        --acl) acl=$2; shift 2;;
	    --mode) mode=$2; shift 2;;
        --to) to=$2; shift 2;;
	    --agent) agent=$2; shift 2;;
	    --group) mode=$2; shift 2;;
        *) break;;
    	esac
    done
    shift;
    if [[ -n $agent ]] ; then
        auth+="acl:agent $agent ; "
    fi
    if [[ -n $group ]]; then
        auth+="acl:agentClass $group ;"
    fi;
    if [[ -n $1 ]]; then
        slug="-H Slug:$1"
    fi
    fin http post $opts $acl -t "<> a acl:Authorization; $auth acl:accessTo $to; acl:mode $mode ." $slug
}

acl_create() {
    OPTS=`getopt --long dir:,label:,default -n 'acl [options]' -- acl "$@"`
    if [ $? != 0 ] ; then echo "Bad acl options." >&2 ; exit 1 ; fi
    eval set -- "$OPTS"
    local dir=
    local rdir=
    local adir=
    local label='Local Access Control'
    local default=
    while true; do
    	case $1 in
        --default) default=1; shift;;
        --label) label=$2; shift 2;;
	    --dir) dir=$2; shift 2;;
        *) break;;
    	esac
    done
    if [[ -n $dir ]]; then
        adir=`readlink -m $dir/.acl`
        rdir=`readlink -m $R/$dir`
        fin http put $opts -t "<> a ldp:BasicContainer,webac:Acl; rdfs:label \"$label\" . " $adir;
        if [[ -n $default ]]; then
            auth_add --acl=$adir --agent=foaf:Agent --mode=acl:Read --to="<$rdir>"
        fi
        # Reset adir for full path
        adir=`readlink -m $R/$dir/.acl`
        fin http patch $opts $dir -t "insert {<> acl:accessControl <${adir}> .} where {}"
    fi
 }
