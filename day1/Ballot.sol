pragma solidity ^0.4.18;

contract Bollot {
   struct Voter{
     uint weight; // 투표 비중
     bool voted; // 투표 여부
     address delegate; // 위임받는 자 주소
     uint vote; // 투표한 후보자
   }
   mapping(address => Voter) public voters; // Voter 구조체에 mapping

   struct Proposal{
     bytes32 name; // 후보자명
     uint voteCount; // 기표수
   }
   Proposal[] public proposals;

   address public chairperson; // 의장 주소

   constructor(bytes32[] proposalNames) public{
     chairperson = msg.sender;
     voters[chairperson].weight = 1;

     for(uint i = 0 ; i < proposalNames.length; i++){
       proposals.push(Proposal({name: proposalNames[i], voteCount : 0}));
     }
   }

   function giveRightToVote(address voter) public {
     require((msg.sender == chairperson) && !voters[voter].voted && (voters[voter].weight == 0));

     voters[voter].weight = 1;
   }

   function delegate(address to) public { // 주소 to 에게 투표권을 위임
     Voter storage sender = voters[msg.sender]; // *중요 sender는 voter[msg.sender]를 가리키는 포인터이다.
     require(!sender.voted); // 위임하려는 사람은 투표를 하지 않았어야 함
     require(to != msg.sender); // 자기 자신한테 위임하지 아니함

     while(voters[to].delegate != address(0)){ // 주소 to가 이미 위임한 경우 (to에게 위임 하려고 했는데 to는 이미 위임해버린 경우)
       to = voters[to].delegate; // 위임 한 사람이 없을 때 까지 to의 위임자로 변경하면서 확인
       require(to != msg.sender);
     }

     sender.voted = true;
     sender.delegate = to;
     Voter storage delegate_ = voters[to]; // 위임받은 자를 가리키는 포인터
     if(delegate_.voted){ // 위임 받는자가 이미 투표를 했다면
       proposals[delegate_.vote].voteCount += sender.weight; // 위임자의 투표비중만큼 득표수를 늘림
     } else {
       delegate_.weight += sender.weight; // 투표 안했으면 비중을 더해준다.
     }
   }

   function vote(uint proposal) public { // 기호 proposal번에게 투표권을 행사
     Voter storage sender = voters[msg.sender];
     require(!sender.voted); // 투표하지 않았을 경우에만
     sender.voted = true;
     sender.vote = proposal;
     proposals[proposal].voteCount += sender.weight; // 득표
   }

   function winningProposal() public view returns (uint winningProposal_) { //개표 함수, 당선된 후보자 기호 반환
     uint winningVoteCount = 0; // 초기 득표수 설정
     for(uint p = 0 ; p < proposals.length; p++){
       if(proposals[p].voteCount > winningVoteCount){
         winningVoteCount = proposals[p].voteCount;
         winningProposal_ = p;
       }
     }
   }

   function winnerName() public view returns (bytes32 winnerName_){ // 당선자 이름 반환
     winnerName_ = proposals[winningProposal()].name;
   }
}
