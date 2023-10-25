// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RandomNFT500 is ERC721, Ownable {
    uint256 public totalSupply;
    uint256 public mintedCount;

    // The initial blind box URI
    string public BlindBoxURI;

    // The URIs that NFTs can have after being unboxed
    string[] public unboxedURIs;

    // Mapping to store token URIs
    mapping(uint256 => string) private tokenURIs;


    constructor(
        string memory _BlindBoxURI,
        string[] memory _unboxedURIs
    ) ERC721("Alex's Doggy Random NFT", "ADRN") Ownable(msg.sender) {
        totalSupply = 500;
        mintedCount = 0;
        BlindBoxURI = _BlindBoxURI;
        unboxedURIs = _unboxedURIs;
    }

    function mintBlindBox(address to) public {
        require(mintedCount < totalSupply, "Maximum supply reached");
        uint256 tokenId = mintedCount + 1;
        _mint(to, tokenId);
        tokenURIs[tokenId] = BlindBoxURI; // 設定盲盒URI
        mintedCount++;
    }

    function unboxAll() public onlyOwner {
        for (uint256 tokenId = 1; tokenId <= totalSupply; tokenId++) {
            uint256 randomIndex = uint256(
                keccak256(abi.encodePacked(tokenId))
            ) % unboxedURIs.length;
            string memory newTokenURI = unboxedURIs[randomIndex];
            tokenURIs[tokenId] = newTokenURI; // 給定解盲後的URI
        }
    }

    // 查詢tokenID的tokenURI
    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURIs[tokenId];
    }
}
