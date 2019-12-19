pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public view returns(string memory _ret);
}

import "./LibString.sol";

contract XchcContract { //案件瑕疵核查
    uint constant RESULT_NOK = 0;
    uint constant RESULT_OK = 1;
    uint constant MAX_ITEM = 30;
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

    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);

    //瑕疵核查结果检查记录
    function aj_xchc_yy_jl(string[] memory keys, string[] memory values, uint pos, uint jyid, uint result, uint lcjd_id) internal returns(uint)
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


    //办理期限校验
    function aj_xchc_blqxjy(string memory ajbs, string[] memory keys, string[] memory values, uint pos) internal returns(uint)
    {
        //执行通知书、报告财产令 发出日期
        //zdnrInfo.zxtzs.0.larq
        //Jghinfo.Jaqk.jarq

        //Wlckxx.tqcxrq网络查控信息.提起查询日期

        //财产调查：有记录;搜查：无记录;悬赏执行：无记录;司法审计：无记录

        //对被执行人的住房公积金（仅对自然人）、金融理财产品、收益类保险、股息红利作过调查

        //没有未核实完毕的执行线索

        //未发现可供执行财产或发现的财产不能处置

        //已向被执行人发出限制消费令，并将符合条件的被执行人纳入失信被执行人名单

        //已完成终本约谈且约谈日期必须早于结案日期

        //尚未执行标的金额必须大于零

        //已作出终本裁定

        //不存在被执行人都已死亡情形

        //执行标的内容不能仅为行为执行
        
    }

    //卷宗院印校验
    function aj_xchc_yy_jylist(string memory ajbs, string memory prex, string memory key) internal returns(uint)
    {
        string memory item;
        string memory fullkey;

        for(uint i = 0; i < MAX_ITEM; i++)
        {
            fullkey = LibString.concat(prex, LibString.uint2str(i));
            fullkey = LibString.concat(fullkey, key);
            item = czjl.aj_getInfo(ajbs, fullkey);
            if(bytes(item).length == 0)
            {
                break;
            }

            if(LibString.equal(item, "0"))
            {
                return RESULT_NOK;
            }
        }
        return RESULT_OK;
    }

    //2 瑕疵核查记录
    function aj_xchc_yy(string memory ajbs, string[] memory keys, string[] memory values, uint posstart) internal returns(uint)
    {
        uint ret = 0;
        uint pos = posstart;

        //执行通知书
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.zxtzs.", "yy");
        pos = aj_xchc_yy_jl(keys, values, pos, 1, ret, LCJD_ZXTZS);

        //报告财产令
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.bgccl.", "yy");
        pos = aj_xchc_yy_jl(keys, values, pos, 1, ret, LCJD_BGCCL);

        //送达回证
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.sdhz.", "qm");
        pos = aj_xchc_yy_jl(keys, values, pos, 1, ret, LCJD_SDHZ);

        //调查笔录
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.dcbl.", "qm");
        pos = aj_xchc_yy_jl(keys, values, pos, 2, ret, LCJD_XCDCBL);

        //搜查令
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.scl.", "qm");
        pos = aj_xchc_yy_jl(keys, values, pos, 2, ret, LCJD_SCL);
        

        //悬赏公告
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.xsgg.", "yy");
        pos = aj_xchc_yy_jl(keys, values, pos, 2, ret, LCJD_XSGG);
        
        

        //限制消费令
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.xzxfl.", "yy");
        pos = aj_xchc_yy_jl(keys, values, pos, 7, ret, LCJD_XZXFL);

        //失信决定书
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.sxjds.", "yy");
        pos = aj_xchc_yy_jl(keys, values, pos, 7, ret, LCJD_SXJDS);


        //约谈笔录
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.zbytjl.", "qm");
        pos = aj_xchc_yy_jl(keys, values, pos, 8, ret, LCJD_YTBL);

        //拟终结本次执行程序告知书, 院印 签名
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.nzjgzs.", "yy");
        if (ret == RESULT_OK)
        {
            ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.nzjgzs.", "qm");
            if(ret == RESULT_OK)
            {
                pos = aj_xchc_yy_jl(keys, values, pos, 8, ret, 0);
            }
        }
        else
        {
            pos = aj_xchc_yy_jl(keys, values, pos, 8, ret, 0);
        }
        
        //终结本次执行程序申请书
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.zjbccxsqs.", "sfqm");
        pos = aj_xchc_yy_jl(keys, values, pos, 8, ret, LCJD_ZJBLQKB);

        //合议庭评议笔录
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.zbhytbl.", "qm");
        pos = aj_xchc_yy_jl(keys, values, pos, 8, ret, 0);


        //终本裁定书
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.zxcds.", "yy");
        pos = aj_xchc_yy_jl(keys, values, pos, 8, ret, LCJD_ZBCDS);

        return pos;
    }

    function aj_xchc(string memory ajbs, uint64 uuid) public returns(bool)
    {
        string[] memory keys = new string[](50);
        string[] memory values = new string[](50);
        uint pos = 0;
        
        //1 办理期限校验
        pos = aj_xchc_blqxjy(ajbs, keys, values, 0);

        //2 院印有无校验
        aj_xchc_yy(ajbs, keys, values, pos);

        czjl.aj_setResult(uuid, keys, values);
        return true;
    }

    function aj_xchcjg(uint64 uuid) public view returns(string[] memory, string[] memory)
    {
        return czjl.aj_getResult(uuid);
    }

    function aj_setCzjlConstractAddr(address recordContractAddr) public
    {
        czjlAddr = recordContractAddr;
        czjl = CzjlContract(czjlAddr);
    }
}