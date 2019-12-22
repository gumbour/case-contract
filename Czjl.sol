pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract { //操作记录  
    struct Result{
        string[] keys;
        string[] values;
    }

    struct ContractAddr{
        string name;
        string addr;
    }

    mapping(uint64 => Result) hcjg;
    mapping(string => mapping(string => string)) czjl;
    mapping(string => uint) addrIndex;
    ContractAddr[] contractAddr;


    //记录案件信息, 输入案号,案件信息(kv))
    function aj_xxjl(string memory ajbs, string[] memory keys, string[] memory values) public returns(bool){
        require(keys.length == values.length);
        for(uint i = 0; i < keys.length; i++)
        {
            czjl[ajbs][keys[i]] = values[i];
        }
        return true;
    }

    function aj_getInfo(string memory ajbs, string memory key) public returns(string memory _ret)
    {
        _ret = czjl[ajbs][key];
    }

    function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public
    {
        hcjg[uuid] = Result({keys: keys, values: values});
    }

    function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values)
    {
        keys = hcjg[uuid].keys;
        values = hcjg[uuid].values;
    }

    

    function aj_getContractAddr() public view returns(string[] memory name, string[] memory addr)
    {
        name = new string[](contractAddr.length);
        addr = new string[](contractAddr.length);

        for(uint i = 0; i < contractAddr.length; i++)
        {
            name[i] = contractAddr[i].name;
            addr[i] = contractAddr[i].addr;
        }
    }

    function aj_regContractAddr(string memory name, string memory addr) public
    {
        uint indx = 0;
        indx = addrIndex[name];

        if(indx == 0)
        {
            indx = contractAddr.length++;
            contractAddr[indx].name = name;
            contractAddr[indx].addr = addr;
            addrIndex[name] = indx + 1;
            return;
        }

        contractAddr[indx-1].addr = addr;
    }
}