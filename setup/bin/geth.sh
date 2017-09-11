#!/bin/bash
# geth wrapper script
#

GETHBIN=${GETHBIN:-/usr/bin/geth.bin}
SWARMBIN=${SWARMBIN:-/usr/bin/swarm.bin}
BLOCKCHAIN_DATADIR=${BLOCKCHAIN_DATADIR:-/var/aifs/data}
if [ ! -x $GETHBIN ] ; then
	die 127 "geth.bin not found"
fi
exec ${GETHBIN} --datadir ${BLOCKCHAIN_DATADIR} "$@"
