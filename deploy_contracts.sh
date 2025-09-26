#!/bin/bash

# SPDX-License-Identifier: UNLICENSED
# AlloyedBTCVault 合约验证脚本

set -e

echo "=== AlloyedBTCVault 合约验证脚本 ==="

# 检查是否设置了 Etherscan API Key
if [ -z "$ETHERSCAN_API_KEY" ]; then
    echo "错误: 请设置 ETHERSCAN_API_KEY 环境变量"
    echo "例如: export ETHERSCAN_API_KEY=your_api_key_here"
    exit 1
fi

# 检查是否提供了合约地址
if [ $# -eq 0 ]; then
    echo "用法: $0 <FBTC_ADDRESS> <WBTC_ADDRESS> <AlloyedBTCVaultForFBTC_ADDRESS> <AlloyedBTCVaultForWBTC_ADDRESS> <AlloyedBTCVault_ADDRESS>"
    echo "或者运行部署脚本后使用输出的地址"
    exit 1
fi

# 获取合约地址
FBTC_ADDRESS=$1
WBTC_ADDRESS=$2
AlloyedBTCVaultForFBTC_ADDRESS=$3
AlloyedBTCVaultForWBTC_ADDRESS=$4
AlloyedBTCVault_ADDRESS=$5

echo "开始验证合约..."

# 验证 FBTC 合约
echo "验证 FBTC 合约..."
forge verify-contract $FBTC_ADDRESS "src/FBTC.sol:FBTC" --etherscan-api-key $ETHERSCAN_API_KEY --watch || echo "FBTC 合约验证失败"

# 验证 WBTC 合约
echo "验证 WBTC 合约..."
forge verify-contract $WBTC_ADDRESS "src/WBTC.sol:WBTC" --etherscan-api-key $ETHERSCAN_API_KEY --watch || echo "WBTC 合约验证失败"

# 验证 AlloyedBTCVaultForFBTC 合约
echo "验证 AlloyedBTCVaultForFBTC 合约..."
forge verify-contract $AlloyedBTCVaultForFBTC_ADDRESS "src/AlloyedBTCVaultForFBTC.sol:AlloyedBTCVaultForFBTC" --etherscan-api-key $ETHERSCAN_API_KEY --watch || echo "AlloyedBTCVaultForFBTC 合约验证失败"

# 验证 AlloyedBTCVaultForWBTC 合约
echo "验证 AlloyedBTCVaultForWBTC 合约..."
forge verify-contract $AlloyedBTCVaultForWBTC_ADDRESS "src/AlloyedBTCVaultForWBTC.sol:AlloyedBTCVaultForWBTC" --etherscan-api-key $ETHERSCAN_API_KEY --watch || echo "AlloyedBTCVaultForWBTC 合约验证失败"

# 验证 AlloyedBTCVault 合约
echo "验证 AlloyedBTCVault 合约..."
forge verify-contract $AlloyedBTCVault_ADDRESS "src/AlloyedBTCVault.sol:AlloyedBTCVault" --etherscan-api-key $ETHERSCAN_API_KEY --watch || echo "AlloyedBTCVault 合约验证失败"

echo "=== 合约验证完成 ==="
