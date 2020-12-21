pragma solidity ^0.6.12;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";

contract TestSupplyChain {
    SupplyChain sup = SupplyChain(DeployedAddresses.SupplyChain());
    // Test for failing conditions in this contracts:
    // https://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
    
    // Setup contract add one item with price
    function beforeAll() {
        sup.addItem("Test Item", 1000);
    }

    // buyItem
    // test for failure if user does not send enough funds
    function testBuyItemFailureNotEnoughFunds() {
        (r, ) = DeployedAddresses.SupplyChain().call{value: 100}(abi.encodeWithSignature("buyItem(uint256)", 0));
        Assert.isTrue(r, "Buying item with not enough funds!"); // True is exception
    }

    // test for purchasing an item that is not for Sale
    function testBuyItemPurchaseNotSale() {
        (r, ) = DeployedAddresses.SupplyChain().call{value: 10000}(abi.encodeWithSignature("buyItem(uint256)", 1));
        Assert.isTrue(r, "Allows Buying item not for sale!"); // True is exception
    }
    
    // shipItem

    // test for calls that are made by not the seller
    function testShipItemNotSeller() {
        (r, ) = DeployedAddresses.SupplyChain().call{from:"0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"}(abi.encodeWithSignature("shipItem(uint256)", 0));
        Assert.isTrue(r, "Allows Shipping item from not owner!"); // True is exception
    }
    
    // test for trying to ship an item that is not marked Sold
    function testShipItemNotSold() {
        (r, ) = DeployedAddresses.SupplyChain().call(abi.encodeWithSignature("shipItem(uint256)", 0));
        Assert.isTrue(r, "Allows Shipping item not sold!"); // True is exception    
        
    }

    // receiveItem

    // test calling the function from an address that is not the buyer
    function testReceiveItemNotBuyer() {
        (r, ) = DeployedAddresses.SupplyChain().call{from:"0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"}(abi.encodeWithSignature("receiveItem(uint256)", 0));
        Assert.isTrue(r, "Allows receive item from not buyer!"); // True is exception
        
    }
    // test calling the function on an item not marked Shipped
    function testReceiveItemNotShipped() {
        (r, ) = DeployedAddresses.SupplyChain().call(abi.encodeWithSignature("receiveItem(uint256)", 0));
        Assert.isTrue(r, "Allows Receive item not shipped!"); // True is exception    
    }
}
