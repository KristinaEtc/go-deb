#!/usr/bin/make -f

GO=$(shell which go)
#GO = @go build
GOINSTALL=$(GO) install
GOBUILD=$(GO) build
GOCLEAN=$(GO) clean
GOGET=$(GO) get

EXENAME = go-stomp-server
#BUILDPATH ="/usr/local/$(EXENAME)"
BUILDPATH = /

logdir = "/var/log/${EXENAME}"
bindir = "/usr/bin"
demondir = "/etc/init"
confdir = "/etc/${EXENAME}"

CONF = "${EXENAME}.config"
LOGCONF = "${EXENAME}.logconfig"
DEMONF = "${EXENAME}.conf"

GOFLAGS = "-o go-stomp-server \
	  -ldflags \"-X github.com/KristinaEtc/slflog.configLogFile=${confdir}/${LOGCONF} \
	  -X main.configFile=${confdir}/${CONF}\" "

all: build

info:
	@echo "Makefile for go-stomp-server. Installing..."
	@echo "${BUILDPATH}"

makedir:
	@echo -n "Start building a tree... "
	@if [ ! -d ${BUILDPATH} ] ; then mkdir ${BUILDPATH} ; fi
	@if [ ! -d ${demondir} ] ; then mkdir -p ${demondir} ; fi
	@if [ ! -d ${bindir} ] ; then mkdir -p ${bindir} ; fi
	@if [ ! -d ${logdir} ] ; then mkdir -p ${logdir} ; fi
	@if [ ! -d ${confdir} ] ; then mkdir -p ${confdir} ; fi
	@echo "Done."

configure:
	@echo -n "Preparing config files... "
	@cp ${CONF} ${confdir}/${CONF}
	@cp ${LOGCONF} ${confdir}/
	@cp ${DEMONF} ${demondir}
	@echo "Done."

getlibs:
	@echo -n "Getting dependencies... "
	@if ( [ ! -d ${GOROOT}/src/github.com/KristinaEtc/slflog" ] || [ ! -d ${GOPATH}/src/github.com/KristinaEtc/slflog" ] ) ; then \
		${GOGET} github.com/KristinaEtc/slflog ; fi
	@if ( [ ! -d ${GOROOT}/src/github.com/src/github.com/kardianos/osext" ] || [ ! -d ${GOPATH}/src/github.com/kardianos/osext" ] ) ; then \
		${GOGET} github.com/kardianos/osext ; fi
	@if ( [ ! -d ${GOROOT}/src/github.com/KristinaEtc/auth" ] || [ ! -d ${GOPATH}/src/github.com/KristinaEtc/auth" ] ) ; then \
		${GOGET} github.com/KristinaEtc/auth ; fi
	@if ( [ ! -d ${GOROOT}/src/github.com/ventu-io/slf" ] || [ ! -d ${GOPATH}/src/github.com/ventu-io/slf" ] ) ; then \
		${GOGET} github.com/ventu-io/slf ; fi
	@echo "Done."

build:
	@echo -n "Start building a project... "
	@${GOBUILD} $(shell echo $(GOFLAGS))"${EXENAME}.go"
	@echo "Done."

getbin:
	@mv ${EXENAME} ${bindir}/

clean:
	@echo -n "Deleting unnecessary files..."
	rm -r autom4te.cache/ backup-*tgz config.status configure *.deb config.log

install: info makedir configure getlibs getbin

.PHONY: info makedir configure getlibs build
