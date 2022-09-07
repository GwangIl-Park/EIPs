// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./IEIP721.sol";
import "./IEIP721Metadata.sol";

contract EIP721 is IEIP721, IEIP721Metadata {
    string _name;
    string _symbol;

    mapping (address=>uint256) balances;
    mapping (uint256=>address) owners;
    mapping (uint256=>string) uris;
    mapping (uint256=>address) approval;
    mapping(address => mapping(address => bool)) private operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function balanceOf(address owner) public virtual override returns(uint256) {
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public virtual override returns(address) {
        return owners[tokenId];
    }

    function name() public virtual override returns(string memory) {
        return _name;
    }

    function symbol() public virtual override returns(string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public virtual override returns(string memory) {
        return uris[tokenId];
    }

    function _baseURI() internal virtual returns(string memory) {
        return "";
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(owner!=address(0));
        require(owner == msg.sender || isApprovedForAll(owner, msg.sender) == true);
        approval[tokenId] = to;
        Approval(msg.sender, to, tokenId);
    }

    function getApproved(uint256 tokenId) public virtual override returns(address) {
        require(ownerOf(tokenId)!=address(0));
        return approval[tokenId];
    }

    function setApprovalForAll(address operator, bool _approved) public virtual override {
        require(operator!=msg.sender);
        operatorApprovals[msg.sender][operator] = _approved;
    }

    function isApprovedForAll(address owner, address operator) public virtual override returns(bool) {
        return operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(from != address(0));
        require(to!=address(0));
        require(ownerOf(tokenId)==from);
        require(_isApprovedOrOwner(msg.sender, tokenId));
        _transfer(from, to, tokenId);
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {

    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal {

    }

    function _exists(uint256 tokenId) internal returns(bool) {
        return (ownerOf(tokenId)==address(0));
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal returns(bool) {
        address owner = ownerOf(tokenId);
        return (ownerOf(tokenId)==spender || getApproved(tokenId)==spender || isApprovedForAll(ownerOf(tokenId), spender));
    }

    function _safeMint(address to, uint256 tokenId) internal {

    }

    function __safeMint(address to, uint256 tokenId, bytes memory data) internal {

    }

    function _mint(address to, uint256 tokenId) virtual internal {
        require(_exists(tokenId)==false);
        require(to!=(address(0)));
        unchecked {
            balances[to]++;
        }
        owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal {
        require(_exists(tokendId)==true);
        unchecked {
            balances[ownerOf(tokenId)]--;
        }
        delete owners[tokenId];
        emit Transfer(ownerOf(tokenId), address(0), tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        require(to!=address(0));
        require(ownerOf(tokenId)==from);
        owners[tokenId] = to;
        delete approval[tokenId];
        unchecked {
            balances[from]--;
            balances[to]++;
        }
        Transfer(from, to, tokenId);
    }

    function _approve(address to, uint256 tokneId) internal {

    }

    function _setApprovalForAll(address owner, address operator, bool approved) internal {

    }

    function _requireMinted(uint256 tokenId) internal {

    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal {

    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId) internal {

    }
}