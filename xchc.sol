pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract CzjlContract {
        function aj_setResult(uint64 uuid, string[] memory keys, string[] memory values) public;
        function aj_getResult(uint64 uuid) public view returns(string[] memory keys, string[] memory values);
        function aj_getInfo(string memory ajbs, string memory key) public view returns(string memory _ret);
}

import "./LibString.sol";

contract XchcContract { //案件瑕疵核查
    address public czjlAddr;
    CzjlContract czjl = CzjlContract(czjlAddr);

    function aj_xchc_jl(string[] memory keys, string[] memory values, uint pos, uint jyid, uint result) internal returns(uint)
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

    function aj_xchc(string memory ajbs, uint64 uuid) public returns(bool)
    {
        

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