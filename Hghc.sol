pragma solidity >=0.4.22 <0.6.0;

contract hghcContract { //合规核查
    mapping(uint64 => string) hghcjg;

    function aj_hghc(string memory ah, uint64 uuid) public returns(bool)
    {
        string memory _ret = "{\"hgxjy\": [{\"jyx_id\": 1,\"jyjg\": 1}, {\"jyx_id\": 2,\"jyjg\": 1}, {\"jyx_id\": 3,\"jyjg\": 1}, {\"jyx_id\": 4, \"jyjg\": 1}, {\"jyx_id\": 5,\"jyjg\": 1}, {\"jyx_id\": 6,\"jyjg\": 1}, {\"jyx_id\": 7, \"jyjg\": 1}, {\"jyx_id\": 8,\"jyjg\": 1}, {\"jyx_id\": 9,\"jyjg\": 1}, {\"jyx_id\": 10,\"jyjg\": 0}, {\"jyx_id\": 11,\"jyjg\": 1}, {\"jyx_id\": 12,\"jyjg\": 1}, {\"jyx_id\": 13,\"jyjg\": 1}, {\"jyx_id\": 14,\"jyjg\": 1}]}";
        hghcjg[uuid] = _ret;
        return true;
    }

    function aj_hghcjg(uint64 uuid) public view returns(string memory _ret)
    {
        _ret = hghcjg[uuid];
    }
} 