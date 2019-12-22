pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public returns(string memory _ret);
        function aj_regContractAddr(string memory name, string memory addr) public;
}

import "./LibString.sol";

contract JzhcContract { //卷宗核查
    uint constant LCJD_ZXTZS = 53; //执行通知书
    uint constant LCJD_BGCCL = 54; //财产报告令
    uint constant LCJD_SDHZ = 65; //送达回证
    uint constant LCJD_CCFQHZ = 67;//财产查询反馈汇总表
    uint constant LCJD_XCDCBL = 68;//现场调查笔录
    uint constant LCJD_SCL = 69;//搜查令
    uint constant LCJD_XSGG = 70;//悬赏公告
    uint constant LCJD_SFSJBG = 71;//司法审计报告
    uint constant LCJD_XZXFL = 72; //限制消费令
    uint constant LCJD_YTBL = 73; //约谈笔录
    uint constant LCJD_ZBCDS = 74;//终本裁定书
    uint constant LCJD_ZJBLQKB = 75;//终结本次执行程序案件办理情况表
    uint constant LCJD_SXJDS = 77;//失信决定书
    uint constant EXSIT = 1;
    uint constant NOT_EXSIT = 0;
    uint constant NO_JUDGE = 2;

    address public czjlAddr = 0x5E0A0044153da8644e866af8cbbA8f230b32E8E4;
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
    function aj_jzhc_jl(string[] memory keys, string[] memory values, uint pos, uint jyid, uint result, uint lcjd_id, uint id)
        internal returns(uint)
    {
        uint index = pos;
        string memory prefix;
        string[3] memory resultK = [".jyx_id", ".jyjg", ".lcjd_id"];
        string[4] memory resultV = ["0", "1", "2", "3"];

        //jyx_id
        prefix = LibString.concat("jzywjy.", LibString.uint2str(id));
        keys[index] = LibString.concat(prefix, resultK[0]);
        values[index] = LibString.uint2str(jyid);
        index++;

        //lcjd_id
        keys[index] = LibString.concat(prefix, resultK[2]);
        values[index] = LibString.uint2str(lcjd_id);
        index++;

        //jyjg
        keys[index] = LibString.concat(prefix, resultK[1]);
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
        uint dcbl = 0;
        uint scl = 0;
        uint xsgg = 0;
        uint sfsj = 0;
        
        //校验执行通知书
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.zxtzs.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 1, ret, LCJD_ZXTZS, 0);

        //报告财产令
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.bgccl.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 1, ret, LCJD_BGCCL, 1);
        
        //送达回证
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.sdhz.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 1, ret, LCJD_SDHZ, 2);

        //财产查询反馈汇总表
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.cccxfkzb.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 2, ret, LCJD_CCFQHZ, 3);

        //现场调查笔录/搜查令/悬赏公告/司法审计报告任一份
        dcbl = aj_jzhc_jy(ajbs, "zdnrInfo.dcbl.0.ah");
        scl = aj_jzhc_jy(ajbs, "zdnrInfo.scl.0.ah");
        xsgg = aj_jzhc_jy(ajbs, "zdnrInfo.xsgg.0.ah");
        sfsj = aj_jzhc_jy(ajbs, "zdnrInfo.sfsjbg.0.ah");
        ret = NOT_EXSIT;

        if(dcbl == EXSIT || scl == EXSIT || xsgg == EXSIT || sfsj == EXSIT)
        {
            if(dcbl == EXSIT)
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, EXSIT, LCJD_XCDCBL, 4);
            }
            else
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, NO_JUDGE, LCJD_XCDCBL, 4);
            }
            if(scl == EXSIT)
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, EXSIT, LCJD_SCL, 5);
            }
            else
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, NO_JUDGE, LCJD_SCL, 5);
            }
            if(xsgg == EXSIT)
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, EXSIT, LCJD_XSGG, 6);
            }
            else
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, NO_JUDGE, LCJD_XSGG, 6);
            }
            if(sfsj == EXSIT)
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, EXSIT, LCJD_SFSJBG, 7);
            }
            else
            {
                pos = aj_jzhc_jl(keys, values, pos, 3, NO_JUDGE, LCJD_SFSJBG, 7);
            }
        }
        else
        {
            pos = aj_jzhc_jl(keys, values, pos, 3, ret, LCJD_XCDCBL, 4);
            pos = aj_jzhc_jl(keys, values, pos, 3, ret, LCJD_SCL, 5);
            pos = aj_jzhc_jl(keys, values, pos, 3, ret, LCJD_XSGG, 6);
            pos = aj_jzhc_jl(keys, values, pos, 3, ret, LCJD_SFSJBG, 7);
        }

        //限制消费令
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 4, ret, LCJD_XZXFL, 8);

        //约谈笔录
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 5, ret, LCJD_YTBL, 9);

        //终本裁定书
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 6, ret, LCJD_ZBCDS, 10);

        //终结本次执行程序案件办理情况表
        ret = aj_jzhc_jy(ajbs, "zdnrInfo.xzxfl.0.ah");
        pos = aj_jzhc_jl(keys, values, pos, 7, ret, LCJD_ZJBLQKB, 11);

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
        czjl.aj_regContractAddr("jzhc", LibString.addrToString(address(this)));
    }
} 