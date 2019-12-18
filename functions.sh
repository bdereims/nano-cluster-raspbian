#!/bin/bash
#bdereims@gmail.com


add_to_file() {
	# $1 : host 
	# $2 : value
	# $3 : file
	ssh ${1} "grep -P \"${2}\" ${3} 2>&1 > /dev/null || printf \"${2}\\n\" >> ${3}"
}

print_style() {
    if [ "$2" == "info" ] ; then
        COLOR="96m"
    elif [ "$2" == "success" ] ; then
        COLOR="92m"
    elif [ "$2" == "warning" ] ; then
        COLOR="93m"
    elif [ "$2" == "danger" ] ; then
        COLOR="91m"
    else #default color
        COLOR="0m"
    fi

    STARTCOLOR="\e[$COLOR"
    ENDCOLOR="\e[0m"

    printf "$STARTCOLOR%b$ENDCOLOR" "=== $1\n"
}

remote_exec() {
        # ${1}: host
        # ${2}: command
        sshpass -p${DEFAULT_PASSWD} ssh -o StrictHostKeyChecking=no ${DEFAULT_USER}@${1} "${2}"
}

remote_cp() {
        # ${1}: file
        # ${2}: target
        sshpass -p${DEFAULT_PASSWD} scp -o StrictHostKeyChecking=no "${1}" "${2}"
}

node_list() {
	local -n arr=$1
        for (( i=1; i<=${HOST_NUM}; i++))
        do
                NODE=${HOST_HEADER}${i}
		arr+=("${NODE}")
        done
}
