USER=$(whoami)
USER_LOWER="${USER,,}"
USER_HOME="/home/${USER_LOWER}"
WORKDIR="${USER_HOME}/.nezha-agent"
FILE_PATH="${USER_HOME}/.s5"
HYSTERIA_WORKDIR="${USER_HOME}/.hysteria"
HYSTERIA_CONFIG="${HYSTERIA_WORKDIR}/config.yaml"

# 启动命令
CRON_S5="nohup ${FILE_PATH}/s5 -c ${FILE_PATH}/config.json >/dev/null 2>&1 &"
CRON_NEZHA="nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &"
CRON_HYSTERIA="nohup ${HYSTERIA_WORKDIR}/web server $HYSTERIA_CONFIG >/dev/null 2>&1 &"

# 杀死当前用户的相关进程
pkill -u $(whoami) -f 's5|start.sh|web server'

# 检查文件并添加启动任务
if [ -f "${WORKDIR}/start.sh" ]; then
    echo "添加 nezha 的 crontab 重启任务"
    $CRON_NEZHA
fi

if [ -f "${FILE_PATH}/config.json" ]; then
    echo "添加 socks5 的 crontab 重启任务"
    $CRON_S5
fi

if [ -f "$HYSTERIA_CONFIG" ]; then
    echo "添加 Hysteria 的 crontab 重启任务"
    $CRON_HYSTERIA
fi

if [ ! -f "${WORKDIR}/start.sh" ] && [ ! -f "${FILE_PATH}/config.json" ] && [ ! -f "$HYSTERIA_CONFIG" ]; then
    echo "没有找到可执行的任务文件."
fi
