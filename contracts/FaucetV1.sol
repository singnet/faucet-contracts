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
    address payable public contractOwner;
    IERC20 public fetToken;
    IERC20 public rejuveToken;

    uint256 public fetWithdrawalAmount = 50 * (10**18);
    uint256 public rejuveWithdrawalAmount = 50 * (10**6);
    uint256 public lockTime = 1 hours;

    event Distribution(address indexed to, uint256 indexed amount);
    event Withdrawal(address indexed to, uint256 indexed amount);

    mapping(address => uint256) public nextAccessTime;

    constructor(address _fetTokenAddress, address _rejuveTokenAddress) {
        fetToken = IERC20(_fetTokenAddress);
        rejuveToken = IERC20(_rejuveTokenAddress);
    }

    /**
     * @dev `tokenId` for identify token for send.
     *
     * `0` - FetchAI Token
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
            fetToken.balanceOf(address(this)) >= fetWithdrawalAmount ||
            rejuveToken.balanceOf(address(this)) >= rejuveWithdrawalAmount,
            "Insufficient balance in faucet for withdrawal request"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdrawal - try again later."
        );

        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        if (_tokenId == 0) {
            fetToken.transfer(msg.sender, fetWithdrawalAmount);
            emit Distribution(msg.sender, fetWithdrawalAmount);
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
        fetWithdrawalAmount = amount * (10**18);
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
        fetToken.transfer(msg.sender, fetToken.balanceOf(address(this)));
        rejuveToken.transfer(msg.sender,  rejuveToken.balanceOf(address(this)));

        emit Withdrawal(msg.sender, fetToken.balanceOf(address(this)));
        emit Withdrawal(msg.sender, rejuveToken.balanceOf(address(this)));
    }

    /**
     * GETTERS
     * @dev Get the remaining balance of tokens.
     * 
     */
    function getBalance() external view returns (uint256 fetBalance, uint256 rejuveBalance) {
        uint256 _fetBalance = fetToken.balanceOf(address(this));
        uint256 _rejuveBalance = rejuveToken.balanceOf(address(this));

        return (_fetBalance, _rejuveBalance);
    }
}