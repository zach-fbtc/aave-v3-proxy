#!/bin/bash

# SPDX-License-Identifier: UNLICENSED
# API Key 检查和获取脚本

echo "=== API Key 检查和获取脚本 ==="

# 检查当前 API Key
if [ -z "$ETHERSCAN_API_KEY" ]; then
    echo "❌ 未设置 ETHERSCAN_API_KEY 环境变量"
else
    echo "✅ ETHERSCAN_API_KEY 已设置: ${ETHERSCAN_API_KEY:0:8}..."
fi

# 检查 RPC URL
if [ -z "$RPC_URL" ]; then
    echo "❌ 未设置 RPC_URL 环境变量"
else
    echo "✅ RPC_URL 已设置: $RPC_URL"
fi

echo ""
echo "=== 获取 API Key 指南 ==="

# 检测网络类型
if [[ "$RPC_URL" == *"mantle"* ]]; then
    echo "🌐 检测到 Mantle 网络"
    echo ""
    echo "📋 获取 Mantlescan API Key:"
    echo "1. 访问 https://mantlescan.xyz/"
    echo "2. 点击右上角 'Sign In' 登录"
    echo "3. 登录后，点击右上角头像，选择 'API Keys'"
    echo "4. 点击 'Create New API Key'"
    echo "5. 输入名称（如：team701-deploy）"
    echo "6. 复制生成的 API Key"
    echo ""
    echo "🔧 设置环境变量:"
    echo "export ETHERSCAN_API_KEY=\"your_mantlescan_api_key_here\""
    echo "export RPC_URL=\"https://rpc.mantle.xyz\""
    echo ""
    echo "🧪 测试 API Key:"
    echo "curl \"https://api.mantlescan.xyz/v2/api?module=account&action=balance&address=0x0000000000000000000000000000000000000000&tag=latest&apikey=\$ETHERSCAN_API_KEY\""
    
elif [[ "$RPC_URL" == *"sepolia"* ]] || [[ "$RPC_URL" == *"mainnet"* ]]; then
    echo "🌐 检测到 Ethereum 网络"
    echo ""
    echo "📋 获取 Etherscan API Key:"
    echo "1. 访问 https://etherscan.io/"
    echo "2. 点击右上角 'Sign In' 登录"
    echo "3. 登录后，点击右上角头像，选择 'API Keys'"
    echo "4. 点击 'Add' 创建新的 API Key"
    echo "5. 输入名称（如：team701-deploy）"
    echo "6. 复制生成的 API Key"
    echo ""
    echo "🔧 设置环境变量:"
    echo "export ETHERSCAN_API_KEY=\"your_etherscan_api_key_here\""
    echo "export RPC_URL=\"https://sepolia.infura.io/v3/your_project_id\""
    echo ""
    echo "🧪 测试 API Key:"
    echo "curl \"https://api.etherscan.io/api?module=account&action=balance&address=0x0000000000000000000000000000000000000000&tag=latest&apikey=\$ETHERSCAN_API_KEY\""
    
else
    echo "❓ 无法识别网络类型"
    echo "请确保 RPC_URL 包含网络标识符（如 mantle, sepolia, mainnet）"
fi

echo ""
echo "=== 常见问题解决 ==="
echo "1. API Key 无效: 确保从正确的浏览器获取 API Key"
echo "2. 网络错误: 检查网络连接和 RPC URL"
echo "3. 权限问题: 确保 API Key 有足够的权限"
echo ""
echo "💡 提示: 如果问题持续，请尝试重新生成 API Key"
