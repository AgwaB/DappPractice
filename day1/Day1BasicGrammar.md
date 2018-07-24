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
private
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
