# How-To-Signatures

This repository contains the source code for:

1. Generating signatures
2. Verifying signatures

## Prerequisite Knowledge

Basic understanding of:
- [foundry](https://book.getfoundry.sh/)
- [ethersjs](https://docs.ethers.org/v5/)

## Usage

The typical usage for signatures is to generate it off-chain and verify it on-chain. A good example of this is the `Permit()` function from [EIP2612](https://eips.ethereum.org/EIPS/eip-2612).