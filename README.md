# Voting System Smart Contract

## Overview
This smart contract is designed to manage a flexible voting system on the Ethereum blockchain. It allows an admin (typically the deployer) to create multiple votes, each with its own set of options and eligible voters. The system supports adding voters, casting votes, and retrieving vote results.

## Features
Admin Management: Only the admin can create votes and add voters.
Dynamic Vote Creation: Votes can be created at any time with a custom set of options.
Voter Validation: Ensures that only registered and eligible voters can cast votes.
Result Retrieval: Allows fetching the results of a vote to see how many votes each option received.

## Smart Contract Methods
createVote: Admin can create a vote specifying its duration, options, and eligible voters.
addVoter: Admin can add a new voter to an existing vote.
castVote: Registered voters can cast their vote for a specific option.
getVoteResults: Retrieve the total counts of votes for each option in a vote.

## Important Considerations
Ensure that the contract is used by Ethereum's gas and timing constraints.
Test thoroughly on a testnet before deploying to the mainnet to avoid costly errors.
