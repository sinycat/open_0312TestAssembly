// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TesAssembly.sol";

contract MyWalletTest is Test {
    MyWallet public wallet;
    address public owner;
    address public alice;

    function setUp() public {
        // 设置测试账户
        owner = address(this);
        alice = makeAddr("alice");
        
        // 部署合约
        wallet = new MyWallet("TestWallet");
    }

    function testInitialState() public view {
        // 测试初始状态
        assertEq(wallet.name(), "TestWallet");
        assertEq(wallet.getOwner(), owner);
    }

    function testTransferOwnership() public {
        // 测试转移所有权
        wallet.transferOwernship(alice);
        assertEq(wallet.getOwner(), alice);
    }

    function testFailTransferOwnershipToZeroAddress() public {
        // 测试转移所有权到零地址（应该失败）
        wallet.transferOwernship(address(0));
    }

    function testFailTransferOwnershipToSameOwner() public {
        // 测试转移所有权到当前所有者（应该失败）
        wallet.transferOwernship(owner);
    }

    function testFailTransferOwnershipFromNonOwner() public {
        // 切换到 alice 账户
        vm.prank(alice);
        // 测试非所有者转移所有权（应该失败）
        wallet.transferOwernship(alice);
    }
}
