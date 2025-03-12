// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyWallet { 
    string public name;
    mapping (address => bool) private approved;
    address public owner;

    // 修饰器：使用内联汇编检查调用者是否为 owner
    modifier auth {
        assembly {
            // 获取插槽 2 的值（即 owner 的地址）
            let ownerAddr := sload(2)
            // 获取 msg.sender
            let sender := caller()
            // 比较两者是否相等
            if iszero(eq(ownerAddr, sender)) {
                // 如果不相等，抛出错误（使用 revert）
                mstore(0x00, 0x08c379a0) // 错误签名 "Error(string)"
                mstore(0x04, 0x20)       // 字符串偏移
                mstore(0x24, 14)         // 字符串长度
                mstore(0x44, 0x4e6f7420617574686f72697a656400) // "Not authorized"
                revert(0x00, 0x64)       // 抛出错误
            }
        }
        _;
    }

    constructor(string memory _name) {
        name = _name;
        // 使用内联汇编设置 owner
        assembly {
            sstore(2, caller())
        }
    } 

    // 使用内联汇编设置新的 owner 地址
    function transferOwernship(address _addr) public auth {
        require(_addr != address(0), "New owner is the zero address");
        // 使用内联汇编获取当前 owner
        address currentOwner;
        assembly {
            currentOwner := sload(2)
        }
        require(currentOwner != _addr, "New owner is the same as the old owner");
        // 使用内联汇编设置新的 owner
        assembly {
            sstore(2, _addr)
        }
    }

    // 辅助函数：使用内联汇编获取 owner 地址（仅用于调试或外部调用）
    function getOwner() public view returns (address ownerAddr) {
        assembly {
            ownerAddr := sload(2)
        }
    }
}