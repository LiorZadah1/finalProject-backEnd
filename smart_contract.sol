// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//import "hardhat/console.sol";

contract VotingSystem {

    struct Voter { //The data will be taken from the voter account 
        address addressVoter; 
        bool isRegistered; //if true, that person registered
        bool hasVoted; //if true, that person already voted
        uint voteIndex; //index of the voted proposal
        uint groupId; //group id of the voter
    }

    struct Option { 
        string optionName;
        uint countOption; // How many votes have this option
    }

    struct Group {
    uint groupId;
    string groupName;
    }

    struct Vote { //Data about the vote 
        string voteName; 
        uint voteID;
        uint startVoteTime; //contains the date when the contract is created
        uint endVoteTime; //contains the date when the contract expires
        mapping(uint => Option) options; //mapping of the vote options -> optionID => Option
        mapping(address => Voter) voters; // add here to ones that can vote
        uint groupId; // Add this to associate the vote with a specific group
    }

    modifier onlyAdmin{ //Calling specific functions for the admin
        require(msg.sender == admin,"Only the Administrator allowed make this action");
        _;
    }
    modifier onlyVoter{ //Calling specific functions for the voter
        require(msg.sender != admin,"Only the voter allowed make this action");
        _;
    }

    // ************************************ Global variables ************************************
    address admin; // the owner of the contract
    Vote vote; // object Vote, save all the information of the vote to be voted in it
    mapping(uint => Vote) public votes; // Mapping of voteID to Vote ---> not sure
    mapping(uint => uint[]) public votesByGroup; // Mapping of groupID to voteID


    // ************************************ Constructor ****************************************************
    // initialize the data of the vote that we select to be voted 
    constructor(string[] memory voting_options, uint voteID, string memory voteName, uint startTime, uint duration, uint groupId){
        //duration = the time that the vote will be available to be voted
        //StartTime = the time that the vote will be available to be voted
        admin = msg.sender; //the admin is the owner of the contract
        //initializing the vote data to be voted
        vote.voteID = voteID;
        vote.voteName = voteName; 
        vote.groupId = groupId; // Set the group for the vote
        //initializing the expiration contract
        uint startVoteTime = block.timestamp + startTime; //time starting contract
        vote.startVoteTime = startVoteTime; //time starting contract
        vote.endVoteTime = startVoteTime + duration; //time ending contract
        //initializing the data of options
        for(uint i = 0; i < voting_options.length; i++){
            vote.options[i] = Option(voting_options[i], 0);
        }   
    }

    //************************************ Functions ****************************************************
    // 1.addVoter - the admin only adds a new voter to the voting system (Vote struct). 
    //the function should receive as input the address of the new voter
    //function to add the voters to the vote
    //** initialize voters  -- need to fix ASAP
    function addVoter(uint voteID, address voterAddress, uint groupId) public onlyAdmin {
        //Voter memory voter;//creating a voter to be saved after in the data structure where all the voters are saved.
        require(block.timestamp < vote.endVoteTime, "Voting time has ended.");
        //checking if the data voter has bee initialized by the system
        require(!votes[voteID].voters[msg.sender].isRegistered, "The voter exist already at the system.");
        //initializing the data of the new voter
        vote.voters[voterAddress] = Voter({
        addressVoter: voterAddress,
        isRegistered: true,
        hasVoted: false,
        voteIndex: 0,
        groupId: groupId // Set the voter's group
        });
    }

    // 2.getVoteResults - either admin or voter can call this function. 
    //it will return the counter for each vote
    //Function to retrieve the vote results.
    //return An array of vote counts corresponding to each vote option.
    function getVoteResults(uint voteID, uint optionsCount) public view returns (uint[] memory) {
        uint[] memory voteCounts = new uint[](optionsCount); // Initialize with the actual number of options.
        
        // Iterate over each option in the vote and fetch its 'countOption'
        for (uint i = 0; i < optionsCount; i++) {
            voteCounts[i] = votes[voteID].options[i].countOption;
        }
        return voteCounts;
    }


    // Function for voters to cast their vote.
    // voteIndex - The index of the vote option chosen by the voter.
    function castVote(uint voteID, uint optionIndex) public {
        require(votes[voteID].voters[msg.sender].isRegistered, "Voter is not registered for this vote.");
        require(!votes[voteID].voters[msg.sender].hasVoted, "Voter has already voted.");
        require(block.timestamp >= votes[voteID].startVoteTime && block.timestamp <= votes[voteID].endVoteTime, "Voting is not currently active.");
        // check if the voter is part of the group for this vote
        require(votes[voteID].groupId == votes[voteID].voters[msg.sender].groupId, "Voter is not part of the group for this vote.");

        // Record the voter's choice
        votes[voteID].voters[msg.sender].hasVoted = true;
        votes[voteID].voters[msg.sender].voteIndex = optionIndex;

        // Increment the vote count for the chosen option
        votes[voteID].options[optionIndex].countOption += 1;
    }
}