// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ITest.sol";
import "./ERC165.sol";

abstract contract Test is ITest, ERC165{
  mapping (uint256=>bool) mTest;

  function supportsInterface(bytes4 interfaceId) public virtual override view returns (bool) {
    return super.supportsInterface(interfaceId) || interfaceId == type(ITest).interfaceId;
  }
  function fTest (uint256 aTest) public virtual override {
    mTest[aTest] = true;
  }

  function getfTestBytes4() public pure returns (bytes4) {
    return bytes4(keccak256("fTest(uint256)"));
  }
}