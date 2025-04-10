// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(address recipient) ERC20("MyToken", "MTK") {
        _mint(recipient, 10000 * 10 ** decimals());
    }
}

contract ERC20Auction{
    struct Listing{
        address seller;
        ERC20 token;
        uint pricePerToken;
        uint remainingAmount;
    }
    
    uint public listingId;
    mapping(uint => Listing) public listings;

    function listToken(address tokenAddress, uint price, uint amount) public {
        require(amount>0 && price>0,"Amount & price should be greater than zero !" );
        ERC20 token=ERC20(tokenAddress);
       listings[listingId] = Listing(msg.sender, token, price, amount);
        listingId++;
    }
       function buyTokens(uint id,uint amount) public payable  {
            Listing storage listing = listings[id];
            uint cost = amount * listing.pricePerToken;
            require(msg.value>cost,"Not enough ETH");
            listing.remainingAmount-=amount;
            listing.token.transfer(msg.sender, amount);
              payable(listing.seller).transfer(cost);
              if(msg.value>cost){
                payable (msg.sender).transfer(msg.value-cost);
              }
       }
       function getListCount() public view returns(uint){
        return listingId;
       }
} 