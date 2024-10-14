#!/bin/bash

USER=$(whoami)
USER_LOWER="${USER,,}"
USER_HOME="/home/${USER_LOWER}"
WORKDIR="${USER_HOME}/.nezha-agent"
FILE_PATH="${USER_HOME}/.s5"
HYSTERIA_WORKDIR="${USER_HOME}/.hysteria"
HYSTERIA_CONFIG="${HYSTERIA_WORKDIR}/config.yaml"
CRON_S5="nohup ${FILE_PATH}/s5 -c ${FILE_PATH}/config.json >> ${USER_HOME}/s5.log 2>&1 &"
CRON_NEZHA="nohup ${WORKDIR}/start.sh >> ${USER_HOME}/nezha.log 2>&1 &"
CRON_HYSTERIA="nohup ${HYSTERIA_WORKDIR}/web server $HYSTERIA_CONFIG >> ${USER_HOME}/hysteria.log 2>&1 &"

# Cleanup existing processes
ps aux | grep "$(whoami)" | grep -v "sshd\|bash\|grep" | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1 

# Check if required files exist and add cron jobs
if [ -f "${WORKDIR}/start.sh" ] && [ -f "${FILE_PATH}/config.json" ] && [ -f "$HYSTERIA_CONFIG" ]; then
    echo "Adding cron tasks for nezha, socks5, and Hysteria."
    eval ${CRON_S5}
    eval ${CRON_NEZHA}
    sleep 3
    eval ${CRON_HYSTERIA}
elif [ -f "${WORKDIR}/start.sh" ] && [ -f "$HYSTERIA_CONFIG" ]; then
    echo "Adding cron tasks for nezha and Hysteria."
    eval ${CRON_NEZHA}
    eval ${CRON_HYSTERIA}
elif [ -f "${FILE_PATH}/config.json" ] && [ -f "$HYSTERIA_CONFIG" ]; then
    echo "Adding cron tasks for socks5 and Hysteria."
    eval ${CRON_S5}
    eval ${CRON_HYSTERIA}
elif [ -f "${WORKDIR}/start.sh" ]; then
    echo "Adding cron task for nezha."
    eval ${CRON_NEZHA}
elif [ -f "${FILE_PATH}/config.json" ]; then
    echo "Adding cron task for socks5."
    eval ${CRON_S5}
elif [ -f "$HYSTERIA_CONFIG" ]; then
    echo "Adding cron task for Hysteria."
    eval ${CRON_HYSTERIA}
else
    echo "No valid configuration files found."
fi
