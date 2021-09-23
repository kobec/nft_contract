//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/utils/Counters.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";

contract SNFT is ERC721/*, Ownable*/ {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NftBought(address _seller, address _buyer, uint256 _price);

    mapping (uint256 => uint256) public tokenIdToPrice;
    mapping (uint256 => address) public tokenIdToTokenAddress;

    constructor() ERC721("SNFT", "NFT") {}

    function mintNFT(address recipient, string memory tokenURI)
    public/* onlyOwner*/
    returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    ////////
    function setPrice(uint256 _tokenId, uint256 _price, address _tokenAddress) external {
      //  require(msg.sender == ownerOf(_tokenId), 'Not owner of this token'+msg.sender+ownerOf(_tokenId));
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "ERC721: setPrice caller is not owner nor approved");
        tokenIdToPrice[_tokenId] = _price;
        tokenIdToTokenAddress[_tokenId] = _tokenAddress;
    }

    function getTokenPrice(uint256 _tokenId) public view returns (uint256){
        return tokenIdToPrice[_tokenId];
    }

    function allowBuy(uint256 _tokenId, uint256 _price) external {
        //require(msg.sender == ownerOf(_tokenId), 'Not owner of this token');
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "ERC721: allowBuy caller is not owner nor approved");
        require(_price > 0, 'Price zero');
        tokenIdToPrice[_tokenId] = _price;
    }

    function disallowBuy(uint256 _tokenId) external {
        //require(msg.sender == ownerOf(_tokenId), 'Not owner of this token');
        require(_isApprovedOrOwner(_msgSender(), _tokenId), "ERC721: disallowBuy caller is not owner nor approved");
        tokenIdToPrice[_tokenId] = 0;
    }

    function buy(uint256 _tokenId) external payable {
        uint256 price = tokenIdToPrice[_tokenId];//get token price from storage
        require(price > 0, 'This token is not for sale');//check price > 0
        require(msg.value == price, 'Incorrect value');//check received amount equals token price
        address seller = ownerOf(_tokenId);//get owner address
        /*address tokenAddress = tokenIdToTokenAddress[_tokenId];
        if(tokenAddress != address(0)){
            IERC20 tokenContract = IERC20(ztokenAddress);
            require(tokenContract.transferFrom(msg.sender, address(this), price),
                "buy: payment failed");
        } else {
            payable(seller).transfer(msg.value);
        }*/
        payable(seller).transfer(msg.value);//send received money to the seller
        _transfer(seller, _msgSender(), _tokenId);//transfer token to the buyer
        tokenIdToPrice[_tokenId] = 0;//reset token price
        emit NftBought(seller, msg.sender, msg.value);
    }
}
