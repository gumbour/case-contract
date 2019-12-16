pragma solidity >=0.4.22 <0.6.0;

contract xchcContract { //案件瑕疵核查
    mapping(uint64 => string) xchcjg;

    function aj_xchc(string memory ah, uint64 uuid) public returns(bool)
    {
        string memory ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\", \"cccxfkhzb\":\"ok\", \"xcdcbl\":\"ok\"}";
        xchcjg[uuid] = ret;
        return true;
    }

    function aj_xchcjg(uint64 uuid) public view returns(string memory _ret)
    {
        _ret = xchcjg[uuid];
    }
} 