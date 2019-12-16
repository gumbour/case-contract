pragma solidity >=0.4.22 <0.6.0;

contract jzyzxhcContract { //卷宗一致性核查
    mapping(uint64 => string) jzyzxhcjg;

    function aj_jzyzxhc(string memory ah, uint64 uuid) public returns(bool)
    {
        string memory ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\", \"cccxfkhzb\":\"ok\", \"xcdcbl\":\"ok\"}";
        jzyzxhcjg[uuid] = ret;
        return true;
    }

    function aj_jzyzxhcjg(uint64 uuid) public view returns(string memory _ret)
    {
        _ret = jzyzxhcjg[uuid];
    }
} 