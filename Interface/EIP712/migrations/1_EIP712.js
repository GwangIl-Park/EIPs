var EIP712 = artifacts.require("./EIP712.sol");

module.exports = function(deployer) {
  deployer.deploy(EIP712);
};
