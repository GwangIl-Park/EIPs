// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC721Enumerable {
    function totalSupply() external returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external returns (uint256);

    function tokenByIndex(uint256 index) external returns (uint256);
}