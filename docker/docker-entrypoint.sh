#!/bin/sh
set -e

# [关键修复] 暂停 3 秒，等待 RouterOS 网卡初始化，防止无限重启
sleep 3

# 根据环境变量判断运行模式
EXEC_NAME="phantun-server"
if [ "${RUN_MODE}" = "client" ]; then
    EXEC_NAME="phantun-client"
fi

# 检查必要参数
if [ -z "${LOCAL_ADDR}" ]; then echo "Error: LOCAL_ADDR is not set"; exit 1; fi
if [ -z "${REMOTE_ADDR}" ]; then echo "Error: REMOTE_ADDR is not set"; exit 1; fi

# 拼接可选参数
ARGS=""
if [ ! -z "${TUN_NAME}" ]; then ARGS="$ARGS --tun ${TUN_NAME}"; fi
if [ ! -z "${TUN_LOCAL}" ]; then ARGS="$ARGS --tun_local ${TUN_LOCAL}"; fi
if [ ! -z "${TUN_PEER}" ]; then ARGS="$ARGS --tun_peer ${TUN_PEER}"; fi

echo "Starting Phantun (${EXEC_NAME}) on Alpine..."
echo "Local: ${LOCAL_ADDR} -> Remote: ${REMOTE_ADDR}"

# 使用 exec 启动以接收系统信号
exec ${EXEC_NAME} \
  --local ${LOCAL_ADDR} \
  --remote ${REMOTE_ADDR} \
  $ARGS \
  "$@"
