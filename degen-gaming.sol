// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenGamingToken is ERC20,Ownable,ERC20Burnable{

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender){}

    //redeemable items
    enum Cards{comman,uncomman,ultrapro,legend}

    struct Player{
        address toAddress;
        uint amount;
    }
    //player can by degengaming 
    Player[] public players;

    struct PlayerCards{
        uint comman;
        uint uncomman;
        uint ultrapro;
        uint legend;        
    }

    //Storing of reedme cards
    mapping (address=>PlayerCards) public playerCards;

    function buyDegen(address _toAddress,uint _amount)public{
        players.push(Player({toAddress:_toAddress,amount:_amount}));
    }

    //mint tokens for the player
    function mintToken() public onlyOwner {
        
        while (players.length!=0) {
            uint i = players.length -1;
            if (players[i].toAddress != address(0)) { 
            _mint(players[i].toAddress, players[i].amount);
            players.pop();
            }
        }
    }
    
    //Transfering the tokens to others
    function transferDegen(address _to, uint _amount)public {
        require(_amount<=balanceOf(msg.sender),"low degen");
        _transfer(msg.sender, _to, _amount);
    }

    //Redeem different cards
    function redeemCards( Cards _card)public{
        if(_card == Cards.comman){
            require(balanceOf(msg.sender)>=10,"Low degen");
            playerCards[msg.sender].comman +=1;
            burn(10);
        }else if(_card == Cards.uncomman){
            require(balanceOf(msg.sender)>=20,"Low degen");
            playerCards[msg.sender].uncomman +=1;
            burn(20);
        }else if(_card == Cards.ultrapro){
            require(balanceOf(msg.sender)>=30,"Low degen");
            playerCards[msg.sender].ultrapro +=1;
            burn(30);
        }else if(_card == Cards.legend){
            require(balanceOf(msg.sender)>=40,"Low degen");
            playerCards[msg.sender].legend +=1;
            burn(40);
        }
        else{
            revert("Wrong card selected");
        }
    }

    //burn token
    function burnDegengaming(address _of, uint amount)public {
        _burn(_of, amount);
    }

    //check the tokens
    function checkBalance()public view returns(uint){
        return balanceOf(msg.sender);
    }
}
