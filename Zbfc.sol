pragma solidity >=0.4.22 <0.6.0;

contract zbfcContract { //终本复查:筛选在执案件列表, 筛选待复查列表
    mapping(uint64 => string) sxzzajlbjg;
    mapping(uint64 => string) sxzbdfcajlbjg;

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
        string memory ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\"}";
        sxzbdfcajlbjg[uuid] = ret;
        return true;
    }

    function aj_sxzbdfcajlbjg(uint64 uuid) public view returns(string[] memory keys, string[] memory values)
    {
        //keys = 
    }
}