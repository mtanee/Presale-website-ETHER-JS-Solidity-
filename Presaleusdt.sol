
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ERC20.sol";




contract TokenPresale {
    address public admin; 
    IERC20 public token; 
    IERC20 public usdt;
    uint256 public rate; 
   

    constructor(
        address _tokenAddress,
        address _usdtAddress
    ) {
        admin = msg.sender;
        token = IERC20(_tokenAddress);
        usdt = IERC20(_usdtAddress);
        rate = 10;
    }

  

    modifier isAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
       // Function to allow the admin to withdraw USDT from the contract
    function withdrawUSDT(uint256 amount) external {
        require(msg.sender == admin, "Only admin can call this function");
        usdt.transfer(admin, amount);
    }

   
    function buyTokens(uint256 usdtAmount) external {
        require(usdtAmount > 0, "Invalid amount");
        uint256 tokenAmount = usdtAmount * rate;
        require(token.balanceOf(address(this)) >= tokenAmount, "Not enough tokens in the contract");
        require(usdt.transferFrom(msg.sender, address(this), usdtAmount), "USDT transfer failed");
        require(token.transfer(msg.sender, tokenAmount), "Token transfer failed");
        
    }
}
