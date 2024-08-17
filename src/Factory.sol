// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MultiSig} from "./MultiSig.sol";

contract Factory {
    struct Wallet {
        string title;
        address walletAddress;
        address[] owners;
        uint256 threshold;
    }
    uint256 public walletCount = 0;
    mapping(uint256 => Wallet) public Wallets;

    event WalletCreated(address indexed wallet, address[] owners);

    function createNewMultiSigWallet(
        string memory _title,
        address[] memory _owners,
        uint256 _threshold,
        bool _autoExecute
    ) public returns (address) {
        MultiSig multiSig = new MultiSig(_owners, _threshold, _autoExecute, _title);
        Wallet storage wallet = Wallets[walletCount];
        wallet.walletAddress = address(multiSig);
        wallet.owners = _owners;
        wallet.title = _title;
        wallet.threshold = _threshold;
        walletCount++;
        emit WalletCreated(address(multiSig), _owners);
        return address(multiSig);
    }

    function fetchWallets(
        address _address
    ) public view returns (Wallet[] memory) {
        uint256 count = 0;

        for (uint256 i = 0; i < walletCount; i++) {
            Wallet storage wallet = Wallets[i];
            for (uint256 j = 0; j < wallet.owners.length; j++) {
                if (wallet.owners[j] == _address) {
                    count++;
                    break;
                }
            }
        }

        Wallet[] memory wallets = new Wallet[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < walletCount; i++) {
            Wallet storage wallet = Wallets[i];
            for (uint256 j = 0; j < wallet.owners.length; j++) {
                if (wallet.owners[j] == _address) {
                    wallets[index] = wallet;
                    index++;
                    break;
                }
            }
        }
        return wallets;
    }
}
