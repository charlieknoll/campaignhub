pragma solidity ^0.4.2;


contract Campaign {

    // struct Info {
    //   address owner; 
    //   uint amount_goal;  // in units of Wei
    //   uint duration;
    //   uint deadline;     // in units of seconds
    // }
    //FIX no need to make this a struct
    //FIX more concise naming
    //FIX duration is unneccesary
    address public owner; 
    uint public goalAmount;  // in units of Wei
    uint public deadline;     // in units of seconds

    // uint8 constant public version = 2;
    //FIX not needed, maybe a good reason for this?

    //Info public info;
    //FIX no need for struct variable

    mapping(address => uint) public balances;    // Funding contributions
    
    //address public creator;
    //FIX not needed

    //bool public success;      // Get status success/fail when send money
    //FIX "success" should not be a global public local, removed 

    //uint public bal;          // temp balance variable
    //FIX use clear names for variables
    //uint public balance;

    // Contract state
    // uint constant CREATED          = 0;   
    // uint constant FULLY_FUNDED     = 1;    
    // uint constant PAID_OUT         = 2;   
    // uint public state;
    //FIX don't use state variables, use constant read functions


    //event OnFund(uint timestamp, address contrib, uint amount);
    //FIX remove timestamp- it will be included in log
    //FIX follow naming conventions (no On prefix)
    //FIX make contrib first in the list for indexing purposes, with timestamp first you would not be able to filter correctly
    event Fund(address contributor, uint amount); 

    // Constructor function, run when the Campaign is deployed
    //function Campaign(address own, uint amt, uint dur) {
    //FIX naming
    //FIX remove unused "own"
    function Campaign(uint _goalAmount, uint _duration) {

        owner     = msg.sender;
        //state       = CREATED;
        //FIX state not used, removed
        //info        = Info(own, amt, dur, (now+dur));
        //FIX convert from structure
        goalAmount = _goalAmount;
        deadline = _duration + now;
    }



// Change Campaign state

    // function fund(address contrib) payable public {


    //     if (state == CREATED && this.balance < info.amount_goal && now < info.deadline) {    // not reached goal yet
    //         balances[contrib] += msg.value;
    //     }
    //     else if (state == CREATED && this.balance == info.amount_goal && now < info.deadline) { // reached goal
    //         balances[contrib] += msg.value;            
    //         state = FULLY_FUNDED;
    //     }

    //     else {                                 // Campaign is either fully funded or deadline reached
    //         success = contrib.send(msg.value); // return all funds
    //         if (!success) throw;
    //     }
    //     OnFund(now, contrib, msg.value);
    // }
    //FIX change to revert early pattern
    //FIX change to external
    function fund(address contrib) payable external {
        if (now > info.deadline) revert();

        if (this.balance >= goalAmount) revert();

        //TODO handle partial overfunding?

        balances[contrib] += msg.value;

        Fund(contrib, msg.value);
    }

    // function refund() public {
    // 	if (state == CREATED && now >= info.deadline){ // only refund if deadline reached before fully funded
    //         bal = balances[msg.sender];
    //         balances[msg.sender] = 0;
    //         success = msg.sender.send(bal);
    //         if (!success) throw;
    //     }
    // }
    //FIX change to revert early
    //FIX change "public" to "external", maybe not necessary but I thought it should be external if it doesn't need to be called internally
    //FIX remove use of intermediate success variable
    //FIX clearly revert if payout already occurred
    //FIX check that user has a balance
    function refund() external {
    	
        if (now < deadline) revert();
        if (this.balance == 0) revert();

        uint balance = balances[msg.sender];
        if (balance == 0) revert();
        balances[msg.sender] = 0;
        if (!msg.sender.send(balance)) revert();
        
    }    





    // function payout() public {
    // 	if (msg.sender == info.owner && state == FULLY_FUNDED){  
    //         state = PAID_OUT;
    //         success = info.owner.send(this.balance);
    //         if (!success) throw;
    //     }
    // }

    //FIX revert early
    //FIX change to external

    function payout() external {
        if (msg.sender != owner) revert();
        if (this.balance < goalAmount) revert();
        if (!msg.sender.send(balance)) revert();
    }


// Get Functions
	
	// function getState() constant returns(uint) {
    //     return state;
    // }
    //FIX not used, removed

    // function getAmountGoal() constant returns(uint) {
    //     return info.amount_goal;
    // }
    //FIX amountGoal is public, no getter required
	

    // function getAmountRaised() constant returns(uint) {
    //     return this.balance;
    // }
    //FIX balance is public, no getter required
	
	// function getAmountContributed(address contrib) constant returns(uint) {
    //     return balances[contrib];
    // }
    //FIX not needed, getter for mappings auto generated

    // function getOwner() constant returns(address) {
    //     return info.owner;
    // }
    //FIX not needed, owner is visible
	
	// function getCreator() constant returns(address) {
    //     return creator;
    // }
    //FIX didn't need both owner and creator, removed

    // function getDeadline() constant returns(uint) {
    //     return info.deadline;
    // }
    //FIX not needed

    // function getDuration() constant returns(uint) {
    //     return info.duration;
    // }
    //FIX not needed

    // function getVersion() constant returns(uint) {
    //     return version;
    // }
    //FIX not needed
}
