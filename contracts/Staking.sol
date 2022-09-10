// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Staking {
    address owner;

    //mapping of tokens allowed to be deposited on this contract
    //bytes32 -> symbol of the token
    //address -> address of the token contract
    mapping(bytes32 => address) public allowedListTokens;

    //it checks how much token has been deposited from each wallet using this contract
    mapping(address => mapping(bytes32 => uint256)) public accountBalances;

    constructor() {
        owner = msg.sender;
    }

    //it allows a token to the contract
    function allowedListToken(bytes32 symbol, address tokenAddress) external {
        require(msg.sender == owner, "This function is not public");

        allowedListTokens[symbol] = tokenAddress;
    }

    //it deposits tokens to the contract
    function depositTokens(uint256 amount, bytes32 symbol) external {
        accountBalances[msg.sender][symbol] += amount;
        ERC20(allowedListTokens[symbol]).transferFrom(
            msg.sender,
            address(this),
            amount
        );
    }

    function withdrawTokens(uint256 amount, bytes32 symbol) external {
        require(
            accountBalances[msg.sender][symbol] >= amount,
            "Insufficent funds"
        );

        accountBalances[msg.sender][symbol] -= amount;
        ERC20(allowedListTokens[symbol]).transfer(msg.sender, amount);
    }
}
