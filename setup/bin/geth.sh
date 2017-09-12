#!/bin/bash
# geth wrapper script
#

if [ -f ${confdir}/geth-params.conf ] ; then
	. ${confdir}/get-params.conf
fi
GETHBIN=${GETHBIN:-/usr/bin/geth.bin}
SWARMBIN=${SWARMBIN:-/usr/bin/swarm.bin}
AIFS_DATA=${AIFS_DATA:-/var/aifs/data}
if [ ! -x $GETHBIN ] ; then
	die 127 "geth.bin not found"
fi
exec ${GETHBIN} --datadir ${AIFS_DATA} "$@"
