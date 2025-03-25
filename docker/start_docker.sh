#!/bin/bash

USER=$( id -un )
USERID=$( id -u )
GROUPID=$( id -g )

# tag= ..

name=${1//:/-}
container=${USER}-${name}

tag=$1

# mappings="-v /gitlocal:/gitlocal"

set -x

if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    exec docker run --rm -it \
        --privileged \
        --net host \
        -v $HOME:$HOME \
        --security-opt seccomp=unconfined \
        --hostname=$(hostname) --env DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        --name $container \
        $tag /_setup_user_shell.sh start \
            "$PWD" "$USER" "$HOME" $USERID $GROUPID

else # do not mount home onto root that is bad.
    exec docker run --rm -it \
        --privileged \
        --net host \
        --security-opt seccomp=unconfined \
        --hostname=$(hostname) --env DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        --name $container \
        $tag /_setup_user_shell.sh start \
            "$PWD" "$USER" "$HOME" $USERID $GROUPID
fi
