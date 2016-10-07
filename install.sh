#!/bin/bash

set +e

# Creation needed directories
echo -n "Start building a tree... "
if [ ! -d $BUILDPATH ] ; then mkdir $BUILDPATH ; fi
if [ $DEMON_FL == true ];
then
        if [ ! -d $DEMONDIR ] ; then mkdir -p $DEMONDIR ; fi
fi

if [ $TEST_FILE_FL == true ];
then
        if [ ! -d $TESTDIR ] ; then mkdir -p $TESTDIR ; fi
fi

if [ ! -d $BINDIR ] ; then mkdir -p $BINDIR ; fi
#if [ ! -d $LOGDIR ] ; then mkdir -p $LOGDIR ; fi
#echo 'log directory' > $LOGDIR/$EXENAME 
if [ ! -d $CONFDIR ] ; then mkdir -p $CONFDIR ; fi
echo "Done."

# Moving executable file to bin directory
cp $EXENAME $BINDIR/
chmod 755 $BINDIR/$EXENAME

# Copying configs
echo -n "Preparing config files... "
cp $PATH_TO_SOURCE/$CONF_SOURCE  $CONFDIR/$CONF
if [ $DEMON_FL == true ];
then
        cp  $DEMON_CONF $DEMONDIR
fi
if [ $TEST_FILE_FL == true ];
then
        cp $PATH_TO_SOURCE/$TEST_FILE $TESTDIR/
fi
echo "Done."

#getlibs:
#	@echo -n "Getting dependencies... "
#	@echo "Done."


#######################################################################
##
## Mysterious lines for adding seted values to preinst/postinst scripts
##
#######################################################################

# delete the first line of a file
sed  -i '1d' preinstall-pak

sed -i '/DEB_USER=/d' preinstall-pak

## In first line: append second line with a newline character between them.
#1N;
## Do the same with third line.
#N;
## When found three consecutive blank lines, delete them. 
## Here there are two newlines but you have to count one more deleted with last "D" command.
# /^\n\n$/d;
## The combo "P+D+N" simulates a FIFO, "P+D" prints and deletes from one side while "N" appends
## a line from the other side.
sed -i '
    N;
    /^\n$/d;
    P;
    D
' preinstall-pak

echo -e "\nDEB_USER=${DEB_USER}\n$(cat preinstall-pak)\n" > preinstall-pak
sed -i '1i#!/bin/bash' preinstall-pak

## Postinstall 

 # delete the first line of a file
 sed  -i '1d' postinstall-pak

sed -i '/DEB_USER=/d' postinstall-pak
sed -i '/CONFDIR=/d' postinstall-pak
sed -i '/LOGDIR=/d' postinstall-pak
sed -i '/UUIDDIR=/d' postinstall-pak

sed -i '
    N;
    /^\n$/d;
    P;
    D
' postinstall-pak

echo -e "\nDEB_USER=${DEB_USER}
LOGDIR=${LOGDIR}
CONFDIR=${CONFDIR}
UUIDDIR=${UUIDDIR}
$(cat postinstall-pak)\n" > postinstall-pak

sed -i '1i#!/bin/bash' postinstall-pak

## Preremove

# delete the first line of a file
sed  -i '1d' preremove-pak

sed -i '/PKGNAME=/d' preremove-pak

sed -i '
    N;
    /^\n$/d;
    P;
    D
' preremove-pak

echo -e "\nPKGNAME=${PKGNAME}\n$(cat preremove-pak)\n" > preremove-pak
sed -i '1i#!/bin/bash' preremove-pak





