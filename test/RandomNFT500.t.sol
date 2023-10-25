// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {RandomNFT500} from "../src/RandomNFT500.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract HelperContract {
    string public _BlindBoxURI =
        "https://ipfs.io/ipfs/QmYwfhxyg8xo4MQ7PLFsBsK1nDiB4BHJyFvbn3trb6iw6q";
    string[] public _unboxedURIs = [
        "https://ipfs.io/ipfs/QmT3bPfYodTRdKgPDvZdWf15RvQvGgpzpCA97sXAUfTTZp",
        "https://ipfs.io/ipfs/QmRKqekmWyYB3sFbgJ8op1rS3wEoewkbkodhCVuFvBQVnd",
        "https://ipfs.io/ipfs/QmZ4vK3FHs7sFkgD3iBJPS88vdWFvigC595VxjKkwJBcgN"
    ];
}

contract RandomNFT500Test is Test, HelperContract {
    RandomNFT500 public rn5contract;
    address user;
    address user2;

    function setUp() public {
        user = makeAddr("user");
        user2 = makeAddr("user2");
        vm.label(user, "user");
        vm.label(user2, "user2");
        vm.startPrank(user);
        rn5contract = new RandomNFT500(_BlindBoxURI, _unboxedURIs);
        vm.stopPrank();
    }

    function testMintBlindBox() public {
        vm.startPrank(user);
        rn5contract.mintBlindBox(user);
        assertEq(rn5contract.getTokenURI(1), _BlindBoxURI);
        vm.stopPrank();
    }

    function testUnboxAll() public {
        vm.startPrank(user);
        rn5contract.mintBlindBox(user);
        rn5contract.unboxAll();
        console2.log("tokenURI: %s", rn5contract.getTokenURI(1));
    }
}
