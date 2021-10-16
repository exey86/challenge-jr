pragma solidity ^0.6.0;

import "OpenZeppelin/openzeppelin-contracts@3.0.0/contracts/token/ERC20/ERC20.sol";
/**
 * @title exactly-finance/challenge-jr
 * @dev Implements the classic game of rock, paper, scissors
 */
contract RockPaperScissors {
    //IERC20 public token;
    /// @dev makes the contract able to receive tokens
    receive() external payable {}
    /// @dev The mapping consideres all possible outcomes of the game
    mapping (string => mapping (string => uint8)) public all_moves;
    struct Players {
        address player_address;
        uint amount;
        string move;
    }

    Players[] private players;

   constructor() public {
       /// wETH 0xD76b5c2A23ef78368d8E34288B5b65D616B746aE
       /// token = IERC20(_token);
       /// @dev first key: player1 move, second key: player2 move, values: 0=draw, 1=player1 wins, 2=player2 wins
       all_moves["rock"]["rock"] = 0;
       all_moves["rock"]["paper"] = 2;
       all_moves["rock"]["scissors"] = 1;
       all_moves["paper"]["rock"] = 1;
       all_moves["paper"]["paper"] = 0;
       all_moves["paper"]["scissors"] = 2;
       all_moves["scissors"]["rock"] = 2;
       all_moves["scissors"]["paper"] = 1;
       all_moves["scissors"]["scissors"] = 0;
   }


    function play(string memory _move) public payable {
        /// verify if sender has enough tokens, if not refuse the enrolling, if yes transfer tokens to the contract.
        require(msg.value == 10**18, 'Need to deposit 1 ether to play');
        //bool sent = transferFrom(msg.sender, address(this), msg.value);
        //require(sent, "Token transfer failed");
        enroll(_move);
        uint nums_players = players.length;
        /// once the player2 is in, this trigger the winner
        if (nums_players == 2) {
            uint8 result = winner();
            process_result(result);
            delete players;
        }

    }

    function enroll(string memory _move) internal {
        players.push(Players(msg.sender, msg.value, _move));
    }

    function winner() internal view returns(uint8){
        /// this function has to be called after the 2 players made their moves.
        return all_moves[players[0].move][players[1].move];
    }

    function process_result(uint8 _result) internal {
        if (_result == 0) {
            payable(players[0].player_address).transfer(players[0].amount);
            payable(players[1].player_address).transfer(players[1].amount);
        } else {
            payable(players[_result].player_address).transfer(address(this).balance);
        }
    }

}
