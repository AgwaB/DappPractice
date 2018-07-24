pragma solidity ^0.4.18;

contract payment{
    uint balance;
    uint start;
    address public deposit;
    address public withdrawl;

    constructor (address to_address) public{
        deposit = msg.sender;
        withdrawl = to_address;
        start = now;
    }

    function deposit_to_contract() public payable{
        if(msg.sender == deposit){
            balance += msg.value;
        }
    }

    function withdrawl_from_contract() public{
        if(msg.sender == withdrawl){
            withdrawl.transfer(this.balance);
        } else if(msg.sender == deposit && now > start + 1 seconds){
            selfdestruct(deposit);
        }
    }
}
