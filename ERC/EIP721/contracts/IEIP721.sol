// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IEIP721 {
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);
    event ApprovalForAll(address owner, address operator, bool approved);

    function balanceOf(address owner) external returns(uint256);

    function ownerOf(uint256 tokenId) external returns(address);

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) external;

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function setApprovalForAll(address operator, bool _approved) external;

    function getApproved(uint256 tokenId) external returns(address);

    function isApprovedForAll(address owner, address operator) external returns(bool);
}