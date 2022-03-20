// SPDX-License-Identifier: GPL-3.0

/// @title The Cheetah DAO ERC-721 token

/*********************************

█▀▀ █░█ █▀▀ █▀▀ ▀█▀ ▄▀█ █░█   █▀▄ ▄▀█ █▀█
█▄▄ █▀█ ██▄ ██▄ ░█░ █▀█ █▀█   █▄▀ █▀█ █▄█

 *********************************/

pragma solidity ^0.8.4;

import 'erc721a/contracts/extensions/ERC721ABurnable.sol';
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CheetahGang is ERC721A, Ownable, ERC721ABurnable {
    using SafeMath for uint;
    address public Treasury;
    IERC20 public CHEETAH;
    string private _baseURIextended;
   

    constructor(address _cheetah, address _treasury) ERC721A('CheetahDAO', 'CGDT') {
        CHEETAH = IERC20(_cheetah);
        Treasury = _treasury;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }    

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function safeMint(address to, uint256 quantity) public onlyOwner {
        require(_totalMinted().add(quantity) < 406, "There aren't enough tokens left to mint!");
        _safeMint(to, quantity);
    }

    function mint(uint256 quantity_) public {
        uint priceToPay = quantity_.mul(10);
        uint balance = CHEETAH.balanceOf(msg.sender);
        uint256 allowance = CHEETAH.allowance(msg.sender, address(this));

        require(_totalMinted().add(quantity_) < 406, "There aren't enough tokens left to mint!");
        require(balance >= priceToPay, "There isn't enough $CHEETAH in your wallet!");
        require(allowance >= priceToPay, "Check the token allowance!");      
        require(CHEETAH.transferFrom(msg.sender, Treasury, priceToPay));

        _safeMint(msg.sender, quantity_);

    }    
    
    function getOwnershipAt(uint256 index) public view returns (TokenOwnership memory) {
        return _ownerships[index];
    }

    function totalMinted() public view returns (uint256) {
        return _totalMinted();
    }
}

 