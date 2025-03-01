# SPDX-License-Identifier: MIT
# OpenZeppelin Contracts for Cairo v0.1.0 (token/erc721/ERC721_Mintable_Burnable.cairo)

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, SignatureBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add
from starkware.cairo.common.math import assert_le

from openzeppelin.token.erc721.library import (
    ERC721_name,
    ERC721_symbol,
    ERC721_balanceOf,
    ERC721_ownerOf,
    ERC721_getApproved,
    ERC721_isApprovedForAll,
    ERC721_tokenURI,
    ERC721_initializer,
    ERC721_approve, 
    ERC721_setApprovalForAll, 
    ERC721_transferFrom,
    ERC721_safeTransferFrom,
    ERC721_mint,
    ERC721_burn,
    ERC721_only_token_owner,
    ERC721_setTokenURI
)

from openzeppelin.introspection.ERC165 import ERC165_supports_interface

from openzeppelin.access.ownable import (
    Ownable_initializer,
    Ownable_only_owner
)

struct Account:
    member nickname : felt
    member won_tournament_count : felt
    member lost_tournament_count : felt
    member won_battle_count : felt
    member lost_battle_count : felt
end

# ------------
# STORAGE VARS
# ------------

@storage_var
func account_information_(token_id: Uint256) -> (res : Account):
end

# get the token associated with a given account
@storage_var
func account_id_(address: felt) -> (token_id : Uint256):
end

@storage_var
func next_token_id_() -> (res : Uint256):
end

namespace account:
    # -----
    # VIEWS
    # -----

    func supportsInterface{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(interfaceId: felt) -> (success: felt):
        let (success) = ERC165_supports_interface(interfaceId)
        return (success)
    end

    func name{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }() -> (name: felt):
        let (name) = ERC721_name()
        return (name)
    end

    func symbol{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }() -> (symbol: felt):
        let (symbol) = ERC721_symbol()
        return (symbol)
    end

    func balanceOf{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(owner: felt) -> (balance: Uint256):
        let (balance: Uint256) = ERC721_balanceOf(owner)
        return (balance)
    end

    func ownerOf{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(tokenId: Uint256) -> (owner: felt):
        let (owner: felt) = ERC721_ownerOf(tokenId)
        return (owner)
    end

    func getApproved{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(tokenId: Uint256) -> (approved: felt):
        let (approved: felt) = ERC721_getApproved(tokenId)
        return (approved)
    end

    func isApprovedForAll{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(owner: felt, operator: felt) -> (isApproved: felt):
        let (isApproved: felt) = ERC721_isApprovedForAll(owner, operator)
        return (isApproved)
    end

    func tokenURI{
            syscall_ptr: felt*, 
            pedersen_ptr: HashBuiltin*, 
            range_check_ptr
        }(tokenId: Uint256) -> (tokenURI: felt):
        let (tokenURI: felt) = ERC721_tokenURI(tokenId)
        return (tokenURI)
    end

    func account_information{
            syscall_ptr : felt*,
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(address: felt) -> (account: Account):
        let (token_id: Uint256) = account_id_.read(address)
        let (account: Account) = account_information_.read(token_id)
        return (account)
    end

    #
    # Constructor
    #

    func constructor{
            syscall_ptr : felt*, 
            pedersen_ptr : HashBuiltin*,
            range_check_ptr
        }(
            name: felt,
            symbol: felt,
            owner: felt
        ):
        ERC721_initializer(name, symbol)
        Ownable_initializer(owner)
        return ()
    end


    #
    # Externals
    #

    func approve{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(to: felt, tokenId: Uint256):
        ERC721_approve(to, tokenId)
        return ()
    end

    func setApprovalForAll{
            syscall_ptr: felt*, 
            pedersen_ptr: HashBuiltin*, 
            range_check_ptr
        }(operator: felt, approved: felt):
        ERC721_setApprovalForAll(operator, approved)
        return ()
    end

    func transferFrom{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(
            from_: felt, 
            to: felt, 
            tokenId: Uint256
        ):
        with_attr error_message("Account: transferring account is disabled"):
            assert 1 = 0
        end
        return ()
    end

    func safeTransferFrom{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(
            from_: felt, 
            to: felt, 
            tokenId: Uint256,
            data_len: felt, 
            data: felt*
        ):
        ERC721_safeTransferFrom(from_, to, tokenId, data_len, data)
        return ()
    end

    func setTokenURI{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(tokenId: Uint256, tokenURI: felt):
        Ownable_only_owner()
        ERC721_setTokenURI(tokenId, tokenURI)
        return ()
    end

    func mint{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(to: felt, nickname: felt):
        alloc_locals

        # we check if the address already has an account
        let (balance) = balanceOf(to)

        with_attr error_message("Account: This address already has an associated account"):
            assert_le(balance.low, 0)
            assert_le(balance.high, 0)
        end

        let (next_token_id) = next_token_id_.read()
        ERC721_mint(to, next_token_id)

        let account: Account = Account(nickname, 0, 0, 0, 0)
        account_information_.write(next_token_id, account)
        account_id_.write(to, next_token_id)

        let (incremented_token_id, _) = uint256_add(next_token_id, Uint256(1, 0))
        next_token_id_.write(incremented_token_id)

        return ()
    end

    func burn{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(tokenId: Uint256):
        ERC721_only_token_owner(tokenId)
        ERC721_burn(tokenId)
        return ()
    end

    func incrementWonTournamentCount{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(address: felt):
        let (token_id: Uint256) = account_id_.read(address)
        let (a: Account) = account_information_.read(token_id)
        let new_account: Account = Account(a.nickname, a.won_tournament_count + 1, a.lost_tournament_count, a.won_battle_count, a.lost_battle_count)
        account_information_.write(token_id, new_account)
        return ()
    end

    func incrementLostTournamentCount{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(address: felt):
        let (token_id: Uint256) = account_id_.read(address)
        let (a: Account) = account_information_.read(token_id)
        let new_account: Account = Account(a.nickname, a.won_tournament_count, a.lost_tournament_count + 1, a.won_battle_count, a.lost_battle_count)
        account_information_.write(token_id, new_account)
        return ()
    end

    func incrementWonBattleCount{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(address: felt):
        let (token_id: Uint256) = account_id_.read(address)
        let (a: Account) = account_information_.read(token_id)
        let new_account: Account = Account(a.nickname, a.won_tournament_count, a.lost_tournament_count, a.won_battle_count + 1, a.lost_battle_count)
        account_information_.write(token_id, new_account)
        return ()
    end

    func incrementLostBattleCount{
            pedersen_ptr: HashBuiltin*, 
            syscall_ptr: felt*, 
            range_check_ptr
        }(address: felt):
        let (token_id: Uint256) = account_id_.read(address)
        let (a: Account) = account_information_.read(token_id)
        let new_account: Account = Account(a.nickname, a.won_tournament_count, a.lost_tournament_count, a.won_battle_count, a.lost_battle_count + 1)
        account_information_.write(token_id, new_account)
        return ()
    end
end