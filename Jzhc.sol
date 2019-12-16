pragma solidity >=0.4.22 <0.6.0;

contract jzhcContract { //卷宗核查 
    function aj_jzhc(string memory ah) public returns(bool)
    {
        return true;
    }

    function aj_jzhcjg(string memory txHash) public view returns(string memory _ret)
    {
        _ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\", \"cccxfkhzb\":\"ok\", \"xcdcbl\":\"ok\"}";
    }
} 