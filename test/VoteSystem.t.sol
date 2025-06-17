// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "forge-std/Test.sol";
import {VoteSystem} from "../src/VoteSystem.sol";

// Test contract for the VoteSystem smart contract
contract VoteSystemTest is Test {
    VoteSystem public voteSystem;

    address admin = msg.sender;
    address randomUser = vm.addr(2);

    // This function runs before each test
    function setUp() public {
        voteSystem = new VoteSystem(admin);
    }

    // Should revert if a non-owner tries to create a proposal
    function testCreateProposalByNonOwnerReverts() public {
        vm.startPrank(randomUser);

        string memory _title = "Title";
        string memory _body = "Body";
        vm.expectRevert();
        voteSystem.createProposal(_title, _body);

        vm.stopPrank();
    }

    // Should revert if trying to create a proposal with a duplicated title
    function testCreateProposalWithDuplicatedTitleReverts() public {
        vm.startPrank(admin);

        voteSystem.createProposal("Title", "First try");
        vm.expectRevert();
        voteSystem.createProposal("Title", "Second try");

        vm.stopPrank();
    }

    // Should succeed if the owner creates a proposal
    function testCreateProposalByOwnerSucceed() public {
        vm.startPrank(admin);

        string memory _title = "Title";
        string memory _body = "Body";
        voteSystem.createProposal(_title, _body);

        vm.stopPrank();
    }

    // Fuzzing test: should allow any title/body combination by the owner
    function testCreateProposalFuzz(string memory _title, string memory _body) public {
        vm.startPrank(admin);

        voteSystem.createProposal(_title, _body);

        vm.stopPrank();
    }

    // Should revert if a non-owner tries to update a proposal body
    function testUpdateProposalBodyByNonOwnerReverts() public {
        vm.startPrank(randomUser);

        string memory _body = "Body";
        uint256 _index = 0;
        vm.expectRevert();
        voteSystem.updateProposalBody(_body, _index);

        vm.stopPrank();
    }

    // Should revert if trying to update a non-existing proposal
    function testUpdateProposalBodyByNonIndexExists() public {
        vm.startPrank(admin);

        string memory _body = "Body";
        uint256 _index = 1; // No proposal exists at index 1
        vm.expectRevert();
        voteSystem.updateProposalBody(_body, _index);

        vm.stopPrank();
    }

    // Should allow the owner to update a proposal body successfully
    function testUpdateProposalBodyByOwnerSucceed() public {
        vm.startPrank(admin);

        string memory _title = "Title";
        string memory _body = "Body";
        string memory _newBody = "Body2";
        voteSystem.createProposal(_title, _body);
        uint256 _index = 0;

        voteSystem.updateProposalBody(_newBody, _index);

        vm.stopPrank();
    }

    // Should revert if a user tries to vote twice on the same proposal
    function testVoteProposalAddresHasVotedRevert() public {
        vm.startPrank(admin);

        voteSystem.createProposal("Title", "First try");
        voteSystem.voteProposal(0);
        vm.expectRevert();
        voteSystem.voteProposal(0);

        vm.stopPrank();
    }

    // Should revert if voting is closed
    function testVoteProposalClosedRevert() public {
        vm.startPrank(admin);

        voteSystem.createProposal("Title", "First try");
        voteSystem.changeOpeningStatus(); // Close voting
        vm.expectRevert();
        voteSystem.voteProposal(0);

        vm.stopPrank();
    }

    // Should revert if trying to vote on a non-existing proposal
    function testVoteProposalInvalidIndexRevert() public {
        vm.startPrank(admin);

        vm.expectRevert();
        voteSystem.voteProposal(0);

        vm.stopPrank();
    }

    // Should return "None" and 0 if there are no proposals
    function testGetWinnerReturnsNoneIfNoProposals() public {
        (string memory winner, uint256 count) = voteSystem.getProposalWinner();
        assertEq(winner, "None");
        assertEq(count, 0);
    }

    // Should return the proposal with the most votes as winner
    function testGetWinnerReturnsCorrectProposal() public {
        vm.startPrank(admin);
        voteSystem.createProposal("A", "Body1");
        voteSystem.createProposal("B", "Body2");
        vm.stopPrank();

        vm.startPrank(randomUser);
        voteSystem.voteProposal(1); // Vote for proposal B
        vm.stopPrank();

        (string memory winner, uint256 count) = voteSystem.getProposalWinner();
        assertEq(winner, "B");
        assertEq(count, 1);
    }
}
