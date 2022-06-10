# Security-Considerations
Hack preventing



1) First technick to preventing re-entrency hack:

To fix problem with re-entrency there is a pattern to follow in SOLIDITY that is called "CHECKS, EFFECTS, INTERACTIONS" - 
and this tells us in which order we should do things.. 
         
         - In withdraw first we CHECK if balance to withdraw is enought for msg.sender.
         - Then we should do EFFECTS, wchich is basicaly in most cases changing the state of our contract
         - And then we should do interactions with other contracts or wallets
         
              
           function withdraw() public {
              require( balance[msg.sender] = 0;                       // CHECKS
              uint toTransfer = balance[msg.sender];                  // save data before effects on storage
              balance[msg.sender] = 0;                                // EFFECTS
              bool success = msg.sender.send(toTransfer);             // INTERACTION
              if(!success){ balance[msg.sender] = toTransfer; }       // past saved data back if withdraw fail
            }  
            
Today in theory .send and .transfer are saved from re-entrency, because they only forward a limited amount of gas to the fallback function meaning fallback function is limited in terms what it can do, because we only forward 2300 gas, which is
not enought to make an external call back to the withdraw function, but this is not good enought, because:

Back in history when DAO hack happend was introdused .send and .transfer function with 2300 gas stipend, which means amount of gas that is send to receiver, and if receiver is a contract that have fallback function this function can execute their code logic with up to 2300 gas. It's enought for login event, but it isn't enought to call our withdraw function again to make another external call.

Previous , when people used msg.sender.call.value(amount)("") in their code it was dangerous to use .call function, because .call function can use unlimitted gas limit. People didn't really know how to build safe contracts, people doesn't know previous how to use HACK - PREVENTING PATTERNS

Now, if we use "CHECK, EFFECTS, INTERACTIONS" pattern it doesn't matter how much gas we send because there are no re-entrency
that is enabled.

PROBLEM with .send and .transfer is that this only works if we don't change what different operations cost in gas.
Currently 2300 gas is not enought for doing re-entrency, but with EIP1884 is possible to change what different operation cost. And if contract will safe from re-entrency now, it's possible that amount of gas cost change in the future, and contract will be at blockchain all time, so in future it potentially be possible to do cheaper an external calls and if we don't have SAFE pattern , then somebody will have the ability to do the re-entrency attack in the future.
It works also could cause in future that your contract wouldn't work, because gas cost could rise, and fallback function wouldn't have enought gas for execute code.

This is why using .call again, but now it looks a litlle bit different - msg.sender.call{value: amount}(""); 
with "CHECKS, EFFECTS, INTERACTIONS" pattern in order to prevent re-entrency attack is better solution.
              
              
           function withdraw() public {
              require( balance[msg.sender] = 0;                             // CHECKS
              uint toTransfer = balance[msg.sender];                        // save data before effects on storage
              balance[msg.sender] = 0;                                      // EFFECTS
              (bool success,) = msg.sender.call{value: toTransfer}("");     // INTERACTION
              if(!success){ balance[msg.sender] = toTransfer; }             // past saved data back if withdraw fail
            }  
              
It's very important to think about this pattern in all of functions

2) Second technick to prevent re-entrency attack is to use modifier in our contract.
      
      The idea is to lock the contract while the function is executing. So the only a single function can be executed at a time. Very easy and efficient pattern.
      
      
           //We need an internal state variable to lock a contract
           bool internal locked
      
           modifier noReentrant(){
             require(!locked, "No re-entrancy");
             locked = true;
             _;
             //After function execution is end we set locked equal to false
             locked = false
            }
            
           function withdraw(uint _amount) public noReentrant{
              require( balance[msg.sender] >= _amount;                      // CHECKS
              balance[msg.sender] -= _amount;                               // EFFECTS
              (bool success,) = msg.sender.call{value: _amount}("");        // INTERACTION
              if(!success){ balance[msg.sender] += _amount; }               // get back _amount if withdraw fail
            }  
         
         
         

