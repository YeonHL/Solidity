// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Minting is Ownable, ERC721, ERC721Enumerable, ERC721URIStorage{

    using SafeMath for uint256;
    uint public constant mintPrice = 0;


    // NFT 정보 저장 구조체 & 배열
    struct entertain {
        bool _isTicket;
        bool _isbid;
        string _date;
        string _place;
        string _companyinfo;
        string _celebrity;
        uint256 _ticketnumber;
    }

    entertain[] public entertains;


    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    constructor() ERC721("MinterET", "MET") {}
    function mintgoods(string memory _uri, string memory _companyinfo, string memory _celebrity) public payable onlyOwner{
        uint256 mintIndex = totalSupply();
        // msg.sender는 함수를 불러온 사람의 주소, mintIndex는 민팅한 NFT가 저장될 tokenid를 나타내며 이전에 만들어진 nft 번호와 겹치지 않도록 자동 설정
        _safeMint(msg.sender, mintIndex);
        // 앞에서 생성한 NFT에 uri 정보를 저장 
        _setTokenURI(mintIndex, _uri);
        // 마켓에서 사용할 기타 정보 입력, goods에서 사용하지 않을 변수는 null 처리
        entertains.push(entertain(false, false, "null","null",_companyinfo,_celebrity,0));
    }

    function mintticket(string memory _uri, string memory _date, string memory _place, string memory _companyinfo, string memory _celebrity, uint256 _ticketnumber) public payable onlyOwner{
        uint256 mintIndex = totalSupply();
        // msg.sender는 함수를 불러온 사람의 주소, mintIndex는 민팅한 NFT가 저장될 tokenid를 나타내며 이전에 만들어진 nft 번호와 겹치지 않도록 자동 설정
        _safeMint(msg.sender, mintIndex);
        // 앞에서 생성한 NFT에 uri 정보를 저장
        _setTokenURI(mintIndex, _uri);
        // 마켓에서 사용할 기타 정보 입력
        entertains.push(entertain(true, false, _date, _place, _companyinfo, _celebrity, _ticketnumber));
    }

    function delaymint(string memory _uri, uint256 _tickettokenID, uint256 _ticketnumber) public payable{
        require(entertains[_tickettokenID]._isTicket, "It isn't ticket");
        require(entertains[_tickettokenID]._ticketnumber == _ticketnumber, "Wrong ticket number");
        require(_exists(_tickettokenID), "ERC721: approved query for nonexistent token");

        uint256 mintIndex = totalSupply();

        // msg.sender는 함수를 불러온 사람의 주소, mintIndex는 민팅한 NFT가 저장될 tokenid를 나타내며 이전에 만들어진 nft 번호와 겹치지 않도록 자동 설정
        _safeMint(ownerOf(_tickettokenID), mintIndex);
        // 앞에서 생성한 NFT에 uri 정보를 저장 
        _setTokenURI(mintIndex, _uri);
        // 마켓에서 사용할 기타 정보 입력, goods에서 사용하지 않을 변수는 null 처리
        entertains.push(entertain(false, false, "null","null",entertains[_tickettokenID]._companyinfo,entertains[_tickettokenID]._celebrity,0));
    }

    function nftlist(uint256 _pagenumber) public view returns(string memory, string memory, string memory, string memory, string memory){
        require(_pagenumber > 0, "Wrong page number");

        uint256 mintIndex = totalSupply();

        require(mintIndex != 0, "NFT doesn't exist");

        uint256 _load_nft_number = 5*(_pagenumber-1);

        require(mintIndex > _load_nft_number, "Wrong page number");

        uint256 _left_number = mintIndex % 5;
        bool _less_than_five = (mintIndex - _load_nft_number < 5);

        if (_less_than_five && _left_number == 4){
            return (tokenURI(mintIndex - (_load_nft_number+1)),tokenURI(mintIndex - (_load_nft_number+2)),tokenURI(mintIndex - (_load_nft_number+3)),tokenURI(mintIndex - (_load_nft_number+4)),"null");
        }
        else if (_less_than_five && _left_number == 3){
            return (tokenURI(mintIndex - (_load_nft_number+1)),tokenURI(mintIndex - (_load_nft_number+2)),tokenURI(mintIndex - (_load_nft_number+3)),"null","null");
        }
        else if (_less_than_five && _left_number == 2){
            return (tokenURI(mintIndex - (_load_nft_number+1)),tokenURI(mintIndex - (_load_nft_number+2)),"null","null","null");
        }
        else if (_less_than_five && _left_number == 1){
            return (tokenURI(mintIndex - (_load_nft_number+1)),"null","null","null","null");
        }
        else
            return (tokenURI(mintIndex - (_load_nft_number+1)),tokenURI(mintIndex - (_load_nft_number+2)),tokenURI(mintIndex - (_load_nft_number+3)),tokenURI(mintIndex - (_load_nft_number+4)),tokenURI(mintIndex - (_load_nft_number+5)));
    }
}
