//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MultiSig {
    string title;
    address[] public owners;
    uint256 public threshold;
    uint256 public transactionsCount;
    bool public autoExecute;
    struct Transaction {
        uint256 txId;
        bytes data;
        bool executed;
        address to;
        uint256 value;
        address[] approvals;
        address createdBy;
        uint createdAt;
        uint executedAt;
    }
    mapping(uint256 => Transaction) allTransactions;
    modifier onlyOwner() {
        require(isOwner(msg.sender), "You must be an Onwer");
        _;
    }
    modifier validTxId(uint256 _txId) {
        require(
            _txId > 0 && _txId <= transactionsCount,
            "Invalid Transaction Id"
        );
        _;
    }
    event TransactionCreated(uint256 indexed txId, address creator);
    event TransactionApproved(uint256 indexed txId, address approver);
    event TransactionExecuted(uint256 indexed txId);

    constructor(
        address[] memory _owners,
        uint256 _threshold,
        bool _autoExecute,
        string memory _title
    ) {
        require(
            _threshold > 0 && _threshold <= _owners.length,
            "Invalid threshold"
        );
        address[] memory uniqueOwners = new address[](_owners.length);
        for (uint256 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid address");
            for (uint256 j = 0; j < uniqueOwners.length; j++) {
                require(
                    _owners[i] != uniqueOwners[j],
                    "Duplicate address found"
                );
            }
            uniqueOwners[i] = _owners[i];
        }
        title = _title;
        owners = _owners;
        threshold = _threshold;
        autoExecute = _autoExecute;
    }

    function proposeTransaction(
        bytes memory _data,
        address _to,
        uint256 _value
    ) public onlyOwner {
        transactionsCount++;
        Transaction storage txn = allTransactions[transactionsCount];
        emit TransactionCreated(transactionsCount, msg.sender);
        txn.txId = transactionsCount;
        txn.data = _data;
        txn.to = _to;
        txn.value = _value;
        txn.executed = false;
        txn.createdBy = msg.sender;
        txn.createdAt = block.timestamp;
        txn.approvals.push(msg.sender);
        emit TransactionApproved(transactionsCount, msg.sender);
        if (thresholdMet(transactionsCount) && autoExecute) {
            executeTransaction(transactionsCount);
        }
    }

    function approveTransaction(
        uint256 _txId
    ) public onlyOwner validTxId(_txId) {
        Transaction storage txn = allTransactions[_txId];
        require(!txn.executed, "Transaction already executed");
        require(
            !isApproved(_txId, msg.sender),
            "You've already approved the transaction"
        );
        txn.approvals.push(msg.sender);
        emit TransactionApproved(_txId, msg.sender);
        if (thresholdMet(_txId) && autoExecute) {
            executeTransaction(_txId);
        }
    }

    function executeTransaction(
        uint256 _txId
    ) public onlyOwner validTxId(_txId) {
        require(thresholdMet(_txId), "Signature threshold not met");
        Transaction storage txn = allTransactions[_txId];
        require(!txn.executed, "Transaction already executed");
        txn.executed = true;
        txn.executedAt = block.timestamp;
        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        require(success, "Transaction execution failed");
        emit TransactionExecuted(_txId);
    }

    function updateAutoExecute() public onlyOwner {
        autoExecute = !autoExecute;
    }
    function updateThreshold(uint256 _threshold) public onlyOwner {
        
    }
    function isOwner(address addr) public view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function isApproved(
        uint256 _txId,
        address addr
    ) public view returns (bool) {
        Transaction storage txn = allTransactions[_txId];
        for (uint256 i = 0; i < txn.approvals.length; i++) {
            if (txn.approvals[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function thresholdMet(uint256 _txId) public view returns (bool) {
        Transaction storage txn = allTransactions[_txId];
        if (txn.approvals.length == threshold) {
            return true;
        }
        return false;
    }

    function getAutoExecute() public view returns (bool) {
        return autoExecute;
    }

    function getTransaction(
        uint256 _txId
    ) public view validTxId(_txId) returns (Transaction memory) {
        Transaction storage txn = allTransactions[_txId];
        return txn;
    }

    function getAllTransactions() public view returns (Transaction[] memory) {
        Transaction[] memory transactions = new Transaction[](
            transactionsCount
        );
        for (uint256 i = 1; i <= transactionsCount; i++) {
            transactions[i - 1] = allTransactions[i];
        }
        return transactions;
    }

    function getWalletName() public view returns (string memory) {
        return title;
    }

    function fetchWalletOwners() public view returns (address[] memory) {
        return owners;
    }

    function fetchThreshold() public view returns (uint256) {
        return threshold;
    }
    receive () external payable {
    }
}
