# SPDX-License-Identifier: Apache-2.0

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256

from openzeppelin.token.erc20.library import (
    ERC20_name,
    ERC20_symbol,
    ERC20_totalSupply,
    ERC20_decimals,
    ERC20_balanceOf,
    ERC20_allowance,
    ERC20_initializer,
    ERC20_approve,
    ERC20_increaseAllowance,
    ERC20_decreaseAllowance,
    ERC20_transfer,
    ERC20_transferFrom,
    ERC20_mint,
)

namespace OnlyDust:
    # -----------
    # CONSTRUCTOR
    # -----------

    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        name : felt, symbol : felt, decimals : felt, initial_supply : Uint256, recipient : felt
    ):
        ERC20_initializer(name, symbol, decimals)
        ERC20_mint(recipient, initial_supply)
        return ()
    end

    # -----
    # VIEWS
    # -----

    func name{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (name : felt):
        let (name) = ERC20_name()
        return (name)
    end

    func symbol{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        symbol : felt
    ):
        let (symbol) = ERC20_symbol()
        return (symbol)
    end

    func totalSupply{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        totalSupply : Uint256
    ):
        let (totalSupply : Uint256) = ERC20_totalSupply()
        return (totalSupply)
    end

    func decimals{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (
        decimals : felt
    ):
        let (decimals) = ERC20_decimals()
        return (decimals)
    end

    func balanceOf{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        account : felt
    ) -> (balance : Uint256):
        let (balance : Uint256) = ERC20_balanceOf(account)
        return (balance)
    end

    func allowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        owner : felt, spender : felt
    ) -> (remaining : Uint256):
        let (remaining : Uint256) = ERC20_allowance(owner, spender)
        return (remaining)
    end

    # ---------
    # EXTERNALS
    # ---------

    func transfer{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        recipient : felt, amount : Uint256
    ) -> (success : felt):
        ERC20_transfer(recipient, amount)
        return (TRUE)
    end

    func transferFrom{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        sender : felt, recipient : felt, amount : Uint256
    ) -> (success : felt):
        ERC20_transferFrom(sender, recipient, amount)
        return (TRUE)
    end

    func approve{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        spender : felt, amount : Uint256
    ) -> (success : felt):
        ERC20_approve(spender, amount)
        return (TRUE)
    end

    func increaseAllowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        spender : felt, added_value : Uint256
    ) -> (success : felt):
        ERC20_increaseAllowance(spender, added_value)
        return (TRUE)
    end

    func decreaseAllowance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        spender : felt, subtracted_value : Uint256
    ) -> (success : felt):
        ERC20_decreaseAllowance(spender, subtracted_value)
        return (TRUE)
    end
end
