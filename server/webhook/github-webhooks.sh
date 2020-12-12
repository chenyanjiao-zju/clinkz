#!/bin/bash
#
# This file should be re-written due to redundant code
#
# TODO: refactor
#
host="127.0.0.1:6009"
group_id="694138498"

notify_group() {
    local id=$1
    shift
    local msg="[$(date +'%Y-%m-%dT%H:%M:%S')] $*"
    local token="123abc"
    curl -G \
        --data-urlencode "access_token=123abc" \
        --data-urlencode "group_id=${id}" \
        --data-urlencode "message=${msg}" \
        "http://${host}/send_group_msg"
}

on_ping() {
    notify_group ${group_id} "User $1 pinging."
}

on_member() {
# check argc
    if [ $# -ne 4 ]; then
        exit 1
    else
        notify_group ${group_id} "User $1 $2 member $4 in repo $3."
    fi
}

on_organization() {
    if [ $# -ne 3 ]; then
        exit 1
    else
        notify_group ${group_id} "User $1 $2 user $3."
    fi
}

on_public() {
    if [ $# -ne 2 ]; then
        exit 1
    else
        notify_group ${group_id} "Repo $2 is made public by user $1."
    fi
}

on_pull_request() {
    if [ $# -ne 4 ]; then
        exit 1
    else
        notify_group ${group_id} "User $1 $2 pull request #$4 in repo $3."
    fi
}

on_push() {
    if [ $# -eq 4 ]; then
        notify_group ${group_id} "User $1 pushed $3 of commit(s) $4 (,etc) to repo $2."
    else
        notify_group ${group_id} "User $1 pushed $3 to repo $2."
    fi
}

on_repository() {
    if [ $# -ne 3 ]; then
        exit 1
    else
        notify_group ${group_id} "User $1 $2 repo $3."
    fi
}

on_repository_import() {
    if [ $# -ne 3 ]; then
        exit 1
    else
        notify_group ${group_id} "User $1 importing $2 is on $3."
    fi
}

on_issues() {
    if [ $# -ne 4 ]; then
        exit 1
    else
        notify_group ${group_id} "User $1 $2 issue #$4 in repo $3."
    fi
}

dispatch() {
    local event=$1
    shift
    if [ ${event} = "member" ]; then
        on_member $@
    elif [ ${event} = "organization" ]; then
        on_organization $@
    elif [ ${event} = "public" ]; then
        on_public $@
    elif [ ${event} = "pull_request" ]; then
        on_pull_request $@
    elif [ ${event} = "push" ]; then
        on_push $@
    elif [ ${event} = "repository" ]; then
        on_repository $@
    elif [ ${event} = "repository_import" ];then
        on_repository_import $@
    elif [ ${event} = "issues" ];then
        on_issues $@
    elif [ ${event} = "ping" ]; then
        on_ping $@
    else
        exit 1
    fi
}

main() {
    dispatch $@
}

main $@
