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
config_dirs

GETH=${bindir}/geth



genesis() {
	GENESISFILE=${statedir}/aifs-ethereum-genesis.json
	GENESISFILE_TEMPLATE=${sharedir}/genesis-template.json
	if [ -f ${GENESISFILE} -a -d ${datadir}/geth ]
	then
		echo Genesis has already taken place
		return 0
	fi
	NONCE=$(od -An -N8 -t x8  /dev/urandom | sed s/\ //g)
	sed -e "s/{{genesis-nonce}}/0x${NONCE}/g" ${GENESISFILE_TEMPLATE} > ${GENESISFILE}
	$GETH init ${GENESISFILE}
}

fix_tools_perms() {
	pushd ${bindir} >/dev/null 
	for k in *.sh; do 
		chmod a+x $k && ln -sf $k $(basename $k .sh)
	done
	popd >/dev/null 
}

start() {
	if [ ! -f ${datadir}/initialized ] ; then 
		echo Looking to see if we need to initialize
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
		if [ -f ${datadir}/initialized ] ;then
			info Already initialized on $(grep date: ${datadir}/initialized)
			exit 0
		fi
		fix_tools_perms
		if genesis ; then 
			echo "date: $(date)" > ${datadir}/initialized
		else
			exit
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
