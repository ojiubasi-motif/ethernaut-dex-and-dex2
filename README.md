# Ethernaut Dex And Dex2 challenge
## table of contents
- [DEX challenge](#dex) 
- [DEX2 challenge](#dex2)

## <font color="">DEX CHALLENGE<a id="dex"></a></font>

## High Risk Findings

### H-01 ```getSwapPrice``` function doesn't account for precision. 

***submitted by cryptedOji***

### Relevant Github link


### Summary

Due to the *Precision loss* error when ```getSwapPrice``` is called by the ```swap``` funnction, this leads the caller getting more tokens out of the contract when he repeats the *swap* multiple times and eventually leading to draining one of the tokens completely from the protocol.

### Vulnerability details
let say there are two tokens ```token1``` and ```token2``` in the ```DEX``` protocol, each with 100units in the protocol. if I start out with 10 units each of the tokens in my wallet, after **6** swaps, i can drain completeely **one** of the two tokens. Below is an illustration;

|      | Token 1 | Token 2 |        |
| -----|----------- | --------|-----|
|10 in |100     | 100      | 10 out|
|24 out | 110   | 90        |  10 in|
|24 in | 86   | 110        |  30 out|
|41 out | 110   | 80        |  30 in|
|41 in | 69   | 110        |  65 out|
|        | 69   | 110        |      |

let's solve via math to know how much of ```token2``` we need to put in the protocol to finally drain the contract of ```token1```

```
math for last swap
110 = token2 amount in * token1 balance / token2 balance
110 = token2 amount in * 110 / 45
45  = token2 amount in
    
```

so in the last swap if we put in 45 units of ```token2``` we can completely drain out the contract of ```token1```

### PoC
[Here is the test](https://github.com/ojiubasi-motif/ethernaut-dex-and-dex2/blob/master/test/dex.t.sol) for the exploit

### Impact
the protocol will completely be drained of one of the tokens of any liquidity pair added to it.

### Recommendation
use ```safeMath``` library to carefully do the ```getSwapPrice```or manually *roundup* for tokens coming in and *rounddown* for tokens going out.