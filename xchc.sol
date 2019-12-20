pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public returns(string memory _ret);
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

    function aj_hghc_blqx_jl(string[] memory keys, string[] memory values, uint pos, uint jyid, uint result) internal returns(uint)
    {
        uint index = pos;
        string[2] memory resultK = ["jyx_id", "jyjg"];
        string[2] memory resultV = ["0", "1"];

        //jyx_id
        keys[index] = resultK[0];
        values[index] = LibString.uint2str(jyid);
        index++;

        //jyjg
        keys[index] = resultK[1];
        values[index] = resultV[result];
        index++;
        return index;
    }

    //接收案件后3日内完成执行通知节点
    //执行通知节点和接收案件节点的结束日期不为空，且执行通知节点结束日期-接收案件节点结束日期≤3日；
    function aj_xchc_blaxjy1(string memory ajbs) internal returns(uint)
    {

    }

    //接收案件后10日内发起首次网络查控；
    //执行流程节点表中的接收案件节点结束日期不为空，且网络查控信息表有记录，且最早的一条提起查询日期-接收案件节点结束日期≤10日；
    function aj_xchc_blaxjy2(string memory ajbs) internal returns(uint)
    {

    }

    //执行线索应在收到线索后7日内完成核实
    //1、执行线索表无记录；2、执行线索表中有线索状态为09_05064-1的记录，且当前日期-线索提供日期≤7日；3、执行线索表中有记录，且线索状态都不为09_05064-1；
    function aj_xchc_blaxjy5(string memory ajbs) internal returns(uint)
    {

    }


    //限高日期应早于结案日期
    //1、如果结案日期为空（未结案），强制限制表中，限制种类为【限制高消费】（09_05045-1）的所有记录的【开始日期】都在当前日期之前；当前日期-开始日期≥0
    //2、如果结案日期不为空（已结案），强制限制表中，限制种类为【限制高消费】（09_05045-1）的所有记录的【开始日期】
    //都在结案情况表中的结案日期之前；结案日期-开始日期≥0
    function aj_xchc_blaxjy7(string memory ajbs) internal returns(uint)
    {
        string memory item;
        string memory fullkey;
        string memory prex;
        bool bHasJarq = true;
        uint jarq = 0;
        uint ksrq = 0;

        item = czjl.aj_getInfo(ajbs, "jghinfo.jaqk.jarq");
        if(bytes(item).length == 0)
        {
            bHasJarq = false;
        }
        else
        {
            jarq = LibString.toUint(item);
        }

        for(uint i = 0; i < MAX_ITEM; i++)
        {
            prex = LibString.concat("jghinfo.xzgxf.", LibString.uint2str(i));
            fullkey = LibString.concat(prex, ".xzzl");
            item = czjl.aj_getInfo(ajbs, fullkey);

            if(bytes(item).length == 0)
            {
                break;
            }

            if(LibString.equal(item, "09_05045-1"))
            {
                fullkey = LibString.concat(prex, ".ksrq");
                item = czjl.aj_getInfo(ajbs, fullkey);
                ksrq = LibString.toUint(item);

                if((bHasJarq == false) && (now < ksrq))
                {
                    return RESULT_NOK;
                }

                if((bHasJarq == true) && (ksrq > jarq))
                {
                    return RESULT_NOK;
                }
            }
        }
        return RESULT_OK;
    }

    //执行期限届满日期前结案
    //1、如果结案日期为空（未结案），执行期限届满日期-当前日期≥0；
    //2、如果结案日期不为空（已结案），执行期限届满日期-结案日期≥0；
    //3、如果办案期限表的执行期限届满日期为空，则从收案和立案信息表中取立案日期判断，结案日期-立案日期≤6个月；
    //4、如果结案日期为空，则用当前核查日期进行计算
    function aj_xchc_blaxjy12(string memory ajbs) internal returns(uint)
    {
        string memory item;
        uint jarq = 0;
        uint zxqxjmrq = 0;
        uint larq = 0;

        //不存在时toUint会返回0
        item = czjl.aj_getInfo(ajbs, "jghinfo.jaqk.jarq");
        jarq = LibString.toUint(item);

        item = czjl.aj_getInfo(ajbs, "jghinfo.baqx.zxqxjmrq");
        zxqxjmrq = LibString.toUint(item);

        if((jarq == 0) && (zxqxjmrq >= now)
        {
            return RESULT_OK;
        }

        if((jarq != 0) && (zxqxjmrq >= jarq))
        {
            return RESULT_OK;
        }

        if(zxqxjmrq == 0)
        {
            item = czjl.aj_getInfo(ajbs, "jghinfo.sahlaxx.larq");
            larq = LibString.toUint(item);
            if(jarq != 0)
            {
                if(jarq <= larq + 6*30*24*60*60)
                {
                    return RESULT_OK;
                }
            }
            else if(now <= larq + 6*30*24*60*60)
            {
                returns RESULT_OK;
            }
        }
        
        return RESULT_NOK;
    }

    //办理期限校验
    function aj_xchc_blqxjy(string memory ajbs, string[] memory keys, string[] memory values, uint posstart) internal returns(uint)
    {
        uint pos = posstart;
        uint ret = 0;

        //校验1
        ret = aj_xchc_blaxjy1(ajbs);
        pos = aj_hghc_blqx_jl(keys, values, pos, 1, ret);

        //校验2
        ret = aj_xchc_blaxjy2(ajbs);
        pos = aj_hghc_blqx_jl(keys, values, pos, 2, ret);

        //校验5
        ret = aj_xchc_blaxjy5(ajbs);
        pos = aj_hghc_blqx_jl(keys, values, pos, 5, ret);

        //校验7
        ret = aj_xchc_blaxjy7(ajbs);
        pos = aj_hghc_blqx_jl(keys, values, pos, 7, ret);

        //校验12
        ret = aj_xchc_blaxjy12(ajbs);
        pos = aj_hghc_blqx_jl(keys, values, pos, 12, ret);

        return pos;
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
        ret = aj_xchc_yy_jylist(ajbs, "zdnrInfo.scl.", "yy");
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
        string[] memory keys = new string[](100);
        string[] memory values = new string[](100);
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