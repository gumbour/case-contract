pragma solidity >=0.4.22 <0.6.0;
//import "LibJson.sol";

import "JsmnSolLib.sol";

contract testjsonContract { //卷宗一致性核查
    function test() public returns(bool) {
        //using JsmnSolLib for *;
        string memory _json = "{\"_data\": {\"hgxjy\": [{\"jyx_id\": \"1\",\"qpnr\": \"发出执行通知书日期：2019年05月30日;报告财产令发出日期：空\",\"yjnr\": \"已制作并发出执行通知书、报告财产令；\",\"jyjg\": 1},{\"jyx_id\": 2,\"qpnr\": \"被执行人：许圣杰;查询范围：证券;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：银行;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：人行;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：MZ;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：不动产;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：互联网银行;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：工商总局;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：车辆;提起查询日期：2019年08月09日;被执行人：许圣杰;查询范围：BX;提起查询日期：2019年08月09日;\",\"nrmc\": \"1,1,1,1,1,1,1\",\"yjnr\": \"近3个月内，发起过对所有已开通查询功能的财产项目的总对总查询；\",\"jyjg\": 1},{\"jyx_id\": 3,\"qpnr\": \"财产调查：有记录;搜查：无记录;悬赏执行：无记录;司法审计：无记录;\",\"nrmc\": \"1,0,0,0\",\"yjnr\": \"已发起过传统查控（系统中有财产调查、搜查、悬赏执行、司法审计措施中的至少一种记录）;\",\"jyjg\": 1},{\"jyx_id\": 4,\"qpnr\": \"被调查人：许圣杰;调查内容：收益类保险、金融理财产品、股息红利、住房公积金;\",\"yjnr\": \"对被执行人的住房公积金（仅对自然人）、金融理财产品、收益类保险、股息红利作过调查；\",\"jyjg\": 1},{\"jyx_id\": 5,\"qpnr\": \"执行线索：无\",\"yjnr\": \"没有未核实完毕的执行线索；\",\"jyjg\": 1},{\"jyx_id\": 6,\"qpnr\": \"已查明财产：无\",\"yjnr\": \"未发现可供执行财产或发现的财产不能处置；\",\"jyjg\": 1},{\"jyx_id\": 7,\"qpnr\": \"被执行人：许圣杰;限制高消费记录：;被限制人：许圣杰,限制种类：限制高消费，解除日期：空;\",\"yjnr\": \"已向被执行人发出限制消费令，并将符合条件的被执行人纳入失信被执行人名单；\",\"jyjg\": 1},{\"jyx_id\": 8,\"qpnr\": \"本案符合此项规则的例外情况;结案日期：2019年09月22日;约谈记录：;空\",\"yjnr\": \"已完成终本约谈且约谈日期必须早于结案日期；\",\"jyjg\": 1},{\"jyx_id\": 9,\"qpnr\": \"尚未执行标的金额：400.0000;应执行标的金额：空;实际到位金额：0.0000;\",\"yjnr\": \"尚未执行标的金额必须大于零；\",\"jyjg\": 1}]},\"_code\": \"10000\",\"_msg\": \"SUCCESS\"}";
       // step01: 字符串入栈
       //LibJson.push(_json);
       /*string memory _json = '{ "key1": { "key1.1": "value", "key1.2": 3, "key1.3": true, "key1.4": "val2"} }';*/

       //LibJson.jsonRead(_json, "nodeId");     // "JZNCGP"
       // step03: 出栈
       //LibJson.pop();
       
       uint returnValue;
       JsmnSolLib.Token[] memory tokens;
       uint actualNum;

        (returnValue, tokens, actualNum) = JsmnSolLib.parse(_json, 500);

        require(returnValue==0, "json parse error");
        require(JsmnSolLib.strCompare(JsmnSolLib.getBytes(_json, tokens[3].start, tokens[3].end), 'jyx_id') == 0, "get key error");
        require(JsmnSolLib.strCompare(JsmnSolLib.getBytes(_json, tokens[3].start, tokens[3].end), '1') == 0, "value error");
        require(actualNum == 100, "key num error");
        return true;
    }
} 