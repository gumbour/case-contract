pragma solidity >=0.4.22 <0.6.0;
//import "LibJson.sol";

contract CzjlContract { //操作记录  
    //using LibJson for *;
    
    struct Baqx //办案期限表
    {
        bytes fdzxqx; //法定执行期限
        bytes sjzxts; //实际执行天数
        bytes zxcqts; //执行超期天数
    }
    
    struct Ajxx { //案件信息
        string   ah;    //案号
        string   ajbs;  //案件标识
        /*bytes    ajxx;*/  //案件信息
        Baqx baqx;  //办案期限
    }
    
     
    //ajbs->ajxx 
    //mapping( string => Ajxx ) public ajMap;
    
    /*{baqx:{fdzxqx:"184",sjzxts:"27",zxcqts:"0"}}*/

    //记录案件信息, 输入案号, 案件标识, 案件信息(json)
    function aj_xxjl(string ah, string ajbs, string anjxx) public returns(bool){
        //Baqx memory baqx = Baqx({fdzxqx : "2019-12-11", sjzxts: "10", zxcqts: "1"});
        //ajMap[ah] = Ajxx({ah : ah, ajbs:ajbs, baqx : baqx});
        //string memory _json = "{\"baqx\": {\"fdzxqx\": \"184\",\"sjzxts\": \"27\",\"zxcqts\": \"0\"}}";
        //LibJson.push("{\"baqx\": {\"fdzxqx\": \"184\",\"sjzxts\": \"27\",\"zxcqts\": \"0\"}}");
        //string memory info = jsonRead("{\"baqx\": {\"fdzxqx\": \"184\",\"sjzxts\": \"27\",\"zxcqts\": \"0\"}}","baqx");
        
        //_json.jsonRead("baqx");

        //LibJson.pop();
        return true;
    }
    
    function aj_czjl(string ah, string ajbs, string optType) public returns(string _ret)
    {
        _ret = "{\"ajbs\": \"184\",\"ajlswybs\": \"27\",\"jllx\": \"hch\"}";
    }
}