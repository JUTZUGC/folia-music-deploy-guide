#!/usr/bin/env bash
set -euo pipefail
# Folia Music 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/chthollyphile/folia-major/blob/main/deploy/docker/README.md
# 更新日期：2026-11-02
# 类型：docker
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "需要先安装 Docker"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "需要 Docker Compose v2（docker compose 子命令）"; exit 1; }

mkdir -p .download
cd .download

mkdir folia-docker && cd folia-docker
curl -fL https://raw.githubusercontent.com/chthollyphile/folia-major/main/deploy/docker/compose.yaml -o compose.yaml
curl -fL https://raw.githubusercontent.com/chthollyphile/folia-major/main/deploy/docker/.env.example -o .env
sed -i "s/^SYNC_TOKEN=.*/SYNC_TOKEN=$(openssl rand -hex 32)/" .env
docker compose pull
docker compose up -d --wait
echo "已启动：Web 在 http://localhost:18080"

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://localhost:18080"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://localhost:18080" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://localhost:18080，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://localhost:18080 确认"
fi
echo "部署完成，浏览器访问 http://localhost:18080"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/chthollyphile/folia-major/blob/main/deploy/docker/README.md"
