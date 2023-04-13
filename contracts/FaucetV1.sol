// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
  * @dev Faucet smart contract V1.
  *
  * For deposit token - send tokens to contract address
  *
  */
contract FaucetV1 is Ownable {
    address payable contractOwner;
    IERC20 public agixToken;
    IERC20 public rejuveToken;

    uint256 public agixWithdrawalAmount = 50 * (10**8);
    uint256 public rejuveWithdrawalAmount = 50 * (10**6);
    uint256 public lockTime = 1 hours;

    event Distribution(address indexed to, uint256 indexed amount);
    event Withdrawal(address indexed to, uint256 indexed amount);

    mapping(address => uint256) nextAccessTime;

    constructor(address _agixTokenAddress, address _rejuveTokenAddress) payable {
        agixToken = IERC20(_agixTokenAddress);
        rejuveToken = IERC20(_rejuveTokenAddress);
        contractOwner = payable(msg.sender);
    }

    /**
     * @dev `tokenId` for identify token for send.
     *
     * `0` - SingularityNet Token
     * `1` - Rejuve Token
     * 
     */
    function requestTokens(uint8 _tokenId) public {
        require(
            _tokenId == 0 || _tokenId == 1,
            "Incorrect tokenId for token grant request"
        );
        require(
            msg.sender != address(0),
            "Request must not originate from a zero account"
        );
        require(
            agixToken.balanceOf(address(this)) >= agixWithdrawalAmount ||
            rejuveToken.balanceOf(address(this)) >= rejuveWithdrawalAmount,
            "Insufficient balance in faucet for withdrawal request"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdrawal - try again later."
        );

        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        if (_tokenId == 0) {
            agixToken.transfer(msg.sender, agixWithdrawalAmount);
            emit Distribution(msg.sender, agixWithdrawalAmount);
        } else {
            rejuveToken.transfer(msg.sender, rejuveWithdrawalAmount);
            emit Distribution(msg.sender, rejuveWithdrawalAmount);
        }
    }

    /**
     * @dev Setting Withdrawal Amount.
     * 
     * `amount` amount of withdrawal tokens.
     * 
     */
    function setWithdrawalAmount(uint256 amount) public onlyOwner {
        agixWithdrawalAmount = amount * (10**8);
        rejuveWithdrawalAmount = amount * (10**6);
    }

    /**
     * @dev Setting the cooling time.
     * 
     */
    function setLockTime(uint256 amount) public onlyOwner {
        lockTime = amount * 1 hours;
    }

    /**
     * @dev Withdraw all tokens from contract.
     * 
     */
    function withdraw() external onlyOwner {
        agixToken.transfer(msg.sender, agixToken.balanceOf(address(this)));
        rejuveToken.transfer(msg.sender,  rejuveToken.balanceOf(address(this)));

        emit Withdrawal(msg.sender, agixToken.balanceOf(address(this)));
        emit Withdrawal(msg.sender, rejuveToken.balanceOf(address(this)));
    }

    /**
     * GETTERS
     * @dev Get the remaining balance of tokens.
     * 
     */
    function getBalance() external view returns (uint256 agixBalance, uint256 rejuveBalance) {
        uint256 _agixBalance = agixToken.balanceOf(address(this));
        uint256 _rejuveBalance = rejuveToken.balanceOf(address(this));

        return (_agixBalance, _rejuveBalance);
    }
}