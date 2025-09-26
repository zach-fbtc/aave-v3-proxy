# AlloyedBTCVault 部署和验证指南

## 概述

本项目提供了两种方式来部署和验证 AlloyedBTCVault 合约：

1. **简化版** (`deploy_and_verify_simple.sh`) - 使用 forge 内置验证功能
2. **完整版** (`deploy_and_verify.sh`) - 手动解析地址并验证

## 环境准备

### 1. 设置环境变量

```bash
# 必需的环境变量
export ETHERSCAN_API_KEY="your_etherscan_api_key"
export RPC_URL="https://sepolia.infura.io/v3/your_project_id"
export PRIVATE_KEY="your_private_key"

# 可选：设置链 ID
export CHAIN="sepolia"
```

### 2. 获取 Etherscan API Key

1. 访问 [Etherscan.io](https://etherscan.io/)
2. 注册账户并登录
3. 在 API Keys 页面创建新的 API Key

## 使用方法

### 方法一：简化版（推荐）

```bash
# 给脚本执行权限
chmod +x deploy_and_verify_simple.sh

# 运行部署和验证
./deploy_and_verify_simple.sh
```

### 方法二：完整版

```bash
# 给脚本执行权限
chmod +x deploy_and_verify.sh

# 运行部署和验证
./deploy_and_verify.sh
```

## 合约说明

### 部署的合约

1. **FBTC** - ERC20 代币合约
2. **WBTC** - ERC20 代币合约
3. **AlloyedBTCVaultForFBTC** - FBTC 的 ERC4626 金库
4. **AlloyedBTCVaultForWBTC** - WBTC 的 ERC4626 金库
5. **AlloyedBTCVault** - 余额统计合约

### 构造函数参数

- **FBTC/WBTC**: 无参数
- **AlloyedBTCVaultForFBTC**: `(FBTC地址, "AlloyedBTCVaultForFBTC", "aFBTC")`
- **AlloyedBTCVaultForWBTC**: `(WBTC地址, "AlloyedBTCVaultForWBTC", "aWBTC")`
- **AlloyedBTCVault**: `(AlloyedBTCVaultForFBTC地址, AlloyedBTCVaultForWBTC地址)`

## 故障排除

### 常见错误

1. **"请设置 ETHERSCAN_API_KEY 环境变量"**

   - 确保已正确设置 Etherscan API Key

2. **"请设置 ETH_RPC_URL 环境变量"**

   - 确保已设置正确的 RPC URL

3. **"请设置 PRIVATE_KEY 环境变量"**

   - 确保已设置私钥（不要包含 0x 前缀）

4. **验证失败**
   - 检查网络连接
   - 确认 API Key 有效
   - 等待几分钟后重试

### 手动验证命令

如果自动验证失败，可以使用以下命令手动验证：

```bash
# 对于 Mantle 网络
# 验证 FBTC
forge verify-contract <FBTC_ADDRESS> "src/FBTC.sol:FBTC" --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.mantlescan.xyz/v2/api

# 验证 WBTC
forge verify-contract <WBTC_ADDRESS> "src/WBTC.sol:WBTC" --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.mantlescan.xyz/v2/api

# 验证 AlloyedBTCVaultForFBTC
forge verify-contract <AlloyedBTCVaultForFBTC_ADDRESS> "src/AlloyedBTCVaultForFBTC.sol:AlloyedBTCVaultForFBTC" \
    --constructor-args $(cast abi-encode "constructor(address,string,string)" <FBTC_ADDRESS> "AlloyedBTCVaultForFBTC" "aFBTC") \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.mantlescan.xyz/v2/api

# 验证 AlloyedBTCVaultForWBTC
forge verify-contract <AlloyedBTCVaultForWBTC_ADDRESS> "src/AlloyedBTCVaultForWBTC.sol:AlloyedBTCVaultForWBTC" \
    --constructor-args $(cast abi-encode "constructor(address,string,string)" <WBTC_ADDRESS> "AlloyedBTCVaultForWBTC" "aWBTC") \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.mantlescan.xyz/v2/api

# 验证 AlloyedBTCVault
forge verify-contract <AlloyedBTCVault_ADDRESS> "src/AlloyedBTCVault.sol:AlloyedBTCVault" \
    --constructor-args $(cast abi-encode "constructor(address,address)" <AlloyedBTCVaultForFBTC_ADDRESS> <AlloyedBTCVaultForWBTC_ADDRESS>) \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.mantlescan.xyz/v2/api

# 对于 Ethereum 网络（Sepolia/Mainnet）
# 验证 FBTC
forge verify-contract <FBTC_ADDRESS> "src/FBTC.sol:FBTC" --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.etherscan.io/v2/api

# 验证 WBTC
forge verify-contract <WBTC_ADDRESS> "src/WBTC.sol:WBTC" --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.etherscan.io/v2/api

# 验证 AlloyedBTCVaultForFBTC
forge verify-contract <AlloyedBTCVaultForFBTC_ADDRESS> "src/AlloyedBTCVaultForFBTC.sol:AlloyedBTCVaultForFBTC" \
    --constructor-args $(cast abi-encode "constructor(address,string,string)" <FBTC_ADDRESS> "AlloyedBTCVaultForFBTC" "aFBTC") \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.etherscan.io/v2/api

# 验证 AlloyedBTCVaultForWBTC
forge verify-contract <AlloyedBTCVaultForWBTC_ADDRESS> "src/AlloyedBTCVaultForWBTC.sol:AlloyedBTCVaultForWBTC" \
    --constructor-args $(cast abi-encode "constructor(address,string,string)" <WBTC_ADDRESS> "AlloyedBTCVaultForWBTC" "aWBTC") \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.etherscan.io/v2/api

# 验证 AlloyedBTCVault
forge verify-contract <AlloyedBTCVault_ADDRESS> "src/AlloyedBTCVault.sol:AlloyedBTCVault" \
    --constructor-args $(cast abi-encode "constructor(address,address)" <AlloyedBTCVaultForFBTC_ADDRESS> <AlloyedBTCVaultForWBTC_ADDRESS>) \
    --verifier-api-key $ETHERSCAN_API_KEY --verifier-url https://api.etherscan.io/v2/api
```

## 注意事项

- 确保账户有足够的 ETH 支付 gas 费用
- 验证过程可能需要几分钟时间
- 建议在测试网络上先测试
- 私钥安全：不要在代码中硬编码私钥
