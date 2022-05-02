// Contract that can be hacked
pragma 0.8.13;


contract EtherStore {
    mapping( address => uint ) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount)

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ehter");

        balances[msg.sender] -= _amount;
    }

    function getBalances() public view returns (uint) {
        return address(this).balance;
    }
}
