pragma solidity >=0.4.22 <0.6.0;

contract jzhcContract { //卷宗核查 
    mapping(uint64 => string) jzhcjg;

    function aj_jzhc(string memory ah, uint64 uuid) public returns(bool)
    {
        string memory _ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\", \"cccxfkhzb\":\"ok\", \"xcdcbl\":\"ok\"}";
        jzhcjg[uuid] = _ret;
        return true;
    }

    function aj_jzhcjg(uint64 uuid) public view returns(string memory _ret)
    {
        _ret = jzhcjg[uuid];
    }
} 