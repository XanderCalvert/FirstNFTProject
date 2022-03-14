//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

// import contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";

// inherit contract
contract MyEpicNFT is ERC721URIStorage {
    //track tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Guess ",
        "Manufacture ",
        "Cucumber ",
        "Cane ",
        "Auction ",
        "Deserve ",
        "Rate ",
        "Casualty ",
        "Head ",
        "Comprehensive ",
        "Humor ",
        "Nerve ",
        "Orange ",
        "Clarify ",
        "Scatter ",
        "Mud ",
        "Minority ",
        "Rob ",
        "Wheat ",
        "Carrot ",
        "Prejudice ",
        "Oppose ",
        "Anniversary ",
        "Rebel ",
        "Chapter ",
        "Honest ",
        "Allow ",
        "Circle ",
        "Deviation ",
        "Offer "
    ];
    string[] secondWords = [
        "Superintendent ",
        "Chimney ",
        "System ",
        "Leash ",
        "Premium ",
        "Assumption ",
        "Damn ",
        "Convince ",
        "Development ",
        "Exempt ",
        "Conclusion ",
        "Elect ",
        "Sit ",
        "Lobby ",
        "Apple ",
        "Budget ",
        "Banquet ",
        "Qualified ",
        "Lend ",
        "Amuse ",
        "Lot ",
        "Rehabilitation ",
        "Flat ",
        "Complication ",
        "Tolerate ",
        "Scratch ",
        "Touch ",
        "Yearn ",
        "Departure ",
        "Cooperation "
    ];
    string[] thirdWords = [
        "Fresh",
        "Watch",
        "Host",
        "Gaffe",
        "Rough",
        "jest",
        "Trap",
        "Scenario",
        "Element",
        "Clique",
        "Advertise",
        "Ethnic",
        "Entry",
        "Wonder",
        "Snack",
        "Conflict",
        "Sweater",
        "Reliance",
        "Track",
        "Ground",
        "Criticism",
        "Arrest",
        "Spite",
        "Migration",
        "Splurge",
        "Beer",
        "Helicopter",
        "Connection",
        "Indication",
        "Report"
    ];

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoa that is pretty cool!");
    }

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // give NFT
    function makeAnEpicNFT() public {
        // Get token ID from 0
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, first, second, third, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        // Mint to sender
        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        // // Set NFT Data
        // _setTokenURI(
        //     newItemId,
        //     "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0TkNpQWdJQ0E4YzNSNWJHVStMbUpoYzJVZ2V5Qm1hV3hzT2lCM2FHbDBaVHNnWm05dWRDMW1ZVzFwYkhrNklITmxjbWxtT3lCbWIyNTBMWE5wZW1VNklERTBjSGc3SUgwOEwzTjBlV3hsUGcwS0lDQWdJRHh5WldOMElIZHBaSFJvUFNJeE1EQWxJaUJvWldsbmFIUTlJakV3TUNVaUlHWnBiR3c5SW1Kc1lXTnJJaUF2UGcwS0lDQWdJRHgwWlhoMElIZzlJalV3SlNJZ2VUMGlOVEFsSWlCamJHRnpjejBpWW1GelpTSWdaRzl0YVc1aGJuUXRZbUZ6Wld4cGJtVTlJbTFwWkdSc1pTSWdkR1Y0ZEMxaGJtTm9iM0k5SW0xcFpHUnNaU0krUlhCcFkweHZjbVJJWVcxaWRYSm5aWEk4TDNSbGVIUStEUW84TDNOMlp6ND0iCn0="
        // );

        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // Increment how many NFTs are minted
        _tokenIds.increment();
    }
}
