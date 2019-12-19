pragma solidity >=0.4.22 <0.6.0;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public view returns(string memory _ret);
}

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

    function aj_sxzbdfcajlb(string memory ajbs, string memory jarq, string memory wlcks, uint64 uuid) public returns(bool)
    {
        //终本复查案件筛选
        
        return true;
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