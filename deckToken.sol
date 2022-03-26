// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IERC20 {

function totalSupply() external view returns (uint256);

function balanceOf(address account) external view returns (uint256);

function transfer(address to, uint256 amount) external returns (bool);

function allowance(address owner, address spender) external view returns (uint256);

function approve(address spender, uint256 amount) external returns (bool);

function transferFrom(
    address from,
    address to,
    uint256 amount
) external returns (bool);


event Transfer(address indexed from, address indexed to, uint256 value);

event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DeckToken is IERC20 {

string public _name;
string public _symbol;
uint8 public _decimal;
uint256 public _totalSupply;

mapping(address => uint) balances;
mapping(address => mapping(address => uint)) approved;

// modifier validAddress(address _address){
//     require(_address != address(0), "Address not valid!");
//     _;
// }

constructor() {
    _name = "DeckToken";
    _symbol = "DKT";
    _decimal = 8;
    _totalSupply = 10000 * 10 ** _decimal;
    balances[msg.sender] = _totalSupply;
    emit Transfer(address(0), msg.sender, _totalSupply);
}

 function totalSupply() public view returns (uint256) {
     return _totalSupply;
 }

 function balanceOf(address _user) public view returns (uint256){
     return balances[_user];
 }

 function transfer(address _to, uint256 _amount) public override returns (bool status){
     balances[msg.sender] -= _amount;
     balances[_to] += _amount;
     emit Transfer(msg.sender, _to, _amount);
     return true;
 }

 function allowance(address _owner, address _spender) public view override returns (uint256){
       uint256 _amount = approved[_owner][_spender];
       return _amount;
 }

 function approve(address _spender, uint256 _amount) public override returns(bool){
    require(balances[msg.sender] >= _amount, "Not Enough balance!");
    approved[msg.sender][_spender] += _amount;
    emit Approval(msg.sender, _spender, _amount);
    return true;
}

function transferFrom(
    address _from,
    address _to,
    uint256 _amount
) public override returns (bool){
    require(approved[_from][msg.sender] >= _amount, "Amount not approved");
    approved[_from][msg.sender] -= _amount;
    balances[_from] -= _amount;
    balances[_to] += _amount;
    emit Transfer(_from, _to, _amount);
    return true;
}
}
