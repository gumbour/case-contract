pragma solidity >=0.4.22 <0.6.0;

contract jzhcContract { //卷宗核查 
    mapping(uint64 => string) jzhcjg;

    function aj_jzhc(string memory ah, uint64 uuid) public returns(bool)
    {
        string memory _ret = "{\"jzywjy\":[{\"jyx_id\":1,\"lcjd_id\":53,\"jyjg\":1},{\"jyx_id\":1,\"lcjd_id\":54,\"jyjg\":1},{\"jyx_id\":1,\"lcjd_id\":65,\"jyjg\":1},{\"jyx_id\":2,\"lcjd_id\":67,\"jyjg\":1},{\"jyx_id\":3,\"lcjd_id\":68,\"jyjg\":1},{\"jyx_id\":3,\"lcjd_id\":69,\"jyjg\":2},{\"jyx_id\":3,\"lcjd_id\":70,\"jyjg\":2},{\"jyx_id\":3,\"lcjd_id\":71,\"jyjg\":2},{\"jyx_id\":4,\"jyjg\":3},{\"jyx_id\":5,\"jyjg\":3},{\"jyx_id\":6,\"jyjg\":3},{\"jyx_id\":7,\"lcjd_id\":72,\"jyjg\":0},{\"jyx_id\":8,\"jyjg\":3},{\"jyx_id\":9,\"lcjd_id\":75,\"jyjg\":1},{\"jyx_id\":10,\"lcjd_id\":74,\"jyjg\":0},{\"jyx_id\":11,\"jyjg\":3},{\"jyx_id\":12,\"jyjg\":3},{\"jyx_id\":13,\"jyjg\":3},{\"jyx_id\":14,\"jyjg\":3}]}";
        jzhcjg[uuid] = _ret;
        return true;
    }

    function aj_jzhcjg(uint64 uuid) public view returns(string memory _ret)
    {
        _ret = jzhcjg[uuid];
    }
} 