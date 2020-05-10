pragma solidity >=0.4.21 <0.7.0;

import "./DappToken.sol";

contract DappTokenSale {
    address payable public admin ;
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    constructor(DappToken _tokenContract, uint256 _tokenPrice) public {
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x,"require function multiply");
        }

    function buyTokens(uint256 _numberOfTokens) public payable  {
        require(msg.value == multiply(_numberOfTokens, tokenPrice),"BuyTokens require 1");
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens,"BuyTokens require 2");
        require(tokenContract.transfer(msg.sender, _numberOfTokens),"BuyTokens require 1");

        tokensSold += _numberOfTokens;

        emit Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public {
        require(msg.sender == admin,"require endSale 1");
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))),"require endSale 1");

        // UPDATE: Let's not destroy the contract here
        // Just transfer the balance to the admin
       admin.transfer(address(this).balance);
    }
}