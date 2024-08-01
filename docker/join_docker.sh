#!/bin/bash

USER=$( id -un )

name=${1//:/-}
container=${USER}-${name}

if [[ "$1" = "root" ]] ; then
    exec docker exec -it $contianer /bin/bash
else
    exec docker exec -it \ $container /_setup_user_shell.sh exec "$PWD" "$USER"
