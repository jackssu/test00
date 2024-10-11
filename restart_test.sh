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
declare -a tasks
[ -f "${WORKDIR}/start.sh" ] && tasks+=("${CRON_NEZHA}")
[ -f "${FILE_PATH}/config.json" ] && tasks+=("${CRON_S5}")
[ -f "$HYSTERIA_CONFIG" ] && tasks+=("${CRON_HYSTERIA}")

# 执行启动命令
if [ ${tasks[@]} -gt 0 ]; then
    echo "添加以下 crontab 重启任务:"
    for task in "${tasks[@]}"; do
        echo "执行: $task"
        eval "$task"
    done
else
    echo "没有找到可执行的任务文件."
fi
