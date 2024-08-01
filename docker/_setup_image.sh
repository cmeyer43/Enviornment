#!/bin/bash

set -e -x

apt-get update -y

# this prevents an interactive prompt during install.
ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

apt-get install -y \
    locales \
    gcc g++ bison flex less vim \
    libxext6 libxrender1 libxtst-dev libxi6 \
    git gitk git-gui \
    cmake libcairo2-dev libgirepository-1.0-dev \
    ncurses-dev tcl-dev libffi-dev libsqlite3-dev

# prevnt all those errors "cannot change locale (en_US.UTF-8)
locale-gen en_US
locale-gen en_US.UTF-8
update-locale

# Build and do whatever you want to the image

cd /tmp
mv _setup_user_shell.sh /
chmod 755 /_setup_user_shell.sh
rm -f _setup*
g++ -O3 su_reaper.cc -o /su_reaper
rm -f su_reaper.cc

exit 0
