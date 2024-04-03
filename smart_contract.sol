// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//import "hardhat/console.sol";

contract VotingSystem {

    struct Voter { //The data will be taken from the voter account 
        address addressVoter; 
        bool isRegistered; //if true, that person registered
        bool hasVoted; //if true, that person already voted
        uint voteIndex; //index of the voted proposal
    }

    struct Option { 
        string optionName;
        uint countOption; // How many votes have this option
    }

    struct Vote { //Data about the vote 
        string voteName; 
        uint voteID;
        uint startVoteTime; //contains the date when the contract is created
        uint endVoteTime; //contains the date when the contract expires
        mapping(uint => Option) options; //mapping of the vote options -> optionID => Option
        mapping(address => Voter) voters; // add here to ones that can vote
    }

    modifier onlyAdmin{ //Calling specific functions for the admin
        require(msg.sender == admin,"Only the Administrator allowed make this action");
        _;
    }

    modifier onlyVoter{ //Calling specific functions for the voter
        require(msg.sender != admin,"Only the voter allowed make this action");
        _;
    }

    // ************************************ global variables ************************************
    address admin; // the owner of the contract
    Vote vote; // object Vote, save all the information of the vote to be voted in it

    // ************************************ constructor ****************************************************
    // initialize the data of the vote that we select to be voted 
    constructor(string[] memory voting_options, uint voteID, string memory voteName, uint startTime, uint duration){

        //duration = the time that the vote will be available to be voted
        //StartTime = the time that the vote will be available to be voted
        admin = msg.sender; //the admin is the owner of the contract

        //initializing the vote data to be voted
        vote.voteID = voteID;
        vote.voteName = voteName; 

        //initializing the expiration contract
        uint startVoteTime = block.timestamp + startTime; //time starting contract
        vote.startVoteTime = startVoteTime; //time starting contract
        vote.endVoteTime = startVoteTime + duration; //time ending contract

        //initializing the data of options
        for(uint i = 0; i < voting_options.length; i++){
            vote.voteOptions[i] = Option(voting_options[i], 0);
        }
        
    }

    //************************************ function ***************************************

    // 1.addVoter - the admin only adds a new voter to the voting system (Vote struct). 
    //the function should receive as input the address of the new voter
    //function to add the voters to the vote
    //** initialize voters  -- need to fix ASAP
    function addVoter() public view onlyAdmin {
         Voter memory voter;//creating a voter to be saved after in the data structure where all the voters are saved.
        require(block.timestamp < vote.endVoteTime, "Voting time has ended.");
        //checking if the data voter has bee initialized by the system
        require(!voter.isRegistered(msg.sender), "The voter exist already at the system.");

        //initializing the data of the new voter
        voter.addressVoter = msg.sender;
        voter.hasVoted = false;
        //newVoter.IamReady = false;
        voter.hasVoted[msg.sender] = false;
        
        //updating the data Structures
        //votersAtSystem[msg.sender] = voter;
        //adresssVoter.push(msg.sender);
        voter = voter; //making an instance of the new voter for the voting.
    }


    // 2.createVote - the user voter only votes in the voting system. 
    //the function should receive as input the option id.
    function createVote(string memory _voteName, uint _startTime, uint _endTime, string[] memory _optionNames) public onlyAdmin {
        require(!vote.exists, "A vote is already ongoing");
        require(_endTime > _startTime, "End time must be after start time");

        delete vote; //Reset the current vote
        vote.voteName = _voteName;
        vote.startTime = _startTime;
        vote.endTime = _endTime;
        vote.exists = true;

        for (uint i = 0; i < _optionNames.length; i++) {
            vote.options.push(Option({name: _optionNames[i], voteCount: 0}));
        }
    }

    // 3.getVoteResults - either admin or voter can call this function. 
    //it will return the counter for each vote
    //Function to retrieve the vote results.
    //return An array of vote counts corresponding to each vote option.
    function getVoteResults() public view onlyAdmin returns (uint[] memory) {
        uint[] memory voteCounts = new uint[](Option); // Initialize with the actual number of options.
        
        for (uint i = 0; i < vote.voterAddresses.length; i++) {
            address voterAddress = vote.voterAddresses[i];
            uint voteIndex = vote.voters[voterAddress].voteIndex;
            voteCounts[voteIndex] += 1; // Increment the vote count for the chosen option.
        }
        return voteCounts;
    }

    // Function for voters to cast their vote.
    // voteIndex - The index of the vote option chosen by the voter.
    function castVote(uint voteIndex) public onlyVoter {
        require(vote.exists, "There is no active vote.");
        require(block.timestamp >= vote.startTime && block.timestamp <= vote.endTime, "Voting is not active.");
        // require(voterExist[msg.sender].isRegistered, "Voter is not registered.");
        // require(!voterExist[msg.sender].hasVoted, "Voter has already voted.");
        
        // Record the vote
        vote.voters[msg.sender].hasVoted = true;
        vote.voters[msg.sender].voteIndex = voteIndex;
    }

}