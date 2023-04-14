// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Artplace {

    uint internal GallerySize = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Art {
        address payable owner;
        string name;
        string image;
        string description;
        bool Sold;
        uint price;
        uint index;
    }

    mapping (uint => Art) internal Gallery;

    function Addart(
        string memory _name,
        string memory _image,
        string memory _description,  
        uint _price
    
    ) public {
        Gallery[GallerySize] = Art(
            payable(msg.sender),
            _name,
            _image,
            _description,
            false,
            _price,
            GallerySize
        );
        GallerySize++;
    }

    function readProduct(uint _index) public view returns (
        address payable,
        string memory, 
        string memory,  
        string memory, 
        bool,
        uint
    ) {
        return (
            Gallery[_index].owner,
            Gallery[_index].name, 
            Gallery[_index].image, 
            Gallery[_index].description,
            Gallery[_index].Sold, 
            Gallery[_index].price
        );
    }
    
    function buyArtpiece(uint _index) public payable  {
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            Gallery[_index].owner,
            Gallery[_index].price
          ),
          "Transfer failed."
        );
    }
    
    function getGallerySize() public view returns (uint) {
        return (GallerySize);
    }
}