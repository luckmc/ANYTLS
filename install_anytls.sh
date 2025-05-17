#!/bin/bash

# 显示脚本执行步骤
echo "开始安装 anytls-server..."

# 第一步：下载 anytls
echo "步骤1: 下载 anytls..."
wget https://github.com/anytls/anytls-go/releases/download/v0.0.8/anytls_0.0.8_linux_amd64.zip
if [ $? -ne 0 ]; then
    echo "下载失败，请检查网络连接"
    exit 1
fi

# 第二步：解压文件
echo "步骤2: 解压文件..."
unzip anytls_0.0.8_linux_amd64.zip
if [ $? -ne 0 ]; then
    echo "解压失败，请确保unzip已安装"
    exit 1
fi

# 确保文件有执行权限
chmod +x anytls-server

# 第三步：生成随机密码（6位大小写字母）
echo "步骤3: 生成随机密码..."
PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 6 | head -n 1)

# 获取服务器IP地址
SERVER_IP=$(curl -s ifconfig.me)
if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(hostname -I | awk '{print $1}')
fi

# 运行服务器（后台运行）
echo "步骤4: 启动服务器..."
nohup ./anytls-server -l 0.0.0.0:8443 -p $PASSWORD > /dev/null 2>&1 &

# 等待服务器启动
sleep 2

# 检查服务器是否成功启动
if pgrep -x "anytls-server" > /dev/null; then
    echo "anytls-server 已成功启动！"
    echo "================================================"
    echo "服务器信息："
    echo "服务器IP:端口 $SERVER_IP:8443"
    echo "密码: $PASSWORD"
    echo "================================================"
else
    echo "服务器启动失败，请检查日志"
fi