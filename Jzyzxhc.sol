pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public view returns(string memory _ret);
}

contract JzyzxhcContract { //卷宗一致性核查
    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);

    function aj_jzyzxhc(string memory ajbs, uint64 uuid) public returns(bool)
    {
        //string memory ret = "{\"bljlyzxjy\":[{\"jyx_id\":1,\"jyjg\":1},{\"jyx_id\":2,\"jyjg\":1},{\"jyx_id\":3,\"jyjg\":1},{\"jyx_id\":4,\"jyjg\":3},{\"jyx_id\":5,\"jyjg\":3},{\"jyx_id\":6,\"jyjg\":3},{\"jyx_id\":7,\"jyjg\":2},{\"jyx_id\":8,\"jyjg\":3},{\"jyx_id\":9,\"jyjg\":3},{\"jyx_id\":10,\"jyjg\":3},{\"jyx_id\":11,\"jyjg\":3},{\"jyx_id\":12,\"jyjg\":3},{\"jyx_id\":13,\"jyjg\":3},{\"jyx_id\":14,\"jyjg\":3}],\"jznryzxjy\":[{\"jyx_id\":1,\"lcjd_id\":53,\"jyjg\":0},{\"jyx_id\":1,\"lcjd_id\":53,\"jyjg\":1},{\"jyx_id\":1,\"lcjd_id\":54,\"jyjg\":1},{\"jyx_id\":1,\"lcjd_id\":54,\"jyjg\":1},{\"jyx_id\":1,\"lcjd_id\":65,\"jyjg\":0},{\"jyx_id\":2,\"qpnr\":\"\",\"lcjd_id\":67,\"jyjg\":1},{\"jyx_id\":2,\"lcjd_id\":67,\"jyjg\":0},{\"jyx_id\":2,\"lcjd_id\":67,\"jyjg\":1},{\"jyx_id\":3,\"lcjd_id\":68,\"jyjg\":1},{\"jyx_id\":3,\"lcjd_id\":69,\"jyjg\":2},{\"jyx_id\":3,\"lcjd_id\":70,\"jyjg\":2},{\"jyx_id\":3,\"lcjd_id\":71,\"jyjg\":2},{\"jyx_id\":4,\"jyjg\":3},{\"jyx_id\":5,\"jyjg\":3},{\"jyx_id\":6,\"jyjg\":3},{\"jyx_id\":7,\"lcjd_id\":72,\"jyjg\":2},{\"jyx_id\":7,\"lcjd_id\":72,\"jyjg\":2},{\"jyx_id\":8,\"jyjg\":3},{\"jyx_id\":9,\"lcjd_id\":75,\"jyjg\":0},{\"jyx_id\":9,\"lcjd_id\":75,\"jyjg\":0},{\"jyx_id\":10,\"lcjd_id\":74,\"jyjg\":2},{\"jyx_id\":11,\"jyjg\":3},{\"jyx_id\":12,\"jyjg\":3},{\"jyx_id\":13,\"jyjg\":3},{\"jyx_id\":14,\"jyjg\":3}],\"nrjy_cqjg\":[{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352013,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352014,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352018,\"jyjg\":1},{\"jq_jyjg\":0,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352021,\"jyjg\":0},{\"jq_jyjg\":1,\"jzjyjg\":1,\"zdmc\":\"bzxrmc\",\"jzid\":352013,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":1,\"zdmc\":\"bzxrmc\",\"jzid\":352014,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":1,\"zdmc\":\"bzxrmc\",\"jzid\":352018,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"bzxrmc\",\"jzid\":352021,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352009,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":1,\"zdmc\":\"bzxrmc\",\"jzid\":352009,\"jyjg\":1},{\"jq_jyjg\":0,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352011,\"jyjg\":0},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352012,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":1,\"zdmc\":\"bzxrmc\",\"jzid\":352010,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":1,\"zdmc\":\"bzxrmc\",\"jzid\":352019,\"jyjg\":1},{\"jq_jyjg\":0,\"jzjyjg\":0,\"zdmc\":\"cxfw\",\"jzid\":352010,\"jyjg\":0},{\"jq_jyjg\":0,\"jzjyjg\":0,\"zdmc\":\"cxfw\",\"jzid\":352019,\"jyjg\":0},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"tqcxrq\",\"jzid\":352010,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"tqcxrq\",\"jzid\":352019,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352017,\"jyjg\":1},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352015,\"jyjg\":1},{\"jq_jyjg\":0,\"jzjyjg\":0,\"zdmc\":\"ah\",\"jzid\":352022,\"jyjg\":0},{\"jq_jyjg\":0,\"jzjyjg\":0,\"zdmc\":\"sjdwje\",\"jzid\":352015,\"jyjg\":0},{\"jq_jyjg\":1,\"jzjyjg\":0,\"zdmc\":\"sjdwje\",\"jzid\":352022,\"jyjg\":1}]}";
        //jzyzxhcjg[uuid] = ret;
        string[] memory keys;
        string[] memory values;
        string memory ret = czjl.aj_getInfo(ajbs, "hghc");

        //进行检查项核查
        if(bytes(ret).length == 0)
        {
            keys[0] = "testkey0";
            values[0] = "nok";
        }
        else
        {
            keys[0] = "testkey0";
            values[0] = "ok";
        }

        czjl.aj_setResult(uuid, keys, values);
        return true;
    }

    function aj_jzyzxhcjg(uint64 uuid) public view returns(string[] memory, string[] memory)
    {
        return czjl.aj_getResult(uuid);
    }

    function aj_setCzjlConstractAddr(address recordContractAddr) public
    {
        czjlAddr = recordContractAddr;
        czjl = CzjlContract(czjlAddr);
    }
} 