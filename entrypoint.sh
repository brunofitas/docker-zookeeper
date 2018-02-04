#!/bin/bash

ZOO_CFG="/opt/zookeeper/conf/zoo.cfg"

echo ${ID:-1} >> ${DATA_DIR:-/var/zookeeper}/myid

echo tickTime=${TICK_TIME:-2000}            >  ${ZOO_CFG}
echo initLimit=${INIT_LIMT:-10}             >> ${ZOO_CFG}
echo syncLimit=${SYNC_LIMT:-5}              >> ${ZOO_CFG}
echo dataDir=${DATA_DIR:-/var/zookeeper}    >> ${ZOO_CFG}
echo clientPort=${CLIENT_PORT:-2181}        >> ${ZOO_CFG}

if [[ ! -z "${MAX_CLIENT_CONXNS}" ]]; then
    echo "maxClientCnxns=${MAX_CLIENT_CONXNS:-60}" >> ${ZOO_CFG}
fi


if [[ ! -z "${AUTO_PURGE__SNAP_RETAIN_COUNT}" ]]; then
    echo "autopurge.snapRetainCount=${AUTO_PURGE__SNAP_RETAIN_COUNT:-3}" >> ${ZOO_CFG}
fi


if [[ ! -z "${AUTO_PURGE__PURGE_INTERVAL}" ]]; then
    echo "autopurge.purgeInterval=${AUTO_PURGE__PURGE_INTERVAL:-1}" >> ${ZOO_CFG}
fi


for VAR in `env`
do
    if [[ $VAR =~ ^SERVER_[0-9]+ ]]; then
        IFS='=' read -a pair <<< "${VAR}"
        IFS='_' read -a server <<< "${pair[0]}"
        echo "server.${server[1]}=${pair[1]}" >> ${ZOO_CFG}
    fi
done

/opt/zookeeper/bin/zkServer.sh start-foreground