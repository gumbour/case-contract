pragma solidity >=0.4.22 <0.6.0;

contract zbfcContract { //终本复查:筛选在执案件列表, 筛选待复查列表
    function aj_sxzzajlb() public returns(bool)
    {
        return true;
    }

    function aj_sxzzajlbjg(string memory txHash) public view returns(string memory _ret)
    {
        _ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\"}";
    }

    function aj_sxzbdfcajlb() public returns(bool)
    {
        return true;
    }

    function aj_sxzbdfcajlbjg(string memory txHash) public view returns(string memory _ret)
    {
        _ret = "{\"zxtzs\":\"ok\",\"bgccl\":\"nok\",\"sdhz\":\"ok\"}";
    }
}