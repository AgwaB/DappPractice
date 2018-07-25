pragma solidity ^0.4.8;

contract SNUCOIN {

    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;
    mapping (address => uint256) public balanceOf; 
    mapping (address => int8) public blackList;
    mapping (address => int8) public cashbackRate;
    address public owner;


    modifier onlyOwner() { if (msg.sender != owner) throw; _; }


    function SNUCOIN(uint256 _supply, string _name, string _symbol, uint256 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        balanceOf[msg.sender] = _supply *10**decimals;
        totalSupply = _supply*10**decimals;
        owner = msg.sender ;
    }

    function blacklisting(address _addr) onlyOwner {
        blackList[_addr] = 1;
    }
    function deleteFromBlacklist(address _addr) onlyOwner {
        blackList[_addr] = -1;
    }

    function setCashbackRate(int8 _rate) {
        if (_rate < 1) {
           _rate = 0;
        } else if (_rate > 100) {
           _rate = 100;
        }
        cashbackRate[msg.sender] = _rate;

    }

    function transfer(address _to, uint256 _value) {
        //
        if (balanceOf[msg.sender] < _value) throw;
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;
        //
        if (blackList[msg.sender] >  0) throw;
        else if (blackList[_to] > 0) throw;
        else {
            uint256 cashback = 0;
            if (cashbackRate[_to] > 0) cashback = _value / 100 * uint256(cashbackRate[_to]);
            balanceOf[msg.sender] -= (_value - cashback);
            balanceOf[_to] += (_value - cashback);

        }
    }
}
