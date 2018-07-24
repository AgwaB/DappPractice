### 변수

Bool 

Int     부호 있는 정수 

Uint    부호 없는 정수 

Address (지갑)주소

Array   배열

String  문자열

Structs 구조체

Mapping 매핑


### 접근제어자

public

private : internal과 유사. 하지만 상속된 contract에서 접근 불가

external : 해당 함수는 contract 밖에서만 호출될 수 있다. 

internal : 내부적으로만 접근 가능

public payable : payable은 public일 때만 지정 가능. 호출하는 주소의 잔고에 변화가 생기는 함수는 필수적으로 payable function으로 선언하게 강제

public returns : 계약에 걸린 예치금을 환불받는 함수


### 특이한 변수

msg.sender : 함수를 호출한 주체의 주소

msg.value : 함수에 입력하는 ETH(payable function에만 사용 가능)

this.balance : 계약에 걸린 잔고

### 그 외

selfdestruct(주소 수신자) : 현재 계약을 파기하고 지정된 주소로 계약 계정의 잔액을 전송

mapping : key-value 형식 (ex> mapping(address => uint) A : A[_주소] = 100 이면 _주소에 해당하는 곳에 100을 넣음)

require : assert 같은 예외처리 구문

View : write, modify, delete 하지 않고 오직 read 할 때에만 쓴다. 가스비가 들지 않는다.

Storage : 블록체인 상에 영구적으로 저장되는 변수 (가스비가 든다.)

Memory : 임시적으로 저장되는 변수 (외부 호출이 일어나면 수명을 다한다.)

함수 외부에 선언된 변수는 default로 Storage, 함수 내부에 선언된 변수는 memory로 선언된다.

