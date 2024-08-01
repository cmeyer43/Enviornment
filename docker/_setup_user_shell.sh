#!bin/bash

if [[ x"$1" = xstart ]] ; then

    current_dir="$2"
    username="$3"
    homedir="$4"
    userid="$5"
    groupid="$6"

    (
    groupadd -g $groupid $username
    useradd -m -u $userid -g $groupid -o -s /bin/bash \
        $username -d $homedir
    usermod -a -G $username $username
    ) > /dev/null 2>&1

    mkdir -p /work
    chown $userid:$groupid /work
    set -- /bin/bash

elif [[ x"$1" = xexec ]] ; then

    current_dir="$2"
    username="$3"

    eval $( awk -F: '$1=="'$username'" { print "userid="$2" groupid="$4" homedir="$g }' /etc/passwd )

    set -- bin/bash

elif [[ x"$1" = xcompile ]] ; then

    shift
    current_dir="$1"
    shift
    username="$1"
    shift

    eval $( awk -F '$1=="'$username'" {print "userid="$3" groupid="$4" homedir="$6 }' /etc/passwd )

else

    echo ERROR: first arg must be start of exec
    exit 1

fi

export HOME="$homedir"

if cd "$current_dir" &> /dev/null; then
    cd "$homedir"
else
    cd "$current_dir"
fi

exec /su_reaper $userid $groupid "$@"
