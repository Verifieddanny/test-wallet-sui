#[test_only]
module wallet::wallet_tests;

use wallet::wallet::{Self, Wallet};
use sui::test_scenario;
use std::debug;

const E_DEPOSIT_FAILED: u64 = 0;
const E_WITHDRAW_FAILED: u64 = 1;


#[test]
fun test_wallet_creation() {
    let test_address = @0x1;

    let mut scenario = test_scenario::begin(test_address);
    let wallet: Wallet = wallet::create_wallet(scenario.ctx());

    let owner_address = wallet::get_owner_address(&wallet);
    let token_name = wallet::get_token_name(&wallet);
    let token_balance = wallet::get_token_balance(&wallet);

    debug::print(&b"Owner Address".to_string());
    debug::print(&owner_address);
    debug::print(&b"Token Name".to_string());
    debug::print(&token_name);
    debug::print(&b"Token Balance".to_string());
    debug::print(&token_balance);

    transfer::public_share_object(wallet);

    test_scenario::end(scenario);

}

#[test]
fun test_wallet_deposit(){
    let test_address = @0x1;

    let mut scenario = test_scenario::begin(test_address);

    let mut wallet: Wallet = wallet::create_wallet(scenario.ctx());
    let deposit_amount = 100;

    wallet::deposit(&mut wallet, deposit_amount);
    let token_balance = wallet::get_token_balance(&wallet);

    assert!(token_balance == deposit_amount, E_DEPOSIT_FAILED);

    transfer::public_share_object(wallet);

    test_scenario::end(scenario);
}

#[test]
fun test_wallet_withdraw() {
    let test_address = @0x1;

    let mut scenario = test_scenario::begin(test_address);

    let mut wallet: Wallet = wallet::create_wallet(scenario.ctx());
    let deposit_amount = 100;

    wallet::deposit(&mut wallet, deposit_amount);
    let token_balance = wallet::get_token_balance(&wallet);
    //balance should be equal to deposit amount ==> 100
    assert!(token_balance == deposit_amount, E_DEPOSIT_FAILED);

    wallet::withdraw(&mut wallet, 50);
    let new_balance = wallet::get_token_balance(&wallet);
    //balance should be equal to 50 after withdrawal
    assert!(new_balance == (token_balance - 50), E_WITHDRAW_FAILED);


    transfer::public_share_object(wallet);


    test_scenario::end(scenario);

}

#[test]
fun test_wallet_withdraw_insufficient_funds() {
    let test_address = @0x1;

    let mut scenario = test_scenario::begin(test_address);
    let mut wallet: Wallet = wallet::create_wallet(scenario.ctx());
    let deposit_amount = 100;

    wallet::deposit(&mut wallet, deposit_amount);
    let token_balance = wallet::get_token_balance(&wallet);
    //balance should be equal to deposit amount ==> 100
    assert!(token_balance == deposit_amount, E_DEPOSIT_FAILED);

    let withdraw_result = wallet::withdraw(&mut wallet, 200);
    //withdraw should fail due to insufficient funds
    assert!(withdraw_result == false, E_WITHDRAW_FAILED);
    let new_balance = wallet::get_token_balance(&wallet);
    //balance should remain unchanged
    assert!(new_balance == token_balance, E_WITHDRAW_FAILED);
    transfer::public_share_object(wallet);

    test_scenario::end(scenario);  

}

#[test]
fun test_wallet_deletion() {
    let test_address = @0x1;

    let mut scenario = test_scenario::begin(test_address);
    let wallet: Wallet = wallet::create_wallet(scenario.ctx());

    wallet::delete_wallet(wallet);
    debug::print(&b"Wallet deleted successfully".to_string());

    test_scenario::end(scenario);  
}