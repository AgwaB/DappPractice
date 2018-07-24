pragma solidity ^0.4.18;

// 간단한 경매 시스템

contract SimpleAuction {

    address public beneficiary; // 경매 출품자 주소
    uint public auctionEnd; // 경매 종료 시점

    address public highestBidder; // 최고액 입찰자
    uint public highestBid; // 최고액 입찰가

    mapping(address => uint) pendingReturns; // 경매에 소유된 보유금 (입찰자 주소 입력시 예치금을 반환하는 매핑)
    bool ended; // 경매 종료 플래그

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount); // 거래 내역 로그 기록용 event 변수

    constructor (uint _biddingTime, address _beneficiary) public { // 생성자
        beneficiary = _beneficiary;
        auctionEnd = now + _biddingTime; // now : 현재 시각 (내장함수)
    }

    function bid() public payable{ // payable : 호출하는 주소의 잔고에 변화가 생기는 함수에는 payable 선언

        require(now <= auctionEnd); // assert 같은 예외처리 구문
        require(msg.value > highestBid);

        if(highestBid != 0){
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value); // 미리 선언한 event 발생
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];

        if(amount > 0) {
            pendingReturns[msg.sender] = 0;
            if(!msg.sender.send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public {
        require(now >= auctionEnd);
        require(!ended);
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}
