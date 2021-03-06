#!/bin/bash
set -e

# Set values, that are specific to each project
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
export UUIDDIR="/var/lib/$EXENAME"

# Names of config files
export CONF_SOURCE="$EXENAME-deb.config"
export CONF="$EXENAME.config"

export DEMON_CONF="$EXENAME.conf"
export TEST_FILE="test.csv"
#LOGCONF = "$EXENAME.logconfig"

export PATH_TO_SOURCE="$(pwd)/.."

# Go enviromnent
GO="$(which go)"
GOINSTALL="$GO install"
GOBUILD="${GOPATH}/bin/govvv build"
GOCLEAN="$GO clean"
GOGET="$GO get"

GO_LDFLAGS=" -X github.com/KristinaEtc/config.configPath=${CONFDIR}/${CONF} \
	  -X github.com/KristinaEtc/config.CallerInfo=${CALLER_INFO} ${OTHER_FLAGS}"

CURR_PWD=$(pwd)

BUILD_FILES="go-stomp-nominatim.go geocode.go monitoring.go"

cd ${PATH_TO_SOURCE}

# Moving executable file to bin directory
echo -n "Start building an executable... "

#cat $GOBUILD -o "${PKGNAME}" -ldflags "${GO_LDFLAGS}" ${BUILD_FILES}
$GOBUILD -o "${PKGNAME}" -ldflags "${GO_LDFLAGS}" ${BUILD_FILES}
echo "Done."

cp ${PKGNAME} ${CURR_PWD}
cd ${CURR_PWD}

cd "${PATH_TO_SOURCE}"
export VERSION="$(cat ${PATH_TO_SOURCE}/VERSION)-$(git describe --tags --dirty --always)-$(git symbolic-ref -q --short HEAD)"
cd -

fakeroot checkinstall -y -D --pkgversion=$VERSION --pkgname=$PKGNAME \
      --maintainer="\"$MAINTAINER\""  --install=no --fstrans=yes --spec=ABOUT.md --provides="" \
      --pkgsource=$EXENAME ./install.sh

# Deleting unnecessary files
rm -r backup-*tgz

#RETVAL=$?
#[ $RETVAL -eq 0 ] && echo Success
#[ $RETVAL -ne 0 ] && echo Failure
