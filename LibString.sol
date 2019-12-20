pragma solidity >=0.4.22 <0.6.0;

contract LibString {
    function concat(string memory _self, string memory _str) internal returns (string memory _ret) {
        uint idx = 0;
        uint i = 0;
        bytes memory bself = bytes(_self);
        bytes memory bstr = bytes(_str);

        _ret = new string(bytes(_self).length + bytes(_str).length);
        bytes memory bret = bytes(_ret);
        
        for(i = 0; i < bytes(_self).length; i++)
        {
            bret[idx++] = bself[i];
        }
        
        for(i = 0; i < bytes(_str).length; i++)
        {
            bret[idx++] = bstr[i];
        }
    }

    function uint2str(uint i) internal returns (string memory c) {
        uint p = i;
        if (p == 0) return "0";
        uint j = p;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (p != 0){
            bstr[k--] = byte((uint8)(48 + p % 10));
            p /= 10;
        }
        c = string(bstr);
    }

    function toInt(string memory _self) internal returns (int _ret) {
        _ret = 0;
        if (bytes(_self).length == 0) {
            return _ret;
        }
        
        uint16 i;
        uint8 digit;
        for (i=0; i<bytes(_self).length; ++i) {
            digit = uint8(bytes(_self)[i]);
            if (!(digit == 0x20 || digit == 0x09 || digit == 0x0D || digit == 0x0A)) {
                break;
            }
        }
        
        bool positive = true;
        if (bytes(_self)[i] == '+') {
            positive = true;
            i++;
        } else if(bytes(_self)[i] == '-') {
            positive = false;
            i++;
        }

        for (; i<bytes(_self).length; ++i) {
            digit = uint8(bytes(_self)[i]);
            if (!(digit >= 0x30 && digit <= 0x39)) {
                return _ret;
            }
            _ret = _ret*10 + int(digit-0x30);
        }

        if (!positive) {
            _ret = -_ret;
        }
    }

    function toUint(string memory _self) internal returns (uint _ret) {
        return uint(toInt(_self));
    }

    function equal(string memory _self, string memory str) internal returns(bool)
    {
        return keccak256(bytes(_self)) == keccak256(bytes(str));
    }
}
