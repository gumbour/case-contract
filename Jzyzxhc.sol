pragma solidity >=0.4.22 <0.6.0;

contract jzyzxhcContract { //卷宗一致性核查
    function aj_jzyzxhc(string memory ah) public returns(bool)
    {
        return true;
    }

    function aj_jzyzxhcjg(string memory txHash) public view returns(string memory _ret)
    {
        _ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\", \"cccxfkhzb\":\"ok\", \"xcdcbl\":\"ok\"}";
    }
} 