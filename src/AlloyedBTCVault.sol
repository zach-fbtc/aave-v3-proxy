// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/extensions/ERC4626.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title AlloyedBTCVault
 * @dev 支持存储 aFBTC 和 aWBTC 代币的合约，并提供余额统计功能
 */
contract AlloyedBTCVault {
    using SafeERC20 for IERC20;

    // 金库合约地址
    address public immutable fbtcVault;
    address public immutable wbtcVault;

    // 存储的 aFBTC 和 aWBTC 代币余额
    mapping(address => uint256) public aFBTCBalances;
    mapping(address => uint256) public aWBTCBalances;

    // 事件
    event BalanceUpdated(
        address indexed user,
        uint256 fbtcBalance,
        uint256 wbtcBalance,
        uint256 totalBalance
    );

    event TokensDeposited(
        address indexed user,
        address indexed token,
        uint256 amount
    );

    event TokensWithdrawn(
        address indexed user,
        address indexed token,
        uint256 amount
    );

    constructor(address _fbtcVault, address _wbtcVault) {
        require(_fbtcVault != address(0), "FBTC vault address cannot be zero");
        require(_wbtcVault != address(0), "WBTC vault address cannot be zero");

        fbtcVault = _fbtcVault;
        wbtcVault = _wbtcVault;
    }

    /**
     * @dev 存入 aFBTC 代币
     * @param amount 存入数量
     */
    function depositAFBTC(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(fbtcVault).safeTransferFrom(msg.sender, address(this), amount);
        aFBTCBalances[msg.sender] += amount;

        emit TokensDeposited(msg.sender, fbtcVault, amount);
        emit BalanceUpdated(
            msg.sender,
            aFBTCBalances[msg.sender],
            aWBTCBalances[msg.sender],
            aFBTCBalances[msg.sender] + aWBTCBalances[msg.sender]
        );
    }

    /**
     * @dev 存入 aWBTC 代币
     * @param amount 存入数量
     */
    function depositAWBTC(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");

        IERC20(wbtcVault).safeTransferFrom(msg.sender, address(this), amount);
        aWBTCBalances[msg.sender] += amount;

        emit TokensDeposited(msg.sender, wbtcVault, amount);
        emit BalanceUpdated(
            msg.sender,
            aFBTCBalances[msg.sender],
            aWBTCBalances[msg.sender],
            aFBTCBalances[msg.sender] + aWBTCBalances[msg.sender]
        );
    }

    /**
     * @dev 取出 aFBTC 代币
     * @param amount 取出数量
     */
    function withdrawAFBTC(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(
            aFBTCBalances[msg.sender] >= amount,
            "Insufficient aFBTC balance"
        );

        aFBTCBalances[msg.sender] -= amount;
        IERC20(fbtcVault).safeTransfer(msg.sender, amount);

        emit TokensWithdrawn(msg.sender, fbtcVault, amount);
        emit BalanceUpdated(
            msg.sender,
            aFBTCBalances[msg.sender],
            aWBTCBalances[msg.sender],
            aFBTCBalances[msg.sender] + aWBTCBalances[msg.sender]
        );
    }

    /**
     * @dev 取出 aWBTC 代币
     * @param amount 取出数量
     */
    function withdrawAWBTC(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(
            aWBTCBalances[msg.sender] >= amount,
            "Insufficient aWBTC balance"
        );

        aWBTCBalances[msg.sender] -= amount;
        IERC20(wbtcVault).safeTransfer(msg.sender, amount);

        emit TokensWithdrawn(msg.sender, wbtcVault, amount);
        emit BalanceUpdated(
            msg.sender,
            aFBTCBalances[msg.sender],
            aWBTCBalances[msg.sender],
            aFBTCBalances[msg.sender] + aWBTCBalances[msg.sender]
        );
    }

    /**
     * @dev 获取指定地址在FBTC金库中的余额
     * @param user 用户地址
     * @return 用户在FBTC金库中的份额余额
     */
    function getVaultBalanceByAsset(
        address user,
        address asset
    ) public view returns (uint256) {
        return ERC4626(asset).balanceOf(user);
    }

    /**
     * @dev 获取指定地址的详细余额信息（包括存储在合约中的代币）
     * @param user 用户地址
     * @return BalanceInfo 包含用户地址、aFBTC余额、aWBTC余额和总余额的结构体
     */
    function getDetailedBalance(
        address user
    ) public view returns (BalanceInfo memory) {
        uint256 fbtcBalance = aFBTCBalances[user];
        uint256 wbtcBalance = aWBTCBalances[user];
        return
            BalanceInfo({
                user: user,
                fbtcBalance: fbtcBalance,
                wbtcBalance: wbtcBalance,
                totalBalance: fbtcBalance + wbtcBalance
            });
    }

    /**
     * @dev 获取用户在金库中的原始余额（不包括存储在合约中的代币）
     * @param user 用户地址
     * @return BalanceInfo 包含用户地址、FBTC金库余额、WBTC金库余额和总余额的结构体
     */
    function getVaultBalance(
        address user
    ) public view returns (BalanceInfo memory) {
        uint256 fbtcBalance = ERC4626(fbtcVault).balanceOf(user);
        uint256 wbtcBalance = ERC4626(wbtcVault).balanceOf(user);
        return
            BalanceInfo({
                user: user,
                fbtcBalance: fbtcBalance,
                wbtcBalance: wbtcBalance,
                totalBalance: fbtcBalance + wbtcBalance
            });
    }

    /**
     * @dev 获取用户的总余额（金库余额 + 存储在合约中的余额）
     * @param user 用户地址
     * @return BalanceInfo 包含用户地址、总aFBTC余额、总aWBTC余额和总余额的结构体
     */
    function getTotalBalance(
        address user
    ) public view returns (BalanceInfo memory) {
        uint256 vaultFBTCBalance = ERC4626(fbtcVault).balanceOf(user);
        uint256 vaultWBTCBalance = ERC4626(wbtcVault).balanceOf(user);
        uint256 storedFBTCBalance = aFBTCBalances[user];
        uint256 storedWBTCBalance = aWBTCBalances[user];

        uint256 totalFBTCBalance = vaultFBTCBalance + storedFBTCBalance;
        uint256 totalWBTCBalance = vaultWBTCBalance + storedWBTCBalance;

        return
            BalanceInfo({
                user: user,
                fbtcBalance: totalFBTCBalance,
                wbtcBalance: totalWBTCBalance,
                totalBalance: totalFBTCBalance + totalWBTCBalance
            });
    }

    /**
     * @dev 获取金库的底层资产余额（实际BTC价值）
     * @param user 用户地址
     * @return fbtcAssetBalance FBTC金库底层资产余额
     * @return wbtcAssetBalance WBTC金库底层资产余额
     * @return totalAssetBalance 总底层资产余额
     */
    function getAssetBalances(
        address user
    )
        public
        view
        returns (
            uint256 fbtcAssetBalance,
            uint256 wbtcAssetBalance,
            uint256 totalAssetBalance
        )
    {
        uint256 fbtcShares = ERC4626(fbtcVault).balanceOf(user);
        uint256 wbtcShares = ERC4626(wbtcVault).balanceOf(user);

        fbtcAssetBalance = ERC4626(fbtcVault).convertToAssets(fbtcShares);
        wbtcAssetBalance = ERC4626(wbtcVault).convertToAssets(wbtcShares);
        totalAssetBalance = fbtcAssetBalance + wbtcAssetBalance;
    }

    /**
     * @dev 获取金库合约地址
     * @return fbtcVaultAddress FBTC金库地址
     * @return wbtcVaultAddress WBTC金库地址
     */
    function getVaultAddresses()
        public
        view
        returns (address fbtcVaultAddress, address wbtcVaultAddress)
    {
        return (fbtcVault, wbtcVault);
    }

    /**
     * @dev 获取合约中存储的总代币数量
     * @return totalAFBTC 合约中存储的总 aFBTC 数量
     * @return totalAWBTC 合约中存储的总 aWBTC 数量
     */
    function getContractTotals()
        external
        view
        returns (uint256 totalAFBTC, uint256 totalAWBTC)
    {
        totalAFBTC = IERC20(fbtcVault).balanceOf(address(this));
        totalAWBTC = IERC20(wbtcVault).balanceOf(address(this));
    }

    /**
     * @dev 检查用户是否在合约中存储了代币
     * @param user 用户地址
     * @return 如果用户在合约中存储了代币则返回true
     */
    function hasStoredTokens(address user) external view returns (bool) {
        return aFBTCBalances[user] > 0 || aWBTCBalances[user] > 0;
    }

    /**
     * @dev 获取用户在合约中存储的代币数量
     * @param user 用户地址
     * @return aFBTCAmount 存储的 aFBTC 数量
     * @return aWBTCAmount 存储的 aWBTC 数量
     */
    function getStoredTokens(
        address user
    ) external view returns (uint256 aFBTCAmount, uint256 aWBTCAmount) {
        return (aFBTCBalances[user], aWBTCBalances[user]);
    }

    // 结构体：余额信息
    struct BalanceInfo {
        address user; // 用户地址
        uint256 fbtcBalance; // aFBTC 余额
        uint256 wbtcBalance; // aWBTC 余额
        uint256 totalBalance; // 总余额
    }
}
