#!/bin/bash

# SPDX-License-Identifier: UNLICENSED
# AlloyedBTCVault 部署和验证脚本

set -e

echo "=== AlloyedBTCVault 部署和验证脚本 ==="

# 检查是否设置了 Etherscan API Key
if [ -z "$ETHERSCAN_API_KEY" ]; then
    echo "错误: 请设置 ETHERSCAN_API_KEY 环境变量"
    echo "例如: export ETHERSCAN_API_KEY=your_api_key_here"
    exit 1
fi

# 检查是否设置了 RPC URL
if [ -z "$RPC_URL" ]; then
    echo "错误: 请设置 RPC_URL 环境变量"
    echo "例如: export RPC_URL=https://sepolia.infura.io/v3/your_project_id"
    exit 1
fi

# 检查是否设置了私钥
if [ -z "$PRIVATE_KEY" ]; then
    echo "错误: 请设置 PRIVATE_KEY 环境变量"
    echo "例如: export PRIVATE_KEY=your_private_key"
    exit 1
fi

echo "开始部署合约..."

# 部署合约并捕获输出
DEPLOY_OUTPUT=$(forge script script/AlloyedBTCVault.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast)

echo "部署输出:"
echo "$DEPLOY_OUTPUT"

# 从输出中提取合约地址
FBTC_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep "FBTC address:" | sed 's/.*FBTC address: //')
WBTC_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep "WBTC address:" | sed 's/.*WBTC address: //')
AlloyedBTCVaultForFBTC_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep "AlloyedBTCVaultForFBTC address:" | sed 's/.*AlloyedBTCVaultForFBTC address: //')
AlloyedBTCVaultForWBTC_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep "AlloyedBTCVaultForWBTC address:" | sed 's/.*AlloyedBTCVaultForWBTC address: //')
AlloyedBTCVault_ADDRESS=$(echo "$DEPLOY_OUTPUT" | grep "AlloyedBTCVault address:" | sed 's/.*AlloyedBTCVault address: //')

# 检查是否成功提取到地址
if [ -z "$FBTC_ADDRESS" ] || [ -z "$WBTC_ADDRESS" ] || [ -z "$AlloyedBTCVaultForFBTC_ADDRESS" ] || [ -z "$AlloyedBTCVaultForWBTC_ADDRESS" ] || [ -z "$AlloyedBTCVault_ADDRESS" ]; then
    echo "错误: 无法从部署输出中提取合约地址"
    echo "请检查部署是否成功"
    exit 1
fi

echo "=== 合约地址 ==="
echo "FBTC: $FBTC_ADDRESS"
echo "WBTC: $WBTC_ADDRESS"
echo "AlloyedBTCVaultForFBTC: $AlloyedBTCVaultForFBTC_ADDRESS"
echo "AlloyedBTCVaultForWBTC: $AlloyedBTCVaultForWBTC_ADDRESS"
echo "AlloyedBTCVault: $AlloyedBTCVault_ADDRESS"

echo ""
echo "开始验证合约..."

# 验证 FBTC 合约 (无构造函数参数)
echo "验证 FBTC 合约..."
forge verify-contract $FBTC_ADDRESS "src/FBTC.sol:FBTC" --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://explorer.sepolia.mantle.xyz/api? --watch || echo "FBTC 合约验证失败"

# 验证 WBTC 合约 (无构造函数参数)
echo "验证 WBTC 合约..."
forge verify-contract $WBTC_ADDRESS "src/WBTC.sol:WBTC" --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://explorer.sepolia.mantle.xyz/api? --watch || echo "WBTC 合约验证失败"

# 验证 AlloyedBTCVaultForFBTC 合约 (需要构造函数参数)
echo "验证 AlloyedBTCVaultForFBTC 合约..."
forge verify-contract $AlloyedBTCVaultForFBTC_ADDRESS "src/AlloyedBTCVaultForFBTC.sol:AlloyedBTCVaultForFBTC" \
    --constructor-args $(cast abi-encode "constructor(address,string,string)" $FBTC_ADDRESS "AlloyedBTCVaultForFBTC" "aFBTC") \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://explorer.sepolia.mantle.xyz/api? --watch || echo "AlloyedBTCVaultForFBTC 合约验证失败"

# 验证 AlloyedBTCVaultForWBTC 合约 (需要构造函数参数)
echo "验证 AlloyedBTCVaultForWBTC 合约..."
forge verify-contract $AlloyedBTCVaultForWBTC_ADDRESS "src/AlloyedBTCVaultForWBTC.sol:AlloyedBTCVaultForWBTC" \
    --constructor-args $(cast abi-encode "constructor(address,string,string)" $WBTC_ADDRESS "AlloyedBTCVaultForWBTC" "aWBTC") \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://explorer.sepolia.mantle.xyz/api? --watch || echo "AlloyedBTCVaultForWBTC 合约验证失败"

# 验证 AlloyedBTCVault 合约 (需要构造函数参数)
echo "验证 AlloyedBTCVault 合约..."
forge verify-contract $AlloyedBTCVault_ADDRESS "src/AlloyedBTCVault.sol:AlloyedBTCVault" \
    --constructor-args $(cast abi-encode "constructor(address,address)" $AlloyedBTCVaultForFBTC_ADDRESS $AlloyedBTCVaultForWBTC_ADDRESS) \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://explorer.sepolia.mantle.xyz/api? --watch || echo "AlloyedBTCVault 合约验证失败"

echo ""
echo "=== 部署和验证完成 ==="
echo "所有合约地址:"
echo "FBTC: $FBTC_ADDRESS"
echo "WBTC: $WBTC_ADDRESS"
echo "AlloyedBTCVaultForFBTC: $AlloyedBTCVaultForFBTC_ADDRESS"
echo "AlloyedBTCVaultForWBTC: $AlloyedBTCVaultForWBTC_ADDRESS"
echo "AlloyedBTCVault: $AlloyedBTCVault_ADDRESS"
