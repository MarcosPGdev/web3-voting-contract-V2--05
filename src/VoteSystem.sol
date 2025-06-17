// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract VoteSystem {
    //variables
    address public owner;
    bool public isOpen;

    struct Proposal {
        string title;
        string body;
        uint256 voteCount;
    }

    Proposal[] public proposals;

    mapping(address => bool) public voted;
    mapping(string => bool) public proposalTitles;

    //modifiers
    
    modifier OnlyOwner (){
        require(owner == msg.sender, "Only the owner can send a Proposal.");
        _;
    }

    modifier TitleAvailable  (string memory _title){
        require(!proposalTitles[_title], "The title is unabiable");
        _;
    }

    modifier CheckAddressVoted (){
        require(!voted[msg.sender], "User already voted");
        _;
    }

    modifier VotingIsOpen (){
        require(isOpen, "Proposals are closed");
        _;
    }

    modifier CheckProposalIndex (uint256 _proposalIndex){
        require(_proposalIndex < proposals.length, "Invalid proposal index");
        _;
    }

    //events

    event ProposalCreated (string _title, string _body);
    event Voted(address voter, uint256 proposalIndex);
    event UpdatedProposal(string body, uint256 index);

    //functions

    constructor (address _admin){
        owner = _admin;
        isOpen = true;
    }

    function createProposal (string memory _title, string memory _body) public OnlyOwner TitleAvailable (_title) {
        proposals.push(Proposal(_title,_body,0));
        proposalTitles[_title] = true;
        emit ProposalCreated  (_title , _body);
    }

    function updateProposalBody (string memory _body, uint256 _proposalIndex) public OnlyOwner CheckProposalIndex(_proposalIndex) {
        proposals[_proposalIndex].body = _body;
        emit UpdatedProposal(_body, _proposalIndex);
    }

    function voteProposal (uint256 _proposalIndex) public CheckAddressVoted VotingIsOpen CheckProposalIndex(_proposalIndex) {
        proposals[_proposalIndex].voteCount += 1;
        voted[msg.sender] = true;
        emit Voted(msg.sender, _proposalIndex);
    }

    function getProposalWinner () public view returns(string memory, uint256 voteCount){
        string memory _winner = "None";
        uint256 maxVotes = 0;
        for(uint256 i = 0 ; i < proposals.length; i++){
            if (proposals[i].voteCount > maxVotes) {
                _winner = proposals [i ].title;
                maxVotes = proposals[i].voteCount;
            }
        }

        return (_winner, maxVotes);
    }

    function changeOpeningStatus () public OnlyOwner {
        isOpen = !isOpen;
    }
}