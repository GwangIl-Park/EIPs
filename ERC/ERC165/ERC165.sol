// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IERC165.sol";

contract ERC165 is IERC165 {
  function supportsInterface(bytes4 interfaceId) public virtual override view returns (bool){
    return (interfaceId == type(IERC165).interfaceId);
  }
}