//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

// import contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// inherit contract
contract MyEpicNFT is ERC721URIStorage {
    //track tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoa!");
    }

    // give NFT
    function makeAnEpicNFT() public {
        // Get token ID from 0
        uint256 newItemId = _tokenIds.current();

        // Mint to sender
        _safeMint(msg.sender, newItemId);

        // Set NFT Data
        _setTokenURI(newItemId, "blah");

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // Increment how many NFTs are minted
        _tokenIds.increment();
    }
}
