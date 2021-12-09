pragma solidity ^0.8.5;

contract Escrow {
    address agent;
    mapping(address => uint) public deposits;
    address payeeAddress;
    bool workDone = false;

    constructor() public {
        agent = msg.sender;
    }
    
    modifier onlyAgent() {
        require(msg.sender == agent, "Only Owner allowed to run the function");
        _;
    }
    modifier confirmPayee(address payee) {
        require(msg.sender == payeeAddress, "Make sure you are the payee");
        _;
    }

    function deposit(address payee) public onlyAgent payable {
        uint amount = msg.value;
        payeeAddress = payee;
        deposits[payee] = deposits[payee] + amount;
    } 
    function withdraw(address payable payee) public onlyAgent {
        require(workDone, "Work not completed yet");
        uint payment = deposits[payee];
        deposits[payee] = 0;
        payee.transfer(payment);
    }
    function markWorkAsDone(address payee) public confirmPayee(payee) {
        workDone = true;
    }
}
