#!/bin/bash
# AiFS setup script.
# 
# Canonical version can be found at https://saf.ai/
# Copyright (C) 2017 saf.ai, Inc. All rights reserved.
# Copyright (C) 2017 Ahmed Masud <ahmed.masud@trustifier.com>
# 
# See https://saf.ai/licensing for details
# 

AIFS_DATA=${AIFS_DATA:-/srv/aifs/data}
bindir=${AIFS_HOME}/bin
sharedir=${AIFS_HOME}/share
statedir=/var/state/aifs
test -d ${bindir} || mkdir -p ${bindir}
test -d ${sharedir} || mkdir -p ${sharedir}
test -d ${statedir} || mkdir -p ${statedir}
test -d ${confdir}  || mkdir -p ${confdir}

GETH=${bindir}/geth

T() {
	echo $1
}

die() {
	local rv=${1:-127}
	shift
	echo $(T "ERROR")"(${rv}):" $@ 1>&2
	exit $rv
}


genesis() {
	GENESISFILE=${statedir}/aifs-ethereum-genesis.json
	GENESISFILE_TEMPLATE=${sharedir}/genesis-template.json
	NONCE=$(od -An -N8 -t x8  /dev/urandom | sed s/\ //g)
	set -x
	sed -e "s/{{genesis-nonce}}/0x${NONCE}/g" ${GENESISFILE_TEMPLATE} > ${GENESISFILE}
	set +x
	cat ${GENESISFILE}
	$GETH init ${GENESISFILE}
	return 0
}

fix_tools_perms() {
	pushd ${bindir}
	for k in *.sh; do 
		chmod a+x $k && ln -sf $k $(basename $k .sh)
	done
	popd
}
case "$1" in
	docker-build)
		fix_tools_perms
		genesis
		;;
esac
