pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract { //操作记录  
    struct Result{
        string[] keys;
        string[] values;
    }

    mapping(uint64 => Result) hcjg;
    mapping(string => mapping(string => string)) czjl;

    //记录案件信息, 输入案号, ocr, 案件信息(json)
    function aj_xxjl(string memory ah, string[] memory keys, string[] memory values) public returns(bool){
        require(keys.length == values.length);
        for(uint i = 0; i < keys.length; i++)
        {
            czjl[ah][keys[i]] = values[i];
        }
        return true;
    }

    function aj_getInfo(string memory ah, string memory key) public view returns(string memory _ret)
    {
        _ret = czjl[ah][key];
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

    
}