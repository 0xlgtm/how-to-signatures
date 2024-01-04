# How-To-Signatures

This repository contains the source code for:

1. Generating signatures
2. Verifying signatures

## Prerequisite Knowledge

Basic understanding of:
- [foundry](https://book.getfoundry.sh/)
- [ethersjs](https://docs.ethers.org/v5/)

## How It Works

The typical usage for signatures is to generate it off-chain and verify it on-chain. A good example of this is the `Permit()` function from [EIP2612](https://eips.ethereum.org/EIPS/eip-2612).

## Usage

- Source code for the offchain generation and verification of signatures can be found in [main.js](./main.js).
- Source code for the onchain generation and verification of signatures can be found in [main.t.sol](./src/main.t.sol).