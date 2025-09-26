// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FBTC} from "../src/FBTC.sol";
import {WBTC} from "../src/WBTC.sol";
import {AlloyedBTCVaultForFBTC} from "../src/AlloyedBTCVaultForFBTC.sol";
import {AlloyedBTCVaultForWBTC} from "../src/AlloyedBTCVaultForWBTC.sol";
import {AlloyedBTCVault} from "../src/AlloyedBTCVault.sol";
import {console2} from "forge-std/console2.sol";

contract AlloyedBTCVaultScript is Script {
    FBTC public fbtc;
    WBTC public wbtc;
    AlloyedBTCVaultForFBTC public alloyedBTCVaultForFBTC;
    AlloyedBTCVaultForWBTC public alloyedBTCVaultForWBTC;
    AlloyedBTCVault public alloyedBTCVault;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        fbtc = new FBTC();
        wbtc = new WBTC();
        alloyedBTCVaultForFBTC = new AlloyedBTCVaultForFBTC(
            fbtc,
            "AlloyedBTCVaultForFBTC",
            "aFBTC"
        );
        alloyedBTCVaultForWBTC = new AlloyedBTCVaultForWBTC(
            wbtc,
            "AlloyedBTCVaultForWBTC",
            "aWBTC"
        );
        alloyedBTCVault = new AlloyedBTCVault(
            address(alloyedBTCVaultForFBTC),
            address(alloyedBTCVaultForWBTC)
        );

        console2.log("fbtc", address(fbtc));
        console2.log("wbtc", address(wbtc));
        console2.log("alloyedBTCVaultForFBTC", address(alloyedBTCVaultForFBTC));
        console2.log("alloyedBTCVaultForWBTC", address(alloyedBTCVaultForWBTC));
        console2.log("alloyedBTCVault", address(alloyedBTCVault));

        vm.stopBroadcast();
    }
}
