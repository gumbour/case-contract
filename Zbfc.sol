pragma solidity >=0.4.22 <0.6.0;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public view returns(string memory _ret);
}

import "./LibString.sol";

contract zbfcContract { //终本复查:筛选在执案件列表, 筛选待复查列表
    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);

    /*function aj_sxzzajlb(uint64 uuid) public returns(bool)
    {
        string memory ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\"}";
        sxzzajlbjg[uuid] = ret;
        return true;
    }

    function aj_sxzzajlbjg(uint64 uuid) public view returns(string memory _ret)
    {
        _ret = sxzzajlbjg[uuid];
    }*/

    function aj_sxzbdfcajlb(string memory ajbs, string memory jarq, uint wlcks, uint64 uuid) public returns(bool)
    {
        uint jqrqUnix = LibString.touint(jarq);
        uint cur = now();
        string memory keys = new string[](1);
        string memory values = new string[](1);

        //终本复查案件筛选
        keys[0] = "isfcaj";
        if((jqrqUnix + (wlcks - 1 <= cur)) && (now() <= wlcks * 3))
        {
            values[0] = "1";
            czjl.aj_setResult(uuid, keys, values);
            return true;
        }

        values[0] = "0";
        czjl.aj_setResult(uuid, keys, values);
        return false;
    }

    function aj_sxzbdfcajlbjg(uint64 uuid) public view returns(string[] memory keys, string[] memory values)
    {
        return czjl.aj_getResult(uuid);
    }

    function aj_setCzjlConstractAddr(address recordContractAddr) public
    {
        czjlAddr = recordContractAddr;
        czjl = CzjlContract(czjlAddr);
    }
}