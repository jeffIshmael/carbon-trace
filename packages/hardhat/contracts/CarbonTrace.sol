// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract CarbonTrace is ERC20{   
    
    address public owner;

    constructor() ERC20("CarbonCredits", "CARBZ") {

    owner = msg.sender;
    
    }

uint totalProposals;
  
    uint totalcompany;
    uint totalOffsetters;
    uint totalValidators;

    //struct of the company thats needs carbon credits.
    struct Buyer {
    uint buyerId;
    string compName;
    uint regPin;
    string category;
    string description;
    address buyerAdd;
    uint[] carbonIds;
    }

    //array of buyers
    Buyer[] public buyers;

    //struct of the one rehabilitating envt.
    struct Offsetter{
    uint offsetterId;
    string compName;
    uint regPin;
    string category;    
    string description;
    address offsetterAdd;
    uint[] proposalIds;
    }

    //array of offsetters
    Offsetter[] public offsetters;

    //struct for bought credits
    struct boughtCredit{
    uint proposalId;
    uint estAmount;
    uint timestamp;
    address buyerAdd; 
    }

    //array of bought credits
    boughtCredit[] public boughtCredits;

    //struct of validator
    struct validator{
    uint validatorId;
    string name;
    uint regNo;
    address validatorAdd;
    
    }

    //array of validators
    validator[] public validators;

    struct Result {
        StructType structType;
        address addr;
        bytes data; // encoded struct data
        
    }

    enum StructType { None, Buyer, Offsetter, Validator }

    //mappings of buyers
    mapping (uint => Buyer) buyernId;
    mapping (string => Buyer) buyernName;
    mapping(address => Buyer) buyernAddress;

    //mappings of offsetters
    mapping (uint => Offsetter) offSetternId;
    mapping (string => Offsetter) offSetternName;
    mapping(address => Offsetter) offSetternAddress;

    //mappings of bought credits
    mapping (address => boughtCredit) boughtCreditsAddress;
    mapping (uint => boughtCredit) boughtCreditsId;

    //mapping of validators
    mapping (uint => validator) validatornId;
    mapping (string => validator) validatornName;
    mapping(address => validator) validatornAddress;

    // event emitted when offsetter is registered
    event offsetterRegistered(uint offsetterId,
    string compName,
    uint regPin,
    string category,
    string description,
    address offsetterAdd,
     uint[] proposalIds);

    //event of a registered user
    event buyerRegistered(uint buyerId,
    string compName,
    uint regPin,
    string category,
    string description,
    address buyerAdd,
 uint[] carbonIds);


    //event of a bought credit
    event boughtCreditCreated(uint buyerId,
    string compName,
    uint regPin,
    address buyerAdd,
    uint estAmount,
    uint timestamp
    );

    //event of registered validator
    event validatorRegistered(uint validatorId, string name, uint regNo,address validatorAdd);

    //event to show validator voted
    event validatorVoted(uint validatorId, uint proposalId,address validatorAdd);

    //event to show contract withdrawn
    event withdrawalSuccessful(address receiver,uint amount);

    //event to show minted
    event minted(address sender,uint amount);

    //function to register offsetter
    function registerBuyer( string memory _compName,uint _regPin,string memory _category,string memory _description) public {
    require(!registeredOffsetter(msg.sender), "You are already registered as an offsetter");
    require(!registeredBuyer(msg.sender), "You are already registered as a buyer");
    uint _buyerId = totalcompany;
    Buyer memory newBuyer = Buyer({
    buyerId: _buyerId,
    compName: _compName,
    regPin: _regPin,
    category: _category,
    description: _description,
    buyerAdd: msg.sender,
    carbonIds: new uint[](0)
    });
    buyernId[_buyerId]= newBuyer;
    buyernAddress[msg.sender]= newBuyer;
    buyernName[_compName]= newBuyer;

    buyers.push(newBuyer);
    totalcompany++;

    emit buyerRegistered(_buyerId, _compName, _regPin, _category, _description, msg.sender,new uint[](0));
    }


    //function to register buyer
    function registerOffsetter( string memory _compName,uint _regPin,string memory _category,string memory _description)
    public {
    require(!registeredOffsetter(msg.sender), "You are already registered as an offsetter");
    require(!registeredBuyer(msg.sender), "You are already registered as a buyer");
    uint _offsetterId = totalOffsetters;
    Offsetter memory newOffsetter = Offsetter({
    offsetterId: _offsetterId,
    compName: _compName,
    regPin: _regPin,
    category: _category,
    description: _description,
    offsetterAdd: msg.sender,
    proposalIds: new uint[](0)
    });

    offSetternId[_offsetterId]= newOffsetter;
    offSetternAddress[msg.sender]= newOffsetter;
    offSetternName[_compName]= newOffsetter;

    offsetters.push(newOffsetter);
    totalOffsetters++;
    emit offsetterRegistered(_offsetterId, _compName, _regPin, _category, _description, msg.sender, new uint[](0));
    }

   
    //function to register validator
    function registerValidator(string memory _name, uint _regNo) public {
    require(!registeredValidator(msg.sender), "You are already registered as a validator");
    require(!registeredBuyer(msg.sender), "You are  registered as a buyer");
    require(!registeredOffsetter(msg.sender), "You are  registered as an offsetter");
    uint _validatorId = totalValidators;
    validator memory newValidator = validator({
    validatorId: _validatorId,
    name: _name,
    regNo: _regNo,
    validatorAdd: msg.sender
    });
    validatornId[_validatorId]= newValidator;
    validatornName[_name]= newValidator;
    validatornAddress[msg.sender] = newValidator;
    totalValidators++;
    emit validatorRegistered(_validatorId, _name,_regNo, msg.sender);
    }

 //function to get Carbon credits
    function buyCarbonCredits(uint _estAmount) public payable {
        require(registeredBuyer(msg.sender), "Please register as a buyer first");
        require(super.balanceOf(msg.sender)>= _estAmount, "You have no sufficient CBT balance");
        _burn(msg.sender,_estAmount);
        uint _proposalId = totalProposals;
        boughtCredit memory newCredit = boughtCredit({
        proposalId: _proposalId,
        estAmount: _estAmount,
        timestamp: block.timestamp,
        buyerAdd: msg.sender
        });
        boughtCreditsId[_proposalId]= newCredit;
        boughtCreditsAddress[msg.sender]= newCredit;
        buyernAddress[msg.sender].carbonIds.push(_proposalId);
        boughtCredits.push(newCredit);
        totalProposals++;
        emit boughtCreditCreated(buyernAddress[msg.sender].buyerId,buyernAddress[msg.sender].compName, buyernAddress[msg.sender].regPin , msg.sender, _estAmount, block.timestamp);
    }

