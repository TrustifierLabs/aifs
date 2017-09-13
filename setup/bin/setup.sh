#!/bin/bash
# AiFS setup script.
# $Id$ 
# Canonical version can be found at https://saf.ai/
# Copyright (C) 2017 saf.ai, Inc. All rights reserved.
# Copyright (C) 2017 Ahmed Masud <ahmed.masud@trustifier.com>
# 
# See https://saf.ai/licensing for details
# 


P=$(which $0)
D=$(cd $(dirname $P) && pwd)
P=$(basename $P)

AIFS_HOME=${AIFS_HOME:-$(cd $D/.. && pwd)}
AIFS_DATA=${AIFS_DATA:-/srv/aifs/data}

[ -f ${AIFS_HOME}/lib/functions.bh ] && source ${AIFS_HOME}/lib/functions.bh

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
	if [ -f ${GENESISFILE} -a -d ${statedir}/geth ]
	then
		return 0
	fi
	NONCE=$(od -An -N8 -t x8  /dev/urandom | sed s/\ //g)
	sed -e "s/{{genesis-nonce}}/0x${NONCE}/g" ${GENESISFILE_TEMPLATE} > ${GENESISFILE}
	$GETH init ${GENESISFILE}
}

fix_tools_perms() {
	pushd ${bindir}
	for k in *.sh; do 
		chmod a+x $k && ln -sf $k $(basename $k .sh)
	done
	popd
}

start() {
	if [ ! -f ${statedir}/initialized ] ; then 
		if ! $D/$P init ; then 
			exit 
		fi
	fi
	while : ; do 
		echo "Running $(date)"
		sleep 300
	done
}

case "$1" in
	init)
		fix_tools_perms
		if genesis ; then 
			touch ${statedir}/initialized
		fi
		;;
	start | run)
		start
		;;
	stop)
		;;
	dumpvars)
		set
		;;
esac
