// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SimpleAuction {
    address public highestBidder;
    uint public highestBid;
    address public owner;
    uint public auctionEndTime;

    mapping(address => uint) public pendingReturns;
    bool public ended;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(uint _biddingTime) {
        owner = msg.sender;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    function bid() external payable {
        require(block.timestamp <= auctionEndTime, "Auction already ended.");
        require(msg.value > highestBid, "There already is a higher bid.");

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() external returns (bool) {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw.");

        pendingReturns[msg.sender] = 0;

        if (!payable(msg.sender).send(amount)) {
            pendingReturns[msg.sender] = amount;
            return false;
        }

        return true;
    }

    function endAuction() external {
        require(block.timestamp >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "Auction end already called.");
        require(msg.sender == owner, "Only owner can end auction.");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        payable(owner).transfer(highestBid);
    }
}
