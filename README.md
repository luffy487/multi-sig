# MultiSig & Factory Smart Contracts

## Overview

This repository includes two Solidity smart contracts: `MultiSig` and `Factory`. These contracts create a multi-signature wallet system on the Ethereum blockchain, allowing multiple owners to manage and approve transactions together. The `Factory` contract makes it easy to create and track multiple `MultiSig` wallets.

## Contracts

### MultiSig Contract

The `MultiSig` contract lets a group of owners manage a shared wallet. To execute a transaction, it needs approval from a minimum number of owners (threshold). This ensures that no single owner can control the wallet on their own.

### Factory Contract

The `Factory` contract helps create new `MultiSig` wallets. It keeps a record of all wallets created and allows users to fetch wallets based on ownership.

## Key Features

### MultiSig Contract

- **Multiple Owners**: The wallet can have multiple owners, all with the power to propose and approve transactions.
- **Threshold Approval**: Transactions can only be executed if enough owners approve them.
- **Auto-Execution**: Transactions can be set to execute automatically once the approval threshold is met.

### Factory Contract

- **Wallet Creation**: Easily create new `MultiSig` wallets with custom settings.
- **Wallet Tracking**: Keep track of all wallets created, and fetch them based on ownership.

## Technologies Used

### Solidity

- **[Solidity](https://soliditylang.org/)** is the programming language used to write the `MultiSig` and `Factory` smart contracts. It is the standard language for developing smart contracts on the Ethereum blockchain.

### Foundry

- **[Foundry](https://book.getfoundry.sh/)** is the development framework used for compiling, testing, and deploying the Solidity contracts. Foundry provides a robust environment for building and managing Ethereum projects efficiently.

## How to Deploy

1. **Install Foundry**: Follow the [Foundry installation guide](https://book.getfoundry.sh/getting-started/installation.html) to set up Foundry on your machine.

2. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
