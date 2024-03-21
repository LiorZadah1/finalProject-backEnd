// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {

    struct Voter { //The data will be taken from the voter account 
        address addressVoter; 
        bool isRegistered; //if true, that person registered
        bool hasVoted; //if true, that person already voted
        uint voteIndex; //index of the voted proposal
    }

    struct Vote { //Data about the vote 
        string voteName; 
        uint voteID;
        uint startTime; 
        uint endTime; 
        mapping(address => Voter) voters;
        address[] voterAddresses; //for admin to view votes
        bool exists;
        bool creatVote;
    }

    modifier OnlyAdmin{ //Calling specific functions for the admin
        require(msg.sender == admin,"Only the Administrator allowed make this action");
        _;
    }

    modifier OnlyVoter{ //Calling specific functions for the voter
        require(msg.sender != admin,"Only the voter allowed make this action");
        _;
    }

    // global variables 
    address admin; //will contain the owner contract address 
    Vote newVote; //object Vote, save all the information of the vote to be voted in it
    Voter newVoter; //current voter we are using
    address[] addressOfVoters;

    mapping(address => bool) voterHasVoted; //check if the voter has vote already
    mapping (string =>uint) votes; //contains the counters voting for every date
    mapping(address => Voter) voterExist; //save the voter exist in the system

    uint dateCreatedContract; //contains the date when the contract is created
    uint dateExpiringContract; //contains the date when the contract expires


    // constructor 
    // initialize the data of the vote that we select to be voted 
    constructor(string[] memory voting_options, uint voteID, string memory voteName, uint expiration){// the admin give the data
        require((_voteID != 0) && (bytes(_voteName).length != 0), "Please fill all the fields");//אין צורך 
        admin = msg.sender;
        uint num_dates = 0;

        while(num_dates < dates.length){ //This loop put the dates in the array "voting_Dates"
            voting_Dates.push(dates[num_dates]); //coping the input dates to the array dates 
            votes[dates[num_dates]] = 0; //creating the map that will save the votes to the different dates
            num_dates++;
        }

        //initializing the vote data to be voted
        newVote.voteID = _voteID;
        newVote.voteName = _voteName; 

        //initializing the expiration contract
        dateCreatedContract = block.timestamp; //time starting contract
        dateExpiringContract = expiration; //time caducity contract
    }

    //function
    function createVote(string memory _voteName, uint _startTime, uint _endTime, string[] memory _optionNames) public onlyAdmin {
        require(!currentVote.exists, "A vote is already ongoing");
        require(_endTime > _startTime, "End time must be after start time");

        delete currentVote; //Reset the current vote
        currentVote.voteName = _voteName;
        currentVote.startTime = _startTime;
        currentVote.endTime = _endTime;
        currentVote.exists = true;

        for (uint i = 0; i < _optionNames.length; i++) {
            currentVote.options.push(Option({name: _optionNames[i], voteCount: 0}));
        }
    }

    function printDataCourse() public view {//this function prints the vote to be voted 
        console.log("The vote that you are voting is:");
        console.log("The name of the vote: %s",newVote.voteName);
        console.log("Id vote: %s", newVote.voteID);
    }


    //initialize voters date 
    function create_voter() public OnlyVoter{ 
        //checking the expiration contract
        require(!timeForVotingIsOver(),"SORRY, The time for voting it's over. Please contact with the Admin");
        
        //checking if the data voter has bee initialized by the system
        require(!voterAlreadyCreated(msg.sender), "The voter exist already at the system.");
        
        Voter memory new_voter;//creating a voter to be saved after in the data structure where all the voters are saved.
        
        //initializing the data of the new voter
        new_voter.addressVoter = msg.sender;
        new_voter.hasVoted = false;
        //newVoter.IamReady = false;
        voterHasVoted[msg.sender] = false;
        
        //updating the data Structures
        votersAtSystem[msg.sender] = new_voter;
        adresssVoter.push(msg.sender);
        newVoter = new_voter; //making an instance of the new voter for the voting.
    }


    /**
    * @dev Function for voters to cast their vote.
    * @param voteIndex The index of the vote option chosen by the voter.
    */
    function castVote(uint voteIndex) public OnlyVoter {
        require(newVote.exists, "There is no active vote.");
        require(block.timestamp >= newVote.startTime && block.timestamp <= newVote.endTime, "Voting is not active.");
        require(voterExist[msg.sender].isRegistered, "Voter is not registered.");
        require(!voterExist[msg.sender].hasVoted, "Voter has already voted.");
        
        // Record the vote
        newVote.voters[msg.sender].hasVoted = true;
        newVote.voters[msg.sender].voteIndex = voteIndex;
    }

    /**
    * @dev Function to retrieve the vote results.
    * @return An array of vote counts corresponding to each vote option.
    */
    function getVoteResults() public view OnlyAdmin returns (uint[] memory) {

        uint[] memory voteCounts = new uint[](numberOfOptions); // Initialize with the actual number of options.
        
        for (uint i = 0; i < newVote.voterAddresses.length; i++) {
            address voterAddress = newVote.voterAddresses[i];
            uint voteIndex = newVote.voters[voterAddress].voteIndex;
            voteCounts[voteIndex] += 1; // Increment the vote count for the chosen option.
        }
        
        return voteCounts;

    }
}