//function to buy CARBZ tokens
function getCarbz(uint _amount) public {
    _mint(msg.sender, _amount);
    emit minted(msg.sender, _amount);
}

//function to get Carbon Credits from address
    function getCarbonCredits( address _myadd) public view returns(boughtCredit memory){
        return boughtCreditsAddress[_myadd]; 
    }



    //function to get struct from address
    function getStruct(address _myaddress) public view returns (Result memory) {
        for(uint i = 0; i < totalcompany; i++){
            if(buyers[i].buyerAdd == _myaddress){
                return Result(StructType.Buyer, buyers[i].buyerAdd, abi.encode(buyers[i]));
            }
        }
        for(uint j = 0; j < totalOffsetters; j++){
            if(offSetternId[j].offsetterAdd == _myaddress){
                return Result(StructType.Offsetter, offSetternId[j].offsetterAdd, abi.encode(offSetternId[j]));
            }
        }
        for(uint k = 0; k < totalValidators; k++){
            if(validatornId[k].validatorAdd == _myaddress){
                return Result(StructType.Validator, validatornId[k].validatorAdd, abi.encode(validatornId[k]));
            }
        }
        return Result(StructType.None, address(0), "");
    }

    //function to get offsetter details from address
    function getOffsetter(address _myaddress) public view returns(Offsetter memory){
        return offSetternAddress[_myaddress];
    }

    //function to get all offsetters
    function getOffsetters() public view returns(Offsetter[] memory){
        return offsetters;
    }

    //function to gett all buyers
    function getBuyers() public view returns(Buyer[] memory){
        return buyers;
    }

    //function to get buyer details from address
    function getBuyer(address _myaddress) public view returns(Buyer memory){
        return buyernAddress[_myaddress];
    }

    //function to get validator details from address
    function getValidator(address _myaddress) public view returns (validator memory){
        return validatornAddress[_myaddress];
    }

     //function to get buyers credits
    function myCredits(uint [] memory _carbonIds) public view returns(boughtCredit[] memory){
        boughtCredit[] memory _boughtCredits = new boughtCredit[](_carbonIds.length);
        for(uint i = 0; i < _carbonIds.length; i++){
            _boughtCredits[i] = boughtCreditsId[_carbonIds[i]];
        }
        return _boughtCredits;        
    }

    //function to check if an address is registered
    function registeredBuyer( address _myadd) public view returns(bool){
    for (uint i=0; i < totalcompany; i++ ){
    if( buyernId[i].buyerAdd == _myadd ){
    return true;
    }
    }
    return false;}

    //function to check if an address is registered
    function registeredOffsetter( address _myadd) public view returns(bool){
    for (uint i=0; i < totalOffsetters; i++ ){
    if( offSetternId[i].offsetterAdd == _myadd){
    return true;
    }
    }
    return false;
    }

    //function to check if an address is registered validator
    function registeredValidator( address _myadd) public view returns(bool){
    for (uint i=0; i < totalValidators; i++ ){
    if( validatornId[i].validatorAdd == _myadd){
    return true;
    }
    }
    return false;}
  

    //modifier for onlyOwner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

}


   

