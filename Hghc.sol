pragma solidity >=0.4.22 <0.6.0;

contract hghcContract { //合规核查
    function aj_hghc(string memory ah) public returns(bool)
    {
        return true;
    }

    function aj_hghcjg(string memory txHash) public view returns(string memory _ret)
    {
        _ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\", \"cccxfkhzb\":\"ok\", \"xcdcbl\":\"ok\"}";
    }
} 