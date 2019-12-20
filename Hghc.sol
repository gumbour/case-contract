pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public returns(string memory _ret);
}

import "./LibString.sol";

contract HghcContract { //合规核查
    using LibString for *;
    uint constant MAX_ITEM = 30;
    uint constant MAX_BDCR = 5;
    uint constant RESULT_NOK = 0;
    uint constant RESULT_OK = 1;
    string constant XW = "09_ZX0008-3"; //执行标的内容-行为的标识
    string constant BZXR = "09_05036-2"; //被执行人
    string constant ZRR = "09_01001-1";//自然人标识
    string constant FR = "09_01001-2"; //法人标识
    string constant FFRZZ = "09_01001-3"; //非法人组织标识
    string constant SW = "死亡";
    string constant YH = "YH";//商业银行
    string constant BDC = "IP"; //不动产
    string constant HLWYH = "IF";//互联网银行
    string constant GSZJ = "GS"; //工商总局
    string constant RMYH = "RH"; //人民银行
    string constant ZQ = "ZQ";//证券
    string constant CL = "CL";//车辆
    string constant JRLC = "金融理财产品";
    string constant GJJ = "公积金";
    string constant SYLBX = "收益类保险";
    string constant GXHL = "股息红利";

    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);

    struct BdcrInfo {
        string bdcr;
        string bdcrlx;
        bool[4] ccdcqk;
    }

    function aj_hghc_jl(string[] memory keys, string[] memory values, uint pos, uint jyid, uint result) internal returns(uint)
    {
        uint index = pos;
        string[2] memory resultK = ["hgxjy.jyx_id", "hgxjy.jyjg"];
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

    //执行通知书有无记录zxtz, 发起执行通知书日期和报告财产令
    function aj_hghc_jy1(string memory ajbs) internal returns(uint)
    {
        string memory itemValue;

        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.zxtz.fczxtzsrq");
        if(bytes(itemValue).length == 0)
        {
            return RESULT_NOK;
        }

        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.bgccl.bgcclfcrq");
        if(bytes(itemValue).length == 0)
        {
            return RESULT_NOK;
        }

        return RESULT_OK;
    }

    //近3个月内，发起过对所有已开通查询功能的财产项目的总对总查询；
    //检验项2
    //网络查控表wlckxx
    //bzxr被执行人
    //tqcxrq提起查询日期
    //cxfw查询范围

    //执行主体信息表zxztxx
    //dsr当事人
    //dsrfldw当事人地位
        
    //jaqk结案情况表
    //jarq结案日期
    function aj_hghc_jy2(string memory ajbs) internal returns(uint)
    {
        string memory itemValue;
        string memory key;

        for(uint i = 0; ; i++)
        {
            key = LibString.concat("jghInfo.wlckxx.", LibString.uint2str(i));
            key = LibString.concat(key, ".tqcxrq");

            itemValue = czjl.aj_getInfo(ajbs, key);
            if(bytes(itemValue).length == 0)
            {
                break;
            }

            //判断日期是否在三个月内
            //itemValue //LibString.toUint(itemValue)
            //now()
        }

        return RESULT_OK;
    }
    

    //校验3 财产调查表、搜查表、悬赏执行表、司法审计表至少有一个表里有记录
    function aj_hghc_jy3(string memory ajbs) internal returns(uint)
    {
        string memory itemValue;
        
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.ccdc.0.bdcr");
        if(bytes(itemValue).length != 0)
        {
            return RESULT_OK;
        }
        itemValue = czjl.aj_getInfo(ajbs, "zdnrInfo.scl.0.ah");
        if(bytes(itemValue).length != 0)
        {
            return RESULT_OK;
        }
        itemValue = czjl.aj_getInfo(ajbs, "zdnrInfo.xsgg.0.ah");
        if(bytes(itemValue).length != 0)
        {
            return RESULT_OK;
        }
        itemValue = czjl.aj_getInfo(ajbs, "zdnrInfo.sfsjbg.0.ah");
        if(bytes(itemValue).length != 0)
        {
            return RESULT_OK;
        }

        return RESULT_NOK;
    }

    function aj_hghc_bdcr_lx(string memory ajbs, string memory bdcr) internal returns(string memory ret)
    {
        string memory item;
        string memory prefix;
        string memory fullkey;

        //执行主体信息
        for(uint i = 0; ; i++)
        {
            prefix = LibString.concat("jghinfo.zxztxx.", LibString.uint2str(i));
            fullkey = LibString.concat(prefix, ".dsr");
            item = czjl.aj_getInfo(ajbs, fullkey);

            if(bytes(item).length == 0)
            {
                break;
            }

            if(LibString.equal(item, bdcr))
            {
                fullkey = LibString.concat(prefix, ".dsrlx");
                ret = czjl.aj_getInfo(ajbs, fullkey);
                return ret;
            }
        }
        
        ret = "";
    }

    function aj_hghc_check_result(BdcrInfo memory bdcr) internal returns(bool)
    {
        if(LibString.equal(bdcr.bdcrlx, ZRR))
        {
            if(bdcr.ccdcqk[0] == false)
            {
                return false;
            }
        }

        if(bdcr.ccdcqk[1] == false)
        {
            return false;
        }
        if(bdcr.ccdcqk[2] == false)
        {
            return false;
        }
        if(bdcr.ccdcqk[3] == false)
        {
            return false;
        }
        return true;
    }

    function aj_hghc_get_bdcr(BdcrInfo[] memory bdcrArray, uint num, string memory bdcr)
        internal returns(uint)
    {
        for(uint i = 0; i < num; i++)
        {
            if(LibString.equal(bdcrArray[i].bdcr, bdcr))
            {
                return i;
            }
        }

        return 0xFF;
    }

    //对被执行人的住房公积金（仅对自然人）、金融理财产品、收益类保险、股息红利作过调查
    //财产调查表ccdc //bdcr被调查人 //dcnr调查内容
    function aj_hghc_jy4(string memory ajbs) internal returns(uint)
    {
        string memory item;
        string memory fullkey;
        string memory prefix;
        string memory item1;
        BdcrInfo[] memory bdcrArray; //被调查人, map不能用
        string memory dcrlx;
        uint i = 0;
        uint keyInx;
        uint num;

        keyInx = 0;
        num = 0;
        bdcrArray = new BdcrInfo[](MAX_BDCR);

        for(i = 0; ; i++)
        {
            prefix = LibString.concat("jghinfo.ccdc.", LibString.uint2str(i));
            fullkey = LibString.concat(prefix, ".bdcr");
            item = czjl.aj_getInfo(ajbs, fullkey);
            if(bytes(item).length == 0)
            {
                //不存在则结束查找
                break;
            }

            fullkey = LibString.concat(prefix, ".dcnr");
            item1 = czjl.aj_getInfo(ajbs, fullkey);

            //获取被调查人类型
            dcrlx = aj_hghc_bdcr_lx(ajbs, item);
            if(bytes(dcrlx).length == 0)
            {
                break;
            }
            
            keyInx = aj_hghc_get_bdcr(bdcrArray, num, item);
            if(keyInx == 0xFF)
            {
                if(num >= MAX_BDCR)
                {
                    return RESULT_NOK;
                }
                bdcrArray[num].bdcr = item;
                bdcrArray[num].bdcrlx = dcrlx;
                num++;
            }

            if(LibString.equal(dcrlx, ZRR))
            {
                //自然人多调查公积金
                if((bdcrArray[keyInx].ccdcqk[0] == false) &&
                    (LibString.indexOf(item1, GJJ) == -1))
                {
                    bdcrArray[keyInx].ccdcqk[0] = true;
                }
            }
            
            //金融理财产品
            if((bdcrArray[keyInx].ccdcqk[1] == false) &&
                (LibString.indexOf(item1, JRLC) == -1))
            {
                bdcrArray[keyInx].ccdcqk[1] = true;
            }
            //收益类保险
            if((bdcrArray[keyInx].ccdcqk[2] == false) &&
                (LibString.indexOf(item1, SYLBX) == -1))
            {
                bdcrArray[keyInx].ccdcqk[2] = true;
            }
            //股息红利
            if((bdcrArray[keyInx].ccdcqk[3] == false) &&
                (LibString.indexOf(item1, GXHL) == -1))
            {
                bdcrArray[keyInx].ccdcqk[3] = true;
            }
        }

        //判断多个调查人
        for(i = 0; i < num; i++)
        {
            if(aj_hghc_check_result(bdcrArray[i]) == false)
            {
                return RESULT_NOK;
            }
        }

        return RESULT_OK;
    }

    //没有未核实完毕的执行线索
    //执行线索表zxxs //xszt线索状态
    function aj_hghc_jy5(string memory ajbs) internal returns(uint)
    {
        string memory itemValue;
        string memory key;

        for(uint i = 0; ; i++)
        {
            key = LibString.concat("jghInfo.zxxs.", LibString.uint2str(i));
            key = LibString.concat(key, ".xszt");

            itemValue = czjl.aj_getInfo(ajbs, key);
            if(bytes(itemValue).length == 0)
            {
                break;
            }

            if(LibString.equal(itemValue, "09_05064-1") == false)
            {
                return RESULT_NOK;
            }
        }
        return RESULT_OK;
    }

    //未发现可供执行财产或发现的财产不能处置
    //已查明财产表ycmcc
    //cclx财产类型 //ccmc财产名称 //cczbjg财产甄别结果 //cczt财产状态 //ccbkzxyy财产不可执行原因
    function aj_hghc_jy6(string memory ajbs) internal returns(uint)
    {
        string memory itemValue;
        string memory key;
        
        for(uint i = 0; ; i++)
        {
            key = LibString.concat("jghInfo.ycmcc.", LibString.uint2str(i));
            key = LibString.concat(key, ".cclx");

            itemValue = czjl.aj_getInfo(ajbs, key);
            if(bytes(itemValue).length == 0)
            {
                break;
            }

            /*------------------------------
            */
        }
        return RESULT_OK;
    }

    //核查7 已向被执行人发出限制消费令，并将符合条件的被执行人纳入失信被执行人名单
    //执行主体信息表zxztxx
    //dsr当事人
    //dsrfldw当事人地位
    //dsrlx当事人类型
    //sfyzjg身份验证结果

    //限制高消费表xzgxf
    //bxzr被限制人
    //xzzl限制种类
    //jcrq解除日期
    function aj_hghc_jy7(string memory ajbs) internal returns(uint)
    {
        //string memory itemValue;
        //string memory key;


    }

    //核查8 已完成终本约谈且约谈日期必须早于结案日期
    //结案情况表jaqk
    //jarq结案日期
    //sqrsqzjbczxcx申请人申请终结本次执行程序

    //执行主体信息表zxztxx
    //dsr当事人
    //dsrfldw当事人地位

    //收案和立案信息表sahlaxx
    //laay立案案由

    //约谈表yt
    //bytr被约谈人
    //ytsj约谈事由
    //sftyzb是否同意终本
    function aj_hghc_jy8(string memory ajbs) internal returns(uint)
    {
        //string memory itemValue;
        //string memory key;


    }

    //核查9 尚未执行标的金额必须大于零
    //结案情况表jaqk
    //swzxbdje尚未执行标的金额
    //jabdje结案标的金额
    //cylxj迟延履行金
    //cylxlx迟延履行利息
    //sjdwje实际到位金额

    //收案和立案信息表zb1_sahlaxx
    //yzxbdje应执行标的金额
    
    //拍卖表pm
    //成交金额cjje


    //变卖表bm
    //bmze变卖总额

    //以物抵债表ywdz
    //zdje执抵金额

    //划拨表hb
    //划拨金额hbje
    function aj_hghc_jy9(string memory ajbs) internal returns(uint)
    {
        string memory itemValue;
        int jabdje = 0;
        int sjdwje = 0;

        //尚未执行标的金额 > 0
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.swzxbdje");
        if(LibString.toInt(itemValue) > 0)
        {
            return RESULT_OK;
        }
        
        //结案标的金额 -实际到位金额 >0
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.jabdje");
        jabdje = LibString.toInt(itemValue);
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.sjdwje");
        if(jabdje > sjdwje)
        {
            return RESULT_OK;
        }

        //应执行标的金额+迟延履行金+迟延履行利息-实际到位金额>0

        //[应执行标的金额]+[迟延履行金]+[迟延履行利息]-【划拨-划拨总额】-【拍卖-成交总额】-【变卖-变卖总额】-【以物抵债-折抵总额】

    }

    //已作出终本裁定,执行裁定书表zbnr_zxcds
    function aj_hghc_jy10(string memory ajbs) internal returns(uint)
    {
        string memory item;

        item = czjl.aj_getInfo(ajbs, "zdnrInfo.zxcds.0.ah");
        if(bytes(item).length == 0)
        {
            return RESULT_NOK;
        }
        return RESULT_OK;
    }

    //执行主体信息表zxztxx(list)
    //dsr当事人
	//dsrfldw当事人地位
	//dsrlx当事人类型
	//sfyzjg身份验证结果
    function aj_hghc_jy11(string memory ajbs) internal returns(uint)
    {
        string memory item;
        string memory fullkey;
        string memory prefix;

        for(uint i = 0; ; i++)
        {
            prefix = LibString.concat("jghinfo.zxztxx.", LibString.uint2str(i));
            fullkey = LibString.concat(prefix, ".dsrfldw");
            item = czjl.aj_getInfo(ajbs, fullkey);
            if(bytes(item).length == 0)
            {
                //不存在则结束查找
                break;
            }

            if(LibString.equal(item, BZXR))
            {
                fullkey = LibString.concat(prefix, ".dsrlx");
                item = czjl.aj_getInfo(ajbs, fullkey);

                if(LibString.equal(item ,FR) || LibString.equal(item ,FFRZZ))
                {
                    return RESULT_OK;
                }
            }
            else if(LibString.equal(item, ZRR))
            {
                fullkey = LibString.concat(prefix, ".sfyzjg");
                item = czjl.aj_getInfo(ajbs, fullkey);
                //身份验证不含死亡
                if(LibString.indexOf(item, SW) == -1)
                {
                    return RESULT_OK;
                }
            }
        }
        return RESULT_NOK;
    }

    //收案和立案信息表sahlaxx(object)
    //zxbdnr执行标的内容
    function aj_hghc_jy12(string memory ajbs) internal returns(uint)
    {
        string memory item;

        item = czjl.aj_getInfo(ajbs, "jghinfo.sahlaxx.zxbdnr");
        if(bytes(item).length == 0)
        {
            return RESULT_NOK;
        }
        if(LibString.equal(item, XW))
        {
            return RESULT_OK;
        }

        return RESULT_NOK;
    }

    //合规核查, 核查2和3需要内容结果?
    function aj_hghc(string memory ajbs, uint64 uuid) public returns(bool)
    {
        string[] memory keys = new string[](50);
        string[] memory values = new string[](50);
        uint ret = 0;
        uint pos = 0;
        
        //检验项1
        ret = aj_hghc_jy1(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 1, ret);

        //校验项2
        ret = aj_hghc_jy2(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 2, ret);

        //校验项3
        ret = aj_hghc_jy3(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 3, ret);

        //检验项4
        ret = aj_hghc_jy4(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 4, ret);

        //校验项5
        ret = aj_hghc_jy5(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 5, ret);


        //检验项6
        ret = aj_hghc_jy6(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 6, ret);

        //检验项7
        ret = aj_hghc_jy7(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 7, ret);


        //检验项8
        ret = aj_hghc_jy8(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 8, ret);

        //检验项9
        
        ret = aj_hghc_jy9(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 9, ret);

        //校验10
        
        ret = aj_hghc_jy10(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 10, ret);

        //校验项11
        ret = aj_hghc_jy11(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 11, ret);

        //校验项12
        ret = aj_hghc_jy12(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 12, ret);


        czjl.aj_setResult(uuid, keys, values);
        return true;
    }

    function aj_hghcjg(uint64 uuid) public view returns(string[] memory, string[] memory)
    {
        return czjl.aj_getResult(uuid);
    }

    function aj_setCzjlConstractAddr(address recordContractAddr) public
    {
        czjlAddr = recordContractAddr;
        czjl = CzjlContract(czjlAddr);
    }
} 