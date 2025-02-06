## HackMeIfYouCan 

To execute the deployment script, run the following command:

```sh
source .env
forge script script/HackMeIfYouCan.s.sol --tc HackMeIfYouCanScript --rpc-url $AVAX_RPC_URL --private-key $S_PRIVATE_KEY --broadcast
```

For the CoinFlip, run the following for each new block (ten times):
```sh
forge script script/HackMeIfYouCan.s.sol --tc CoinFlipSolution --rpc-url $AVAX_RPC_URL --private-key $S_PRIVATE_KEY --broadcast
```

### General

The script file is composed of two contract for this exercise.

HackMeIfYouCanScript who resolve all excepting CoinFlip (resolved by CoinFlipSolution).

The Attacker contract is needed to play with the msg.sender, same as SyncBlock for the CoinFlip.

All transactions are sended between the startBroadcast and stopBroadcast.

whenUnlocked modifier is a trap !

### Free point

AddPoint needs to be called from Attacker because the tx.origin (me then the EOA address) should be different than the msg.sender (the Attacker contract in the point of view of the HackMeIfYouCan)

### Elevator

goTo should be called with a random value (don't care because not used)
isLastFloor should return a false before and then a true to be assigned to top[tx.origin] and then pass the last guard. (To use )

### SendKey

(From the beginning of the HackMeIfYouCan contract, all stat variables are 32 bytes except the owner address (20) but the next is 32 too then it can't be in the previous slot)
data is slot 4 and then key is on slot 12, 12 + 4 so I get the slot 16

### sendPassword

password is slot 3 following the same logic as previously

### Contribute and receive

To get the points inside the receive, we should contribute and send 1wei at least. To contribute, we should send at least an additional wei. so I contribute with 1 wei, then I send 1 wei.

### transfer

Unable to explain
The address(0)

### CoinFlipSolution

I use the same calculation as in the 'flip' method to predict the result.
I should be in a special SyncBlock contract to catch the same previous block number as the attacked contract for the calculation.

This operation can't be done 2 times on the same block as I have a revert if lastHash == blockValue.

