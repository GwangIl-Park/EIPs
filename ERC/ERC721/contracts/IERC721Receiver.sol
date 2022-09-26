// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC721Receiver {
  function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) external returns(bytes4);
}