pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public view returns(string memory _ret);
}

import "./LibString.sol";

contract JzhcContract { //卷宗核查
    address public czjlAddr = 0x2FB1Bb9cB68B8Da05eca3869526740d8fE099297;
    CzjlContract czjl = CzjlContract(czjlAddr);

    //校验卷宗是否存在 0: 不存在 1: 存在
    function aj_jzhc_jy(string memory ajbs, string memory key) internal returns(uint)
    {
        string memory itemValue;

        itemValue = czjl.aj_getInfo(ajbs, key);

        if(bytes(itemValue).length == 0)
        {
            return 0;
        }
        return 1;
    }

    //记录卷宗核查记录
    function aj_jzhc_jl(string[] memory keys, string[] memory values, uint pos, uint jyid, uint result, uint lcjd_id) internal returns(uint)
    {
        uint index = pos;
        string[3] memory resultK = ["jyx_id", "jyjg", "lcjd_id"];
        string[4] memory resultV = ["0", "1", "2", "3"];

        //jyx_id
        keys[index] = resultK[0];
        values[index] = LibString.uint2str(jyid);
        index++;

        //lcjd_id
        keys[index] = resultK[2];
        values[index] = LibString.uint2str(lcjd_id);
        index++;

        //jyjg
        keys[index] = resultK[1];
        values[index] = resultV[result];
        index++;
        return index;
    }

    function aj_jzhc(string memory ajbs, uint64 uuid) public returns(bool)
    {
        string[] memory keys = new string[](50);
        string[] memory values = new string[](50);
        uint pos = 0;
        uint ret = 0;

        //校验执行通知书
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.zxtzs.0.ah");
        pos = aj_jzhc_jl(keys, values, 1, pos, ret, 53);

        //报告财产令
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.bgccl.0.ah");
        pos = aj_jzhc_jl(keys, values, 1, pos, ret, 54);
        

        //送达回证
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.sdhz.0.ah");
        pos = aj_jzhc_jl(keys, values, 1, pos, ret, 65);

        //财产查询反馈汇总表
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.cccxfkzb.0.ah");
        pos = aj_jzhc_jl(keys, values, 2, pos, ret, 67);

        //现场调查笔录/搜查令/悬赏公告/司法审计报告任一份
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.dcbl.0.ah");
        pos = aj_jzhc_jl(keys, values, 3, pos, ret, 68);
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.scl.0.ah");
        pos = aj_jzhc_jl(keys, values, 3, pos, ret, 69);
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xsgg.0.ah");
        pos = aj_jzhc_jl(keys, values, 3, pos, ret, 70);
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.Sfsjbg.0.ah");
        pos = aj_jzhc_jl(keys, values, 3, pos, ret, 71);

        //限制消费令
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, 4, pos, ret, 72);

        //约谈笔录
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, 5, pos, ret, 73);

        //终本裁定书
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, 6, pos, ret, 74);

        //终结本次执行程序案件办理情况表
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, 7, pos, ret, 75);

        czjl.aj_setResult(uuid, keys, values);
        return true;
    }

    function aj_jzhcjg(uint64 uuid) public view returns(string[] memory, string[] memory)
    {
        return czjl.aj_getResult(uuid);
    }

    function aj_setCzjlConstractAddr(address recordContractAddr) public
    {
        czjlAddr = recordContractAddr;
        czjl = CzjlContract(czjlAddr);
    }
} 