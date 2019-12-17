pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ah, string memory key) public view returns(string memory _ret);
}

import "LibString.sol";

contract HghcContract { //合规核查
    using LibString for *;

    address public czjlAddr = 0xb23e0bfaeedcfce82ea2011f2a2726584e611e57;
    CzjlContract czjl = CzjlContract(czjlAddr);

    function aj_hghc(string memory ah, uint64 uuid) public returns(bool)
    {
        //string memory _ret = "{\"hgxjy\": [{\"jyx_id\": 1,\"jyjg\": 1}, {\"jyx_id\": 2,\"jyjg\": 1}, {\"jyx_id\": 3,\"jyjg\": 1}, {\"jyx_id\": 4, \"jyjg\": 1}, {\"jyx_id\": 5,\"jyjg\": 1}, {\"jyx_id\": 6,\"jyjg\": 1}, {\"jyx_id\": 7, \"jyjg\": 1}, {\"jyx_id\": 8,\"jyjg\": 1}, {\"jyx_id\": 9,\"jyjg\": 1}, {\"jyx_id\": 10,\"jyjg\": 0}, {\"jyx_id\": 11,\"jyjg\": 1}, {\"jyx_id\": 12,\"jyjg\": 1}, {\"jyx_id\": 13,\"jyjg\": 1}, {\"jyx_id\": 14,\"jyjg\": 1}]}";
        //hghcjg[uuid] = _ret;
        string[] memory keys;
        string[] memory values;
        string memory index;
        string memory key;
        string memory prex;
        uint idx = 0;
        
        for(uint i = 0; i < 14; i++)
        {
            //jyx_id
            index = LibString.uint2str(i);
            prex = LibString.concat("hgxjy.", index);
            key = LibString.concat(prex, "jyx_id");
            keys[idx] = key;
            values[idx] = "1";
            idx++;
            //jyjg
            key = LibString.concat(prex, "jyjg");
            keys[idx] = key;
            values[idx] = "1";
            idx++;
        }

        //进行检查项核查
        //string memory ret = czjl.aj_getInfo(ah, "hghc");
        /*if(bytes(ret).length == 0)
        {
            keys[0] = "testkey0";
            values[0] = "nok";
        }
        else
        {
            keys[0] = "testkey0";
            values[0] = "ok";
        }*/

        czjl.aj_setResult(uuid, keys, values);
        return true;
    }

    function aj_hghcjg(uint64 uuid) public view returns(string[] memory, string[] memory)
    {
        return czjl.aj_getResult(uuid);
    }

    function aj_setCzjlConstractAddr(address recordContractAddr) public
    {
        czjlAddr = recordContractAddr;
        czjl = CzjlContract(czjlAddr);
    }
} 