pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public view returns(string memory _ret);
}

import "./LibString.sol";

contract HghcContract { //合规核查
    using LibString for *;
    uint constant MAX_ITEM = 30;

    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);

    //执行通知书有无记录zxtz, 发起执行通知书日期和报告财产令
    function aj_hghc_jy1(string memory ajbs) internal returns(bool)
    {
        string memory itemValue;

        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.zxtz.fczxtzsrq");
        if(bytes(itemValue).length == 0)
        {
            return false;
        }

        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.bgccl.bgcclfcrq");
        if(bytes(itemValue).length == 0)
        {
            return false;
        }

        return true;
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
    function aj_hghc_jy2(string memory ajbs) internal returns(bool)
    {
        string memory itemValue;
        string memory key;

        for(uint i = 0; i < MAX_ITEM; i++)
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

        return true;
    }
    

    //校验3 财产调查表、搜查表、悬赏执行表、司法审计表至少有一个表里有记录
    function aj_hghc_jy3(string memory ajbs) internal returns(bool)
    {
        string memory itemValue;
        
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.ccdc.0.bdcr");
        if(bytes(itemValue).length != 0)
        {
            return true;
        }
        itemValue = czjl.aj_getInfo(ajbs, "zdnrInfo.scl.0.ah");
        if(bytes(itemValue).length != 0)
        {
            return true;
        }
        itemValue = czjl.aj_getInfo(ajbs, "zdnrInfo.xsgg.0.ah");
        if(bytes(itemValue).length != 0)
        {
            return true;
        }
        itemValue = czjl.aj_getInfo(ajbs, "zdnrInfo.sfsjbg.0.ah");
        if(bytes(itemValue).length != 0)
        {
            return true;
        }

        return true;
    }

    //对被执行人的住房公积金（仅对自然人）、金融理财产品、收益类保险、股息红利作过调查
    //财产调查表ccdc //bdcr被调查人 //dcnr调查内容
    function aj_hghc_jy4(string memory ajbs) internal returns(bool)
    {

    }

    //没有未核实完毕的执行线索
    //执行线索表zxxs //xszt线索状态
    function aj_hghc_jy5(string memory ajbs) internal returns(bool)
    {
        string memory itemValue;
        string memory key;

        for(uint i = 0; i < MAX_ITEM; i++)
        {
            key = LibString.concat("jghInfo.zxxs.", LibString.uint2str(i));
            key = LibString.concat(key, ".xszt");

            itemValue = czjl.aj_getInfo(ajbs, key);
            if(bytes(itemValue).length == 0)
            {
                break;
            }

            if(LibString.equal(itemValue, "09_05064-1") == 0)
            {
                return false;
            }
        }
        return true;
    }

    //未发现可供执行财产或发现的财产不能处置
    //已查明财产表ycmcc
    //cclx财产类型 //ccmc财产名称 //cczbjg财产甄别结果 //cczt财产状态 //ccbkzxyy财产不可执行原因
    function aj_hghc_jy6(string memory ajbs) internal returns(bool)
    {
        string memory itemValue;
        string memory key;
        
        for(uint i = 0; i < MAX_ITEM; i++)
        {
            key = LibString.concat("jghInfo.ycmcc.", LibString.uint2str(i));
            key = LibString.concat(key, ".cclx");

            itemValue = czjl.aj_getInfo(ajbs, key);
            if(bytes(itemValue).length == 0)
            {
                break;
            }

            /*------------------------------
            if(LibString.equal(itemValue, "09_05064-1") == 0)
            {
                return false;
            }*/
        }
        return true;
    }

    //核查7 已向被执行人发出限制消费令，并将符合条件的被执行人纳入失信被执行人名单
    function aj_hghc_jy7(string memory ajbs) internal returns(bool)
    {
        //string memory itemValue;
        //string memory key;


    }

    //核查8 已完成终本约谈且约谈日期必须早于结案日期
    function aj_hghc_jy8(string memory ajbs) internal returns(bool)
    {
        //string memory itemValue;
        //string memory key;


    }

    //核查9 尚未执行标的金额必须大于零
    function aj_hghc_jy9(string memory ajbs) internal returns(bool)
    {
        string memory itemValue;
        uint jabdje = 0;
        uint sjdwje = 0;

        //尚未执行标的金额 > 0
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.swzxbdje");
        if(LibString.toint(itemValue) > 0)
        {
            return true;
        }
        
        //结案标的金额 -实际到位金额 >0
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.jabdje");
        jabdje = LibString.toint(itemValue);
        itemValue = czjl.aj_getInfo(ajbs, "jghInfo.jaqk.sjdwje");
        if(jabdje > sjdwje)
        {
            return true;
        }

        //应执行标的金额+迟延履行金+迟延履行利息-实际到位金额>0

        //[应执行标的金额]+[迟延履行金]+[迟延履行利息]-【划拨-划拨总额】-【拍卖-成交总额】-【变卖-变卖总额】-【以物抵债-折抵总额】

    }

    //合规核查, 核查2和3需要内容结果?
    function aj_hghc(string memory ajbs, uint64 uuid) public returns(bool)
    {
        string[] memory keys = new string[](50);
        string[] memory values = new string[](50);
        uint idx = 0;
        string[2] memory resultK = ["jyx_id", "jyjg"];
        string[2] memory resultV = ["0", "1"];
        
        //检验项1
        //执行通知书有无记录zxtz, 发起执行通知书日期和报告财产令
        keys[idx] = resultK[0];
        values[idx++] = LibString.uint2str(idx);
        keys[idx] = resultK[1];
        if(aj_hghc_jy1(ajbh) == true)
        {
            values[idx++] = resultV[1];
        }
        else
        {
            values[idx++] = resultV[0];
        }

        //校验项2
        keys[idx] = resultK[0];
        values[idx++] = LibString.uint2str(idx);
        keys[idx] = resultK[1];
        if(aj_hghc_jy2(ajbh) == true)
        {
            values[idx++] = resultV[1];
        }
        else
        {
            values[idx++] = resultV[0];
        }

        //校验项3
        keys[idx] = resultK[0];
        values[idx++] = LibString.uint2str(idx);
        keys[idx] = resultK[1];
        if(aj_hghc_jy3(ajbh) == true)
        {
            values[idx++] = resultV[1];
        }
        else
        {
            values[idx++] = resultV[0];
        }

        //检验项4
        keys[idx] = resultK[0];
        values[idx++] = LibString.uint2str(idx);
        keys[idx] = resultK[1];
        if(aj_hghc_jy4(ajbh) == true)
        {
            values[idx++] = resultV[1];
        }
        else
        {
            values[idx++] = resultV[0];
        }

        //校验项5
        keys[idx] = resultK[0];
        values[idx++] = LibString.uint2str(idx);
        keys[idx] = resultK[1];
        if(aj_hghc_jy5(ajbh) == true)
        {
            values[idx++] = resultV[1];
        }
        else
        {
            values[idx++] = resultV[0];
        }


        //检验项6
        

        //检验项7
        //执行主体信息表zxztxx
        //dsr当事人
        //dsrfldw当事人地位
        //dsrlx当事人类型
        //sfyzjg身份验证结果

        //限制高消费表xzgxf
        //bxzr被限制人
        //xzzl限制种类
        //jcrq解除日期


        //检验项8
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

        //检验项9
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

        //校验10
        //结案情况表jaqk
        //jarq结案日期
	    //jafs结案方式
	    //jaws结案文书

        //执行裁定书表zbnr_zxcds
        //pjzw

        //校验项11
        //执行主体信息表zxztxx
        //dsr当事人
	    //dsrfldw当事人地位
	    //dsrlx当事人类型
	    //sfyzjg身份验证结果

        //校验项12
        //收案和立案信息表sahlaxx
        //zxbdnr执行标的内容




        //string memory bgccl = czjl.aj_getInfo(ah, "jghInfo.bgccl.bgcclfcrq");
        /*for(uint i = 0; i < 14; i++)
        {
            //jyx_id
            index = LibString.uint2str(i+1);
            prex = LibString.concat("hgxjy.", index);
            key = LibString.concat(prex, "jyx_id");
            keys[idx] = key;
            values[idx] = index;
            idx++;
            //jyjg
            key = LibString.concat(prex, "jyjg");
            keys[idx] = key;
            values[idx] = "1";
            idx++;
        }*/

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