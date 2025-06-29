module wallet::wallet;

use std::string::String;

public struct Token has drop, store {
    name: String,
    balance: u64,
}

public struct Wallet has key, store {
    id: UID,
    owner_address: address,
    token: Token
}

public fun create_wallet(ctx: &mut TxContext, token_name: String): Wallet {
    let token = Token{
        name: token_name,
        balance: 0
    };

    let wallet = Wallet{
        id: object::new(ctx),
        owner_address: ctx.sender(),
        token
    };

    wallet
    //transfer::public_transfer(wallet, ctx.sender());
}

public fun deposit(wallet: &mut Wallet, amount: u64) {
    wallet.token.balance = wallet.token.balance + amount;
}

public fun withdraw(wallet: &mut Wallet, amount: u64): bool {
    if(wallet.token.balance <= amount) {
        false
    } else {
        wallet.token.balance = wallet.token.balance - amount;
        true
    }
}

public fun get_owner_address(wallet: &Wallet): address {
    wallet.owner_address
}

public fun get_token_name(wallet: &Wallet): String {
    wallet.token.name
}

public fun get_token_balance(wallet: &Wallet): u64 {
    wallet.token.balance
}

public fun delete_wallet(wallet: Wallet) {
   let Wallet {
        id,
        owner_address: _,
        token: _,
    } = wallet;

    object::delete(id);
}