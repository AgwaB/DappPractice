pragma solidity ^0.4.8;

// 소유자 관리용 계약
contract Owned {
    // 상태 변수
    address public owner; // 소유자 주소

    // 소유자 변경 시 이벤트
    event TransferOwnership(address oldaddr, address newaddr);

    // 소유자 한정 메서드용 수식자
    modifier onlyOwner() { if (msg.sender != owner) throw; _; }

    // 생성자
    function Owned() {
    owner = msg.sender; // 처음에 계약을 생성한 주소를 소유자로 한다
    }
    // (1) 소유자 변경
    function transferOwnership(address _new) onlyOwner {
        address oldaddr = owner;
        owner = _new;
        TransferOwnership(oldaddr, owner);
    }
}


contract Members is Owned { // Owned contract를 상속
    // (3) 상태 변수 선언
    address public coin; // 토큰(가상 화폐) 주소
    MemberStatus[] public status; // 회원 등급 배열
    mapping(address => History) public tradingHistory; // 회원별 거래 이력
    // (4) 회원 등급용 구조체
    struct MemberStatus {
        string name; // 등급명
        uint256 times; // 최저 거래 회수
        uint256 sum; // 최저 거래 금액
        int8 rate; // 캐시백 비율
    }
    // 거래 이력용 구조체
    struct History {
        uint256 times; // 거래 회수
        uint256 sum; // 거래 금액
        uint256 statusIndex; // 등급 인덱스
    }
    // (5) 토큰 한정 메서드용 수식자
    modifier onlyCoin() { if (msg.sender == coin) _; }
    // (6) 토큰 주소 설정
    function setCoin(address _addr) onlyOwner {
        coin = _addr;
    }
// (7) 회원 등급 추가
    function pushStatus(string _name, uint256 _times, uint256 _sum, int8 _rate) onlyOwner {
        status.push(MemberStatus({
        name: _name,
        times: _times,
        sum: _sum,
        rate: _rate
    }));
    }
// (8) 회원 등급 내용 변경
    function editStatus(uint256 _index, string _name, uint256 _times, uint256 _sum, int8 _rate) onlyOwner {
        if (_index < status.length) {
            status[_index].name = _name;
            status[_index].times = _times;
            status[_index].sum = _sum;
            status[_index].rate = _rate;
        }
    }
    // (9) 거래 내역 갱신
    function updateHistory(address _member, uint256 _value) onlyCoin {
        tradingHistory[_member].times += 1;
        tradingHistory[_member].sum += _value;
        // 새로운 회원 등급 결정(거래마다 실행)
        uint256 index;
        int8 tmprate; // default : 0
        for (uint i = 0; i < status.length; i++) {
        // 최저 거래 횟수, 최저 거래 금액 충족 시 가장 캐시백 비율이 좋은 등급으로 설정
            if (tradingHistory[_member].times >= status[i].times &&
                tradingHistory[_member].sum >= status[i].sum &&
                tmprate < status[i].rate) {
                index = i;
            }
        }
        tradingHistory[_member].statusIndex = index;
    }
    // (10) 캐시백 비율 획득(회원의 등급에 해당하는 비율 확인)
    function getCashbackRate(address _member) constant returns (int8 rate) {
        rate = status[tradingHistory[_member].statusIndex].rate;
    }
}
