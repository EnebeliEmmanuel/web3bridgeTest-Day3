// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./IERC721.sol";

/// @title creating an auction market place where we have seller and bidders, we will be using an Nft
/// @author Kokocodes
/// @dev Contract emits when the start of bid events in logic
/// @dev Contract emits bid events in logic
/// @dev Contract emits withdraw events in logic
/// @dev Contract emits ownershipTransfer events in logic
/// @dev All function calls are currently implemented without side effects
contract auctionMarketplace{




 ///======================= EVENTS & ERRORS ==============================
   
  /// you dont have this access, you be thief
  error Unauthorized();

  /// this function has already been invoked
  error alreadyStarted();

  /// this Auction hasnt started
  error notStarted();

  /// value is less than highest bid  
  error  InsufficientValue();


  /// Already ended  
  error  alreadyEnded();

  /// Auction never end na, try dey calm down
  error  auctionNotEnded();


    
    event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner,
    uint boredApeId
    );
    event LogAuction();
    event LogBid(address indexed sender, uint amount);
    event LogWithdraw(address indexed bidder, uint amount);
    event LogEndAuction(address winner, uint amount);

  //Variables
  //static  variable (it wont change over the life of the contract)
   IERC721 public immutable boredApe; // to store the nft am selling which in this case is boredApe 
   uint public immutable boredApeId; // to store the id of the nft that i am selling 
   address payable public immutable owner; //dont want it being changed and also want it to accept ether when the auction ends
   uint32 public endAt; // uint32 can store up to 100 years from now so this is sufficient
   bool public started;// will be set to true when the auction starts
   bool public ended;// will be set to true when the auction ends
  

  // state variables relevant to the biders (the ones that will change)
    address public highestBidder; // address of the highest bidder
    uint public highestBid; // amount of highest bidder.

   /**
   *@notice mapping to keep account of the users whose bid were outbided
   */
    mapping(address => uint) public bids; 

    constructor (address _boredApe, uint _boredApeId, uint _startingBid )  {
      /**
       * @dev sets state variable to true
       */
      boredApe = IERC721(_boredApe); // typcasting _boredApe to IERC721
      boredApeId = _boredApeId;
      owner = payable(msg.sender); // ensures that the owner is equal to the deployer and can also accept ether
      highestBid = _startingBid;// setting the current highest bid to the starting bid.
    } 



   
  // SET FUNCTIONS (CHANGE STATE)
  function Auction() external {
    //we only want this auction function to be called only once 
      if (started == true ){
         revert alreadyStarted();
        }
       
    if(msg.sender != owner){
       revert Unauthorized();
    }
      

      /**
       * @dev performes transferFrom from the owner of the nft to the contract
       */
      boredApe.transferFrom(msg.sender, address(this), boredApeId);
        
      /**
       * @dev sets state variable to true
       */
        started = true;
        endAt = uint32(block.timestamp + 60);

        emit LogAuction();
    }


    /**
    *@notice once the auction starts then users can bid
    */
    function bid() external payable {
        if(!started){
         revert notStarted(); // checkes again if the auction has started
        }

         if (block.timestamp > endAt){
           revert alreadyEnded();
        }
     
       
        if(msg.value < highestBid){
         revert InsufficientValue();
        }

// we will reference back to our mapping here 
// take note when the first bidder calls this function the highest bidder will be address 0 
// so w will have to check for that again
     if (highestBidder != address(0)) { // here we ensure that the highest bidder is not equal to address 0 before setting the state variable
          bids[highestBidder] += highestBid; // this keeps track of all the bids that were outbid and later one they can withdraw
        }

       /**
       * @dev sets state variables 
       */
        highestBidder = msg.sender;
        highestBid = msg.value;
        
      
      /**
       * @dev emits events of for users bids
       */
        emit LogBid(msg.sender, msg.value);
    }

  

    
      /**
       * @notice view function to see the current balnce of the contract 
       */
    function getBalance() public view returns(uint){
       return address(this).balance;
    }


      /**
       * @notice we have a function for users that are not the highest bidder to withdraw
       */
    function withdraw() external {
        uint bal = bids[msg.sender]; 
        bids[msg.sender] = 0; // resetting the bids balance mapping to 0 before sending to prevent reentrancy attack
        payable(msg.sender).transfer(bal);

        emit LogWithdraw(msg.sender, bal);
    }


      /**
       * @notice we have a function to end auction and it is not restricted to onlyOwner
       */
     function EndAuction() external {
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");

        ended = true;
        if (highestBidder != address(0)) {
            boredApe.safeTransferFrom(address(this), highestBidder, boredApeId);
            owner.transfer(highestBid);
             emit LogEndAuction(highestBidder, highestBid);
             emit OwnershipTransferred(address(this), highestBidder, boredApeId);
        } else {
           boredApe.safeTransferFrom(address(this), owner, boredApeId);
        }
    }
}