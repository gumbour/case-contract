pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public returns(string memory _ret);
        function aj_regContractAddr(string memory name, address addr) public;
}

import "./LibString.sol";

contract JzyzxhcContract { //卷宗一致性核查
    uint constant MAX_ITEM = 30;

    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);
    
    //执行通知书中的案号与当前案件一致
    function aj_jzyzxhc_zxtzs_ah(string memory ajbs) internal returns(bool)
    {
        string memory itemValue1;
        string memory itemValue2;
        string memory key;
        uint i = 0;
        
        //执行通知书中的案号与当前案件一致
        itemValue1 = czjl.aj_getInfo(ajbs, "jghinfo.bshztxx.ah");
        if(bytes(itemValue1).length == 0)
        {
            return false;
        }
        for(i = 0; i < MAX_ITEM; i++)
        {
            key = LibString.concat("zdnrInfo.zxtzs.", LibString.uint2str(i));
            key = LibString.concat(key, ".ah");
            itemValue2 = czjl.aj_getInfo(ajbs, key);
            if(bytes(itemValue2).length == 0)
            {
                break;
            }

            if(LibString.equal(itemValue1, itemValue2))
            {
                return true;
            }
        }
        
        return false;
    }

    //执行通知书中的被执行人与案件信息一致
    function aj_jzyzxhc_zxtzs_bzxr(string memory ajbs) internal returns(bool)
    {
        string memory itemValue1;
        string memory itemValue2;
        string memory key;
        uint i = 0;
        uint j = 0;
        
        for(i = 0; i < MAX_ITEM; i++)
        {
            key = LibString.concat("jghinfo.zxztxx.", LibString.uint2str(i));
            key = LibString.concat(key, ".dsr");

            itemValue1 = czjl.aj_getInfo(ajbs, key);
            if(bytes(itemValue1).length == 0)
            {
                break;
            }

            for(j = 0; j < MAX_ITEM; j++)
            {
                key = LibString.concat("zdnrInfo.zxtzs.", LibString.uint2str(j));
                key = LibString.concat(key, ".bzxrmc");
                itemValue2 = czjl.aj_getInfo(ajbs, key);

                if(bytes(itemValue1).length == 0)
                {
                    return false;
                }

                if(LibString.equal(itemValue1, itemValue2))
                {
                    break;
                }
            }

            if(j == MAX_ITEM)
            {
                return false;
            }
            
        }
        
        return false;
    }

    function aj_jzyzxhc(string memory ajbs, uint64 uuid) public returns(bool)
    {
        

        //czjl.aj_setResult(uuid, keys, values);
        return true;
    }

    function aj_jzyzxhcjg(uint64 uuid) public view returns(string[] memory, string[] memory)
    {
        return czjl.aj_getResult(uuid);
    }

    function aj_setCzjlConstractAddr(address recordContractAddr) public
    {
        czjlAddr = recordContractAddr;
        czjl = CzjlContract(czjlAddr);
        czjl.aj_regContractAddr("jzyzxhc", address(this));
    }
} 