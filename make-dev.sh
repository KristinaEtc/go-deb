#!/bin/bash
set -e

# Set values, that are specific to each project

#TODO: change ../ to $(PATH_TO_SOURCE)
export VERSION=$(cat ../VERSION)
export PKGNAME=go-stomp-nominatim
export MAINTAINER="Kristina Kovalevskaya <isitiriss@gmail.com>"
export EXENAME="go-stomp-nominatim"
export BUILDPATH="/"

# Building specific values
export CALLER_INFO=true
export TEST_FILE_FL=false
export DEMON_FL=true

# Deb user which will run prog
export DEB_USER=stomp

# In which project deploy
export LOGDIR="/var/log/$EXENAME"
export BINDIR="/usr/bin"
export DEMONDIR="/etc/init"
export CONFDIR="/etc/$EXENAME"
export TESTDIR="/usr/share/$EXENAME"

# Names of config files
export CONF="$EXENAME.config"
export DEMON_CONF="$EXENAME.conf"
export TEST_FILE="test.csv"
#LOGCONF = "$EXENAME.logconfig"

export PATH_TO_SOURCE="$(pwd)/.."

fakeroot checkinstall -D --pkgversion=$VERSION --pkgname=$PKGNAME \
      --maintainer="\"$MAINTAINER\""  --install=no --fstrans=yes --spec=ABOUT.md --provides="" \
      --pkgsource=$EXENAME ./install.sh

# Deleting unnecessary files
rm -r backup-*tgz

RETVAL=$?
[ $RETVAL -eq 0 ] && echo Success
[ $RETVAL -ne 0 ] && echo Failure
