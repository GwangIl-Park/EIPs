// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
contract EIP712{
    struct EIP712Domain{
        string name;
        string version;
        uint256 chainId;
        address verifyingContract;
    }
    struct Person{
        string name;
        address wallet;
    }
    struct Mail{
        Person from;
        Person to;
        string contents;
    }
    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );
    bytes32 constant PERSON_TYPEHASH = keccak256(
        "Person(string name,address wallet)"
    );
    bytes32 constant MAIL_TYPEHASH = keccak256(
        "Mail(Person from,Person to,string contents)Person(string name,address wallet)"
    );
    bytes32 DOMAIN_SEPARATOR;

    constructor () public{
        DOMAIN_SEPARATOR = hash(EIP712Domain({
            name: "Ether Mail",
            version: '1',
            chainId: 1337,
            verifyingContract: address(this)
        }));
    }

    function hash(EIP712Domain memory eip712Domain) internal pure returns (bytes32) {
        return keccak256(abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(eip712Domain.name)),
            keccak256(bytes(eip712Domain.version)),
            eip712Domain.chainId,
            eip712Domain.verifyingContract
        ));
    }

    function hash(Person memory person) internal pure returns (bytes32) {
        return keccak256(abi.encode(
            PERSON_TYPEHASH,
            keccak256(bytes(person.name)),
            person.wallet
        ));
    }

    function hash(Mail memory mail) internal pure returns (bytes32) {
        return keccak256(abi.encode(
            MAIL_TYPEHASH,
            hash(mail.from),
            hash(mail.to),
            keccak256(bytes(mail.contents))
        ));
    }
    function recoverAddress(Mail memory mail, uint8 v, bytes32 r, bytes32 s) public view returns(address){
      bytes32 digest = keccak256(abi.encodePacked(
              "\x19\x01",
              DOMAIN_SEPARATOR,
              hash(mail)
          ));
      return ecrecover(digest, v, r, s);
    }
    function verify(Mail memory mail, uint8 v, bytes32 r, bytes32 s) public view returns(bool){
      return recoverAddress(mail, v, r, s) == mail.from.wallet;
    }
}