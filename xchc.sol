pragma solidity >=0.4.22 <0.6.0;

contract xchcContract { //案件瑕疵核查
    mapping(uint64 => string) xchcjg;

    function aj_xchc(string memory ah, uint64 uuid) public returns(bool)
    {
        string memory ret = "{\"blqxjy\":[{\"jyx_id\":1,\"jyjg\":1},{\"jyx_id\":2,\"jyjg\":0},{\"jyx_id\":3,\"jyjg\":3},{\"jyx_id\":3,\"jyjg\":3},{\"jyx_id\":3,\"jyjg\":3},{\"jyx_id\":3,\"jyjg\":3},{\"jyx_id\":4,\"jyjg\":3},{\"jyx_id\":5,\"jyjg\":1},{\"jyx_id\":6,\"jyjg\":3},{\"jyx_id\":7,\"jyjg\":1},{\"jyx_id\":8,\"jyjg\":3},{\"jyx_id\":9,\"jyjg\":1},{\"jyx_id\":10,\"jyjg\":1},{\"jyx_id\":11,\"jyjg\":1},{\"jyx_id\":12,\"jyjg\":3},{\"jyx_id\":13,\"jyjg\":3},{\"jyx_id\":14,\"jyjg\":3}],\"jzyy\":[{\"jynr\":1,\"jyx_id\":1,\"lcjd_id\":53,\"jyjg\":0},{\"jynr\":1,\"jyx_id\":1,\"lcjd_id\":54,\"jyjg\":0},{\"jynr\":0,\"jyx_id\":1,\"lcjd_id\":65,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":2,\"lcjd_id\":67,\"jyjg\":3},{\"jynr\":2,\"jyx_id\":3,\"lcjd_id\":68,\"jyjg\":1},{\"jynr\":1,\"jyx_id\":3,\"lcjd_id\":69,\"jyjg\":2},{\"jynr\":1,\"jyx_id\":3,\"lcjd_id\":70,\"jyjg\":2},{\"jynr\":0,\"jyx_id\":3,\"lcjd_id\":71,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":4,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":5,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":6,\"jyjg\":3},{\"jynr\":1,\"jyx_id\":7,\"lcjd_id\":72,\"jyjg\":2},{\"jynr\":0,\"jyx_id\":8,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":9,\"jyjg\":3},{\"jynr\":1,\"jyx_id\":10,\"lcjd_id\":74,\"jyjg\":2},{\"jynr\":0,\"jyx_id\":11,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":12,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":13,\"jyjg\":3},{\"jynr\":0,\"jyx_id\":14,\"jyjg\":3}]}";
        xchcjg[uuid] = ret;
        return true;
    }

    function aj_xchcjg(uint64 uuid) public view returns(string memory _ret)
    {
        _ret = xchcjg[uuid];
    }
} 