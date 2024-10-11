#!/bin/bash 

USERNAME=$(whoami)
WORKDIR="/home/${USERNAME}/.nezha-dashboard"

if ! pgrep -f "dashboard" > /dev/null; then 
    nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &
    sleep 3
    if pgrep -f "dashboard" > /dev/null; then
        echo "nezha-dashboard 已启动"
    else
        echo "nezha-dashboard 启动失败"
    fi
fi