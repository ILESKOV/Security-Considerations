# Security-Considerations
Hack preventing


To fix problem with re-entrency there is a pattern to follow in SOLIDITY that is called "CHECKS, EFFECTS, INTERACTIONS" - 
and this tells us in which order we should do things. 
         
         - In withdraw first we CHECK if balance to withdraw is enought for msg.sender.
         - Then we should do EFFECTS, wchich is basicaly in most cases changing the state of our contract
         - And then we should do interactions with other contracts or wallets
         
         
