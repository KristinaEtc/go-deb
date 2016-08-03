#!/bin/bash

set -e

make
sudo checkinstall -D --pkgversion=0.6.1 --pkgname=go-stomp-server \
       --maintainer="Kristina Kovalevskaya isitiriss@gmail.com" --autodoinst=yes \
       --spec=ABOUT.md --provides="" --pkgsource=go-stomp-server

RETVAL=$?
[ $RETVAL -eq 0 ] && echo Success
[ $RETVAL -ne 0 ] && echo Failure
