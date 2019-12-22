pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public returns(string memory _ret);
        function aj_regContractAddr(string memory name, string memory addr) public;
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
    string constant SQR = "09_05036-1"; //申请人
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
    string constant YHCK = "09_ZX0015-2"; //财产类型为银行存款标识
    string constant HLWJR = "09_ZX0015-3"; //财产类型为互联网金融标识
    string constant RMFY = "人民法院";
    string constant XZGXF = "限制高消费";
    int  constant FDSDW  = 10000;

    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);

    struct BdcrInfo {
        string bdcr;
        string bdcrlx;
        bool[4] ccdcqk;
    }

    function aj_hghc_jl(string[] memory keys, string[] memory values, uint pos, uint jyid, uint result, uint id) internal returns(uint)
    {
        uint index = pos;
        string memory prefix;
        string[2] memory resultK = [".jyx_id", ".jyjg"];
        string[2] memory resultV = ["0", "1"];

        //jyx_id
        prefix = LibString.concat("hgxjy.", LibString.uint2str(id));
        keys[index] = LibString.concat(prefix, resultK[0]);
        values[index] = LibString.uint2str(jyid);
        index++;

        //jyjg
        keys[index] = LibString.concat(prefix, resultK[1]);
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
        string memory item;
        string memory fullkey;
        string memory prefix;
        uint jarq = 0;
        uint tqcxrq = 0;
        uint i = 0;
        uint j = 0;
        bool bRh;
        bool bCxfw;
        bool bHasNotLwqk;
        string[9] memory dsrly = ["村委会","村民委员会","居民委员会","村民小组","居民小组","业主委员会","业委会","业主大会","分公司"];
        string[6] memory cxfw = ["商业银行","证券","互联网银行","车辆","不动产","工商总局"];

        bRh = false;
        bCxfw = false;
        bHasNotLwqk = false;

        item = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.jarq");
        jarq = LibString.toUint(item);

        //例外 法律地位为被执行人的当事人，名称中含有“村委会”“居委会”“村民委员会”“居民委员会”
        //“村民小组”“居民小组”“业主委员会”“业委会”“业主大会”“分公司”之一；且组织机构代码=''
        for(i = 0; ; i++)
        {
            prefix = LibString.concat("jghInfo.wlckxx.", LibString.uint2str(i));
            fullkey = LibString.concat(prefix, ".dsr");
            item = czjl.aj_getInfo(ajbs, fullkey);
            if(bytes(item).length == 0)
            {
                break;
            }

            //todo 组织机构代码 如何得到---------
            for(j = 0; j < dsrly.length; j++)
            {
                if(LibString.indexOf(item, dsrly[i]) != -1)
                {
                    continue;//例外情况
                }
            }

            bHasNotLwqk = true;

            fullkey = LibString.concat(prefix, ".tqcxrq");
            item = czjl.aj_getInfo(ajbs, fullkey);
            tqcxrq = LibString.toUint(item);

            if(jarq == 0)
            {
                jarq = now;
            }

            //提起查询时间和结案日期的差≤3个月+1天
            if(tqcxrq <= jarq + 91*24*3600)
            {
                fullkey = LibString.concat(prefix, ".cxfw");
                item = czjl.aj_getInfo(ajbs, fullkey);
                if(bCxfw == false)
                {
                    //查询范围字段含有特定字符
                    for(j = 0; j < cxfw.length; j++)
                    {
                        if(LibString.indexOf(item, cxfw[i]) == -1)
                        {
                            break;
                        }
                    }
                    if(j == cxfw.length)
                    {
                        bCxfw = true;
                    }
                }

                if((bRh == false) && (LibString.equal(item, "人行")))
                {
                    bRh = true;
                }

                if((bCxfw == true) && (bRh == true))
                {
                    return RESULT_OK;
                }
            }
        }

        //有非例外的情况, 没有通过判断条件
        if(bHasNotLwqk == true)
        {
            return RESULT_NOK;
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
        string memory item;
        string memory key;
        string memory prefix;
        int zhje = 0;
        int yzxbdje = 0;
        
        for(uint i = 0; ; i++)
        {
            //以查明财产
            prefix = LibString.concat("jghInfo.ycmcc.", LibString.uint2str(i));
            key = LibString.concat(prefix, ".cclx");

            item = czjl.aj_getInfo(ajbs, key);
            if(bytes(item).length == 0)
            {
                break;
            }

            /*(1)财产类型为银行存款或互联网金融 (2)账户余额小于1000 (3)账户余额除以应执行标的金额≤5%*/
            if(LibString.equal(item, YHCK) || LibString.equal(item, HLWJR))
            {
                //获取账号余额 满足条件则continue;
                key = LibString.concat(prefix, ".ccje");
                item = czjl.aj_getInfo(ajbs, key);

                //4位小数
                zhje = LibString.parseInt(item, 4);

                //账户余额小于1000 && 账户余额除以应执行标的金额≤5%
                item = czjl.aj_getInfo(ajbs, "jghInfo.sahlaxx.yzxbdje");
                yzxbdje = LibString.parseInt(item, 4);

                if((zhje < 1000*FDSDW) && (zhje*100 <= yzxbdje*5))
                {
                    continue;
                }
                //不满足条件则继续下面的检查
            }

            //记录中的【财产不可执行原因】字段都不为空
            key = LibString.concat(prefix, ".ccbkzxyy");
            item = czjl.aj_getInfo(ajbs, key);
            if(bytes(item).length != 0)
            {
                continue;
            }

            return RESULT_NOK;
            /*todo关联表无法拿到, 先不做下面逻辑*/
            /*该财产可关联对应到处置结果信息：即拍卖表-成交价格/拍卖日期!=''或变卖表-变卖总额/变卖结束日期!=''
            或以物抵债表-折抵金额/折抵日期!=''或划拨表-划拨金额/划拨日期!=''
            或强制管理表-开始日期!=''或扣留提取表-扣留提取金额/扣留或提取日期!=''*/
        }
        return RESULT_OK;
    }

    //限制高消费表xzgxf
    function aj_hghc_jy7_check_dsr(string memory ajbs, string memory dsrlx, string memory bh, uint jarq) internal returns(bool)
    {
        string memory prefix;
        string memory key;
        string memory item;
        uint jcrq;
        bool bXzgxf;
        bXzgxf = true;

        if(LibString.equal(dsrlx, ZRR))
        {
            /*1、法律地位为被执行人的当事人类型为自然人，则当事人序号与限制高消费表中的【被限制人】序号一一对应，
            且【限制种类】字段包含[限制高消费],且【解除日期】都为空或字段值>结案日期/当前日期；*/
            for(uint i = 0; ; i++)
            {
                prefix = LibString.concat("jghInfo.xzgxf.", LibString.uint2str(i));
                key = LibString.concat(prefix, ".bxzr");
                item = czjl.aj_getInfo(ajbs, key);
                if(bytes(item).length == 0)
                {
                    break;
                }
                if(LibString.equal(item, bh) == false)
                {
                    continue;
                }

                prefix = LibString.concat("jghInfo.xzgxf.", LibString.uint2str(i));
                key = LibString.concat(prefix, ".xzzl");
                item = czjl.aj_getInfo(ajbs, key);
                if(bytes(item).length == 0)
                {
                    break;
                }

                if(LibString.indexOf(item, XZGXF) != -1)
                {
                    key = LibString.concat(prefix, ".jcrq");
                    item = czjl.aj_getInfo(ajbs, key);
                    jcrq = LibString.toUint(item);

                    if((jcrq == 0) || ((jarq != 0) && (jcrq > jarq)) || ((jarq == 0) && (jcrq > now)))
                    {
                        return true;
                    }
                }
            }
        }
        else
        {
            /*2、法律地位为被执行人的当事人类型为非自然人的被执行人有几个,
            在限制高消费表中的【被限制人】序号中至少有几个四位数序号*/
            for(uint i = 0; ; i++)
            {
                prefix = LibString.concat("jghInfo.xzgxf.", LibString.uint2str(i));
                key = LibString.concat(prefix, ".bxzr");
                item = czjl.aj_getInfo(ajbs, key);
                if(bytes(item).length == 0)
                {
                    break;
                }

                if(bytes(item).length >= 4)
                {
                    return true;
                }
            }
        }

        return false;
    }
    //核查7 已向被执行人发出限制消费令，并将符合条件的被执行人纳入失信被执行人名单
    //执行主体信息表zxztxx
    //dsr当事人
    //dsrfldw当事人地位
    //dsrlx当事人类型
    //sfyzjg身份验证结果
    //xh 序号

    //限制高消费表xzgxf
    //bxzr被限制人
    //xzzl限制种类
    //jcrq解除日期
    function aj_hghc_jy7(string memory ajbs) internal returns(uint)
    {
        string memory item;
        string memory key;
        string memory prefix;
        string memory dsrlx;
        uint jarq = 0;

        item = czjl.aj_getInfo(ajbs, "jghinfo.jaqk.jarq");
        jarq = LibString.toUint(item);

        for(uint i = 0; ;i++)
        {
            //获取当事人编号
            prefix = LibString.concat("jghInfo.zxztxx.", LibString.uint2str(i));
            key = LibString.concat(prefix, ".xh");
            item = czjl.aj_getInfo(ajbs, key);
            if(bytes(item).length == 0)
            {
                break;
            }

            key = LibString.concat(prefix, ".dsrlx");
            dsrlx = czjl.aj_getInfo(ajbs, key);

            //检查当前编号的当事人是否限制高消费
            if(aj_hghc_jy7_check_dsr(ajbs, dsrlx, item, jarq) == false)
            {
                return RESULT_NOK;
            }
        }

        return RESULT_OK;
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
        string memory item;
        string memory prefix;
        string memory fullkey;
        uint i = 0;
        uint ytsj = 0;
        uint pdsj = 0;
        string[13] memory salaay = ["3201","3202","3203","3204","3205","3234",
        "3235","3230","3231","3366","3367","3232","3233"];

        //首先进行例外检查, 满足例外则认为满足
        //例外1 申请执行人申请终结本次执行程序
        item = czjl.aj_getInfo(ajbs, "jghinfo.jaqk.sqrsqzjbczxcx");
        if(LibString.equal(item, "1"))
        {
            return RESULT_OK;
        }
        
        //例外2 法律地位为申请执行人的当事人，名称里含有【人民法院】关键字
        for(i = 0; ; i++)
        {
            prefix = LibString.concat("jghinfo.zxztxx.", LibString.uint2str(i));
            fullkey = LibString.concat(prefix, ".dsrfldw");
            item = czjl.aj_getInfo(ajbs, fullkey);
            if(bytes(item).length == 0)
            {
                break;
            }

            if(LibString.equal(item, SQR))
            {
                fullkey = LibString.concat(prefix, ".dsr");
                item = czjl.aj_getInfo(ajbs, fullkey);

                if(LibString.indexOf(item, RMFY) != -1)
                {
                    return RESULT_OK;
                }
            }
        }

        //例外3 收案和立案信息表中的立案案由为salayy中的一项
        for(i = 0; i < salaay.length; i++)
        {
            item = czjl.aj_getInfo(ajbs, "jghinfo.sahlaxx.laay");
            if(bytes(item).length == 0)
            {
                break;
            }
            if(LibString.equal(item, salaay[i]))
            {
                return RESULT_OK;
            }
        }

        item = czjl.aj_getInfo(ajbs, "jghinfo.jaqk.jarq");
        
        if(bytes(item).length == 0)
        {
            /*1、如案件结案日期为空(未结案),约谈表里至少有一条记录符合以下条件:[约谈时间]≤当前日期,且[是否同意终本]字段不为空*/
            pdsj = now;
        }
        else
        {
            /*2、如案件结案日期不为空(已结案),约谈表里至少有一条记录符合以下条件[约谈时间]≤结案日期,且[是否同意终本]字段不为空*/
            pdsj = LibString.toUint(item);
        }

        for(i = 0; ; i++)
        {
            prefix = LibString.concat("jghinfo.yt.", LibString.uint2str(i));
            fullkey = LibString.concat(prefix, ".ytsj");
            item = czjl.aj_getInfo(ajbs, fullkey);
            ytsj = LibString.toUint(item);
            if(bytes(item).length == 0)
            {
                break;
            }

            fullkey = LibString.concat(prefix, ".sftyzb");
            item = czjl.aj_getInfo(ajbs, fullkey);

            if((bytes(item).length != 0) && (ytsj != 0) && (ytsj <= pdsj))
            {
                return RESULT_OK;
            }
        }

        return RESULT_NOK;
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
        string memory item;

        //尚未执行标的金额 > 0
        item = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.swzxbdje");
        if(LibString.toInt(item) > 0)
        {
            return RESULT_OK;
        }

        return RESULT_NOK;
        //结案标的金额 -实际到位金额 >0
        /*int jabdje = 0;
        int sjdwje = 0;
        item = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.jabdje");
        jabdje = LibString.toInt(item);
        item = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.sjdwje");
        if(jabdje > sjdwje)
        {
            return RESULT_OK;
        }

        //应执行标的金额+迟延履行金+迟延履行利息-实际到位金额>0

        //[应执行标的金额]+[迟延履行金]+[迟延履行利息]-【划拨-划拨总额】-【拍卖-成交总额】-【变卖-变卖总额】-【以物抵债-折抵总额】
        */
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
        pos = aj_hghc_jl(keys, values, pos, 1, ret, 0);

        //校验项2
        ret = aj_hghc_jy2(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 2, ret, 1);

        //校验项3
        ret = aj_hghc_jy3(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 3, ret, 2);

        //检验项4
        ret = aj_hghc_jy4(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 4, ret, 3);

        //校验项5
        ret = aj_hghc_jy5(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 5, ret, 4);


        //检验项6
        ret = aj_hghc_jy6(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 6, ret, 5);

        //检验项7
        ret = aj_hghc_jy7(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 7, ret, 6);


        //检验项8
        ret = aj_hghc_jy8(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 8, ret, 7);

        //检验项9
        
        ret = aj_hghc_jy9(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 9, ret, 8);

        //校验10
        
        ret = aj_hghc_jy10(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 10, ret, 9);

        //校验项11
        ret = aj_hghc_jy11(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 11, ret, 10);

        //校验项12
        ret = aj_hghc_jy12(ajbs);
        pos = aj_hghc_jl(keys, values, pos, 14, ret, 11);


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
        czjl.aj_regContractAddr("hghc", LibString.addrToString(address(this)));
    }
}