# AlloyedBTCVault 合约使用指南

## 概述

`AlloyedBTCVault` 合约现在支持存储和管理 `aFBTC` 和 `aWBTC` 代币，提供完整的存款、取款和余额查询功能。

## 主要功能

### 1. 存款功能

- `depositAFBTC(uint256 amount)` - 存入 aFBTC 代币
- `depositAWBTC(uint256 amount)` - 存入 aWBTC 代币
- `depositBoth(uint256 aFBTCAmount, uint256 aWBTCAmount)` - 批量存入两种代币

### 2. 取款功能

- `withdrawAFBTC(uint256 amount)` - 取出 aFBTC 代币
- `withdrawAWBTC(uint256 amount)` - 取出 aWBTC 代币

### 3. 余额查询功能

- `getDetailedBalance(address user)` - 获取存储在合约中的代币余额
- `getVaultBalance(address user)` - 获取金库中的原始余额
- `getTotalBalance(address user)` - 获取总余额（金库 + 存储）
- `getStoredTokens(address user)` - 获取用户在合约中存储的代币数量
- `hasStoredTokens(address user)` - 检查用户是否存储了代币

### 4. 合约管理功能

- `getContractTotals()` - 获取合约中存储的总代币数量
- `getVaultAddresses()` - 获取金库合约地址

## 使用示例

### 存款操作

```solidity
// 存入 1000 aFBTC
alloyedBTCVault.depositAFBTC(1000 * 1e18);

// 存入 500 aWBTC
alloyedBTCVault.depositAWBTC(500 * 1e18);

// 批量存入
alloyedBTCVault.depositBoth(1000 * 1e18, 500 * 1e18);
```

### 取款操作

```solidity
// 取出 100 aFBTC
alloyedBTCVault.withdrawAFBTC(100 * 1e18);

// 取出 50 aWBTC
alloyedBTCVault.withdrawAWBTC(50 * 1e18);
```

### 余额查询

```solidity
// 获取存储在合约中的余额
AlloyedBTCVault.BalanceInfo memory storedBalance = alloyedBTCVault.getDetailedBalance(user);

// 获取金库中的原始余额
AlloyedBTCVault.BalanceInfo memory vaultBalance = alloyedBTCVault.getVaultBalance(user);

// 获取总余额
AlloyedBTCVault.BalanceInfo memory totalBalance = alloyedBTCVault.getTotalBalance(user);

// 检查是否存储了代币
bool hasStored = alloyedBTCVault.hasStoredTokens(user);
```

## 事件

### TokensDeposited

```solidity
event TokensDeposited(
    address indexed user,
    address indexed token,
    uint256 amount
);
```

### TokensWithdrawn

```solidity
event TokensWithdrawn(
    address indexed user,
    address indexed token,
    uint256 amount
);
```

### BalanceUpdated

```solidity
event BalanceUpdated(
    address indexed user,
    uint256 fbtcBalance,
    uint256 wbtcBalance,
    uint256 totalBalance
);
```

## 安全特性

1. **SafeERC20**: 使用 OpenZeppelin 的 SafeERC20 库进行安全的代币转账
2. **余额检查**: 取款前检查用户余额是否足够
3. **零金额检查**: 防止存入或取出零金额
4. **事件记录**: 所有操作都会触发相应事件

## 部署和测试

### 部署合约

```bash
# 设置环境变量
export ETHERSCAN_API_KEY="your_api_key"
export RPC_URL="https://rpc.mantle.xyz"
export PRIVATE_KEY="your_private_key"

# 部署合约
./deploy_and_verify.sh
```

### 测试合约

```bash
# 设置合约地址
export ALLOYED_BTC_VAULT_ADDRESS="0x..."

# 运行测试脚本
forge script script/AlloyedBTCVaultTest.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

## 注意事项

1. **授权**: 在存款前，需要先授权合约使用您的 aFBTC/aWBTC 代币
2. **Gas 费用**: 所有操作都需要支付 gas 费用
3. **余额管理**: 合约会准确跟踪每个用户的代币余额
4. **事件监听**: 建议监听相关事件来跟踪代币流动

## 合约地址

- **FBTC Vault**: `AlloyedBTCVaultForFBTC` 合约地址
- **WBTC Vault**: `AlloyedBTCVaultForWBTC` 合约地址
- **AlloyedBTCVault**: 主合约地址

通过这个合约，用户可以方便地管理他们的 aFBTC 和 aWBTC 代币，同时享受完整的余额统计功能。
