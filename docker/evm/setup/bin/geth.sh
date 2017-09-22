#!/bin/bash
# geth wrapper script
#

P=$(which $0)
D=$(cd $(dirname $P) && pwd)
P=$(basename $P)

AIFS_HOME=${AIFS_HOME:-$(cd $D/.. && pwd)}
AIFS_DATA=${AIFS_DATA:-/srv/aifs/data}
GETHPARAMS=${GETHPARAMS:-}


add_geth_params() {
	GETHPARAMS=${GETHPARAMS:-}
	GETHPARAMS="${GETHPARAMS} $@"
}

[ -f ${AIFS_HOME}/lib/functions.bh ] && source ${AIFS_HOME}/lib/functions.bh

GETHBIN=${GETHBIN:-/usr/bin/geth.bin}
SWARMBIN=${SWARMBIN:-/usr/bin/swarm.bin}
AIFS_HOME=${AIFS_HOME:-/srv/aifs}
AIFS_DATA=${AIFS_DATA:-/var/aifs/data}

if [ ! -x $GETHBIN ] ; then
	die 127 "geth.bin not found"
fi

if [ -f ${confdir}/geth-params.conf ] ; then
	. ${confdir}/get-params.conf
fi

add_geth_params --datadir ${GETH_DATA:-${AIFS_DATA}} 
add_geth_params --identity ${GETH_IDENTITY:-master.saf.ai.local}
add_geth_params --rpc --rpcapi ${GETH_RPCAPI:-db,eth,net,web3 }
add_geth_params --rpccorsdomain ${GET_CORSDOMAIN:-https://localhost}
add_geth_params --nodiscover
echo executing ${GETHBIN} ${GETHPARAMS} "$@"
exec ${GETHBIN} ${GETHPARAMS} "$@"
