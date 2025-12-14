// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MyNFT is ERC721Enumerable {
    mapping(uint256 => string) internal _tokenURIs;
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mintNFT(address recipient, string memory _tokenURI) external {
        uint256 tokenId = totalSupply() + 1;
        _tokenURIs[tokenId] = _tokenURI;
        _safeMint(recipient, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);

        return _tokenURIs[tokenId];
    }
}