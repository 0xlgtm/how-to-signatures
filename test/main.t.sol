// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract MainTest is Test {

    address owner;
    uint256 pk = 77814517325470205911140941194401928579557062014761831930645393041380819009408;
    function setUp() public {
        owner = vm.addr(pk);
    }

    function test_signPersonalMessage() public {
        // 1. Generate your message
        string memory message = "hello world!";

        // 2. Hash the message
        // Alternatively, bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(abi.encode(message));
        bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(keccak256(abi.encode(message)));
        
        // 3. Sign the hash
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, messageHash);

        // 4a. Either verify with the signature
        bytes memory signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);
        address signer = ECDSA.recover(messageHash, signature);
        assertEq(signer, owner);

        // 4b. or verify with the individual v, r, s components
        signer = ECDSA.recover(messageHash, v, r, s);
        assertEq(signer, owner);
    }

    function test_signStructuredData() public {
        // 0x1901
        // 1. Generate the domain seperator
        bytes32 domainTypeHash =
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
        bytes32 domainSeperator = keccak256(
            abi.encode(
                domainTypeHash,
                keccak256("MyEtherMail"),
                keccak256("1"),
                1, // This is hardcoded to match the values used in main.js
                0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE // Same for this.
            )
        );

        // 2. Generate the structHash
        bytes32 mailTypeHash = keccak256("Mail(Person from,Person to,string contents)Person(string name,address wallet)");
        bytes32 personTypeHash = keccak256("Person(string name,address wallet)");
        bytes32 structHash = keccak256(abi.encode(
            mailTypeHash,
            // The nested struct need to be hashStructs as well
            keccak256(abi.encode(
                personTypeHash,
                keccak256("Me"),
                owner
            )),
            keccak256(abi.encode(
                personTypeHash,
                keccak256("Bob"),
                0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB
            )),
            keccak256("Hello, Bob!")
        ));

        // 3. Hash the message
        bytes32 messageHash = MessageHashUtils.toTypedDataHash(domainSeperator, structHash);

        // 3. Sign the hash
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, messageHash);

        // 4a. Either verify with the signature
        bytes memory signature = abi.encodePacked(r, s, v);
        assertEq(signature.length, 65);
        address signer = ECDSA.recover(messageHash, signature);
        assertEq(signer, owner);

        // 4b. or verify with the individual v, r, s components
        signer = ECDSA.recover(messageHash, v, r, s);
        assertEq(signer, owner);
    }

}
