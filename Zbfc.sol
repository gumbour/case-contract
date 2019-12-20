pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public returns(string memory _ret);
}

import "./LibString.sol";

contract zbfcContract { //终本复查:筛选在执案件列表, 筛选待复查列表

    //结案方式为"执行完毕"标识
    string constant ZXWB = "09_05082-3";

    //结案方式为"终结本次执行程序"标识
    string constant ZJBCZXCX = "09_05080-5";

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
        uint jqrqUnix = LibString.toUint(jarq);
        uint cur = now;
        string[] memory keys = new string[](1);
        string[] memory values = new string[](1);
        string memory itemValue;

        //终本复查案件筛选
        keys[0] = "isfcaj";
        values[0] = "0";
        //执行流程系统中结案方式=裁定终结本次执行程序/终结本次执行程序
        itemValue = czjl.aj_getInfo(ajbs, "jghinfo.jaqk.jafs");
        if(LibString.equal(itemValue, ZXWB) == false &&
            LibString.equal(itemValue, ZXWB) == false)
        {
            czjl.aj_setResult(uuid, keys, values);
            return true;
        }
        //结案日期+(n-1)*3个月<=当前日期<=结案日期+n*3个月
        if((jqrqUnix + (wlcks - 1)*3 > cur) || (cur > wlcks * 3))
        {
            czjl.aj_setResult(uuid, keys, values);
            return true;
        }

        values[0] = "1";
        czjl.aj_setResult(uuid, keys, values);
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