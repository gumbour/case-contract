pragma solidity >=0.4.22 <0.6.0;

contract xchcContract { //案件瑕疵核查
    function aj_xchc(string memory ah) public returns(bool)
    {
        return true;
    }

    function aj_xchcjg(string memory txHash) public view returns(string memory _ret)
    {
        _ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\", \"cccxfkhzb\":\"ok\", \"xcdcbl\":\"ok\"}";
    }
} 