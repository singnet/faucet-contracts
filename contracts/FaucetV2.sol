// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract FaucetV2 is Ownable, ReentrancyGuard {
    address contractOwner;
    uint256 public agixMaxSupply;
    uint256 public rejuveMaxSupply;

    IERC20 public agixToken;
    IERC20 public rejuveToken;

    /**
     * @dev Сhangeable amount for mint.
     *
     * Default: 50 tokens
     *  
     */
    uint256 public agixWithdrawalAmount = 50 * (10**8);
    uint256 public rejuveWithdrawalAmount = 50 * (10**6);
    
    // Default cooling time
    uint256 public lockTime = 1 hours;

    bytes4 private constant MINTER = bytes4(keccak256("mint(address,uint256)"));

    event Distribution(address indexed to, uint256 indexed amount);

    mapping(address => uint256) nextAccessTime; 

    constructor(address _agixTokenAddress, address _rejuveTokenAddress) {
        contractOwner = msg.sender;

        agixMaxSupply = 1000000000 * (10**8);
        rejuveMaxSupply = 1000000000 * (10**6);

        agixToken = IERC20(_agixTokenAddress);
        rejuveToken = IERC20(_rejuveTokenAddress);
    }

    /**
     * @dev `tokenId` for identify token for send.
     *
     * `0` - SingularityNet Token
     * `1` - Rujuve Token
     * 
     */
    function requestTokens(uint8 _tokenId) public nonReentrant {
        require(
            _tokenId == 0 || _tokenId == 1,
            "Incorrect tokenId for token grant request"
        );
        require(
            msg.sender != address(0),
            "Request must not originate from a zero account"
        );
        require(
            agixToken.totalSupply() + agixWithdrawalAmount <= agixMaxSupply ||
            rejuveToken.totalSupply() + rejuveWithdrawalAmount <= rejuveMaxSupply,
            "Invalid Amount. Exceeding total supply is unacceptable"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdrawal - try again later."
        );

        nextAccessTime[msg.sender] = block.timestamp + lockTime;

        if (_tokenId == 0) {
            (bool success, ) = address(agixToken).call(abi.encodeWithSelector(MINTER, msg.sender, agixWithdrawalAmount));
            require(
                success,
                "The attempt to mint tokens ended in failure"
            );
            emit Distribution(msg.sender, agixWithdrawalAmount);
        } else {
            (bool success, ) = address(rejuveToken).call(abi.encodeWithSelector(MINTER, msg.sender, rejuveWithdrawalAmount));
            require(
                success,
                "The attempt to mint tokens ended in failure"
            );
            emit Distribution(msg.sender, agixWithdrawalAmount);
        }
    }

    /**
     * @dev Setting Withdrawal Amount.
     * 
     * @dev `amount` amount of withdrawal tokens.
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
    function setLockTime(uint8 amount) public onlyOwner {
        lockTime = amount * 1 hours;
    }
}