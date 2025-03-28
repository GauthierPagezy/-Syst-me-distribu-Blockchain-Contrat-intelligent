// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;

import "./Ownable.sol";
import "./SafeMath.sol";

contract Election is Ownable {
    using SafeMath for uint256;

    struct Candidate {
        uint256 id;
        string name;
        uint voteCount;
    }

    mapping(address => bool) public voters;

    mapping(uint => Candidate) public candidates;

    uint public candidatesCount;

    mapping(address => bool) public whitelist;

    event votedEvent(uint indexed _candidateId);

    function addToWhitelist(address _addr) public onlyOwner {
        whitelist[_addr] = true;
    }

    function addCandidate(string memory _name) public {
        require(whitelist[msg.sender], "Adresse non autorisee a ajouter un candidat");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "Vous avez deja vote");

        require(_candidateId > 0 && _candidateId <= candidatesCount, "Candidat invalide");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        emit votedEvent(_candidateId);
    }
}
