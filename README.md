# 🗳️ web3-votesystem-contract-V2--05 – VoteSystem V2 Smart Contract in Solidity

This project is a smart contract written in Solidity that simulates a decentralized proposal voting system. It allows an admin to create proposals, enables users to vote only once per proposal, and determines a winner. It was developed for educational purposes as part of the journey into Web3 development using Foundry.

---

## 🚀 Key Features

- ✅ Only the **contract owner** can create or update proposals.
- 🗳️ Each address can vote only **once** per proposal.
- 📛 Prevents proposals with **duplicate titles**.
- 🧾 Admin can **open or close** the voting process.
- 📊 Returns the **winning proposal** based on total votes.
- 🔍 Includes **unit tests** and **fuzzing tests** using Foundry.
- ⚙️ Modular and readable contract structure for easy understanding.

---

## 🧠 Proposal Handling

The contract stores each proposal in a struct containing a title, body, and vote count:

- Proposals are created with `createProposal(title, body)` by the owner.
- Users vote using `voteProposal(index)` only when voting is open.
- Admin can modify the body of a proposal with `updateProposalBody(body, index)`.
- The winning proposal can be fetched using `getProposalWinner()`.

---

## ⚙️ How to Deploy and Test (Foundry)

### 1. Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. Clone and build the project

```bash
git clone https://github.com/your-username/votesystem-foundry.git
cd votesystem-foundry
forge install
forge build
```

### 3. Run all tests

```bash
forge test -vvvv
```

### 4. Run a specific test

```bash
forge test --match-test testCreateProposalByOwnerSucceed -vvvv
```

🧪 Fuzzing tests are automatically executed for functions with parameters (like title/body strings).

---

## 🔘 Available Functions

| Function                                      | Description                                           |
|----------------------------------------------|-------------------------------------------------------|
| `createProposal(string title, string body)`   | Creates a new proposal (admin only)                   |
| `updateProposalBody(string body, uint index)` | Updates the body of an existing proposal (admin only) |
| `voteProposal(uint index)`                    | Allows a user to vote for a proposal                  |
| `getProposalWinner()`                         | Returns the current winner (title and vote count)     |
| `changeOpeningStatus()`                       | Opens or closes the voting session (admin only)       |
| `hasVoted(address user)`                      | Returns true if the user already voted                |


## 🧪 Tests Coverage 100%

### ✅ Unit Tests

- Proposal creation (admin success, duplicate title, non-owner fail)
- Proposal update (valid index, invalid index, unauthorized user)
- Voting behavior (single vote, double vote revert, voting closed)
- Winner calculation (correct winner returned, empty proposal list returns "None")

### 🔀 Fuzzing Tests

- Random titles and bodies tested for proposal creation logic
- Strings edge cases (empty, long, special characters)
- Boundary testing for voting inputs

---

## 📄 Example Use Cases

- Governance system for decentralized communities or DAOs
- Classroom demo for access control and testing in Solidity
- Lightweight alternative to full DAO frameworks
- Base contract for extended governance logic with quorum or deadlines

---

## 📦 Technologies

- Solidity ^0.8.24
- Foundry (Forge + Anvil)
- forge-std for unit/fuzz testing
- `vm.prank`, `vm.expectRevert`, `vm.assume` for testing control

---

## ✍️ Author

Developed by **Marcos Pérez Gómez**  
Smart contract developer and fullstack Web3 builder.

This is one of the core Web3 projects included in his portfolio, focused on governance logic, access control, and smart contract testing with Foundry.

---

## 📜 License

This project is licensed under the **MIT License**.

