pragma solidity >=0.4.22 <0.6.0;

library LibString {
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

    // parseInt(parseFloat*10^_b)
    function parseInt(string memory _a, uint _b) internal pure returns (int) {
        bytes memory bresult = bytes(_a);
        int mint = 0;
        bool decimals = false;
        bool negative = false;
        uint b = _b;

        for (uint i = 0; i < bresult.length; i++){
            if ((i == 0) && (bresult[i] == '-')) {
                negative = true;
            }
            if ((uint8(bresult[i]) >= 48) && (uint8(bresult[i]) <= 57)) {
                if (decimals){
                   if (b == 0) break;
                    else b--;
                }
                mint *= 10;
                mint += uint8(bresult[i]) - 48;
            } else if (uint8(bresult[i]) == 46) decimals = true;
        }
        if (b > 0) mint *= int(10**b);
        if (negative) mint *= -1;
        return mint;
    }

    function equal(string memory _self, string memory str) internal returns(bool)
    {
        bytes memory _baseBytes = bytes(_self);
        bytes memory _valueBytes = bytes(str);

        if (_baseBytes.length != _valueBytes.length) {
            return false;
        }

        for (uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] != _valueBytes[i]) {
                return false;
            }
        }

        return true;
    }

    function _indexOf(string memory _base, string memory _value, uint _offset)
        internal
        pure
        returns (int) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length == 1);

        for (uint i = _offset; i < _baseBytes.length; i++) {
            if (_baseBytes[i] == _valueBytes[0]) {
                return int(i);
            }
        }

        return -1;
    }

    function indexOf(string memory _base, string memory _value)
        internal
        pure
        returns (int) {
        return _indexOf(_base, _value, 0);
    }

    function addrToString(address _self) internal returns (string memory _ret) {
        uint160 self = uint160(_self);

        _ret = new string(20*2 + 2);
        bytes(_ret)[0] = '0';
        bytes(_ret)[1] = 'x';

        for (uint8 i = 41; i>=2; --i)
        {
            uint8 digit = uint8(self&0x0F);
            self /= 16;

            if (digit < 10)
                bytes(_ret)[i] = byte(digit+0x30);
            else
                bytes(_ret)[i] = byte(digit-10+0x61);
        }
    }
}
