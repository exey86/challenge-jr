import pytest;
import brownie;
from brownie import accounts, RockPaperScissors;

@pytest.fixture
def contract():
    return RockPaperScissors.deploy({'from': accounts[0]})


def test_play_insufficient_amount(contract):
    with brownie.reverts('Need to deposit 1 ether to play'):
        contract.play("rock",{'from': accounts[1], 'value': 5**18})

def test_first_player_balance(contract):
    player1_balance = accounts[1].balance()
    contract.play("rock", {'from': accounts[1], 'value': 10 ** 18})
    assert contract.balance() == 10**18
    assert player1_balance - 10**18 == accounts[1].balance()
