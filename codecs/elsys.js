        /*
  ______ _       _______     _______ 
 |  ____| |     / ____\ \   / / ____|
 | |__  | |    | (___  \ \_/ / (___  
 |  __| | |     \___ \  \   / \___ \ 
 | |____| |____ ____) |  | |  ____) |
 |______|______|_____/   |_| |_____/ 
 
  ELSYS simple payload decoder. 
  Use it as it is or remove the bugs :)
  www.elsys.se
  peter@elsys.se
*/
function bin16dec(bin) {
    var num = bin & 0xFFFF;
    if (0x8000 & num)
        num = -(0x010000 - num);
    return num;
}

function bin8dec(bin) {
    var num = bin & 0xFF;
    if (0x80 & num)
        num = -(0x0100 - num);
    return num;
}

function hexToBytes(hex) {
    for (var bytes = [], c = 0; c < hex.length; c += 2)
        bytes.push(parseInt(hex.substr(c, 2), 16));
    return bytes;
}

function Decode(fPort, bytes) {

    var TYPE_TEMP = 0x01; //temp 2 bytes -3276.8°C -->3276.7°C
    var TYPE_RH = 0x02; //Humidity 1 byte  0-100%
    var TYPE_ACC = 0x03; //acceleration 3 bytes X,Y,Z -128 --> 127 +/-63=1G
    var TYPE_LIGHT = 0x04; //Light 2 bytes 0-->65535 Lux
    var TYPE_MOTION = 0x05; //No of motion 1 byte  0-255
    var TYPE_CO2 = 0x06; //Co2 2 bytes 0-65535 ppm
    var TYPE_VDD = 0x07; //VDD 2byte 0-65535mV
    var TYPE_ANALOG1 = 0x08; //VDD 2byte 0-65535mV
    var TYPE_GPS = 0x09; //3bytes lat 3bytes long binary
    var TYPE_PULSE1 = 0x0A; //2bytes relative pulse count
    var TYPE_PULSE1_ABS = 0x0B; //4bytes no 0->0xFFFFFFFF
    var TYPE_EXT_TEMP1 = 0x0C; //2bytes -3276.5C-->3276.5C
    var TYPE_EXT_DIGITAL = 0x0D; //1bytes value 1 or 0
    var TYPE_EXT_DISTANCE = 0x0E; //2bytes distance in mm
    var TYPE_ACC_MOTION = 0x0F; //1byte number of vibration/motion
    var TYPE_IR_TEMP = 0x10; //2bytes internal temp 2bytes external temp -3276.5C-->3276.5C
    var TYPE_OCCUPANCY = 0x11; //1byte data
    var TYPE_WATERLEAK = 0x12; //1byte data 0-255
    var TYPE_GRIDEYE = 0x13; //65byte temperature data 1byte ref+64byte external temp
    var TYPE_PRESSURE = 0x14; //4byte pressure data (hPa)
    var TYPE_SOUND = 0x15; //2byte sound data (peak/avg)
    var TYPE_PULSE2 = 0x16; //2bytes 0-->0xFFFF
    var TYPE_PULSE2_ABS = 0x17; //4bytes no 0->0xFFFFFFFF
    var TYPE_ANALOG2 = 0x18; //2bytes voltage in mV
    var TYPE_EXT_TEMP2 = 0x19; //2bytes -3276.5C-->3276.5C
    var TYPE_EXT_DIGITAL2 = 0x1A; // 1bytes value 1 or 0
    var TYPE_EXT_ANALOG_UV = 0x1B; // 4 bytes signed int (uV)
    var TYPE_TVOC = 0x1C; // 2 bytes (ppb)
    var TYPE_DEBUG = 0x3D; // 4bytes debug

    var obj = new Object();
    for (i = 0; i < bytes.length; i++) {
        //console.log(data[i]);
        switch (bytes[i]) {
        case TYPE_TEMP: //Temperature
            var temp = (bytes[i + 1] << 8) | (bytes[i + 2]);
            temp = bin16dec(temp);
            obj.temperature = temp / 10;
            i += 2;
            break
        case TYPE_RH: //Humidity
            var rh = (bytes[i + 1]);
            obj.humidity = rh;
            i += 1;
            break
        case TYPE_ACC: //Acceleration
            obj.x = bin8dec(bytes[i + 1]);
            obj.y = bin8dec(bytes[i + 2]);
            obj.z = bin8dec(bytes[i + 3]);
            i += 3;
            break
        case TYPE_LIGHT: //Light
            obj.light = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_MOTION: //Motion sensor(PIR)
            obj.motion = (bytes[i + 1]);
            i += 1;
            break
        case TYPE_CO2: //CO2
            obj.co2 = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_VDD: //Battery level
            obj.vdd = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_ANALOG1: //Analog input 1
            obj.analog1 = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_GPS: //gps
            i++;
            obj.lat = (bytes[i + 0] | bytes[i + 1] << 8 | bytes[i + 2] << 16 | (bytes[i + 2] & 0x80 ? 0xFF << 24 : 0)) / 10000;
            obj.long = (bytes[i + 3] | bytes[i + 4] << 8 | bytes[i + 5] << 16 | (bytes[i + 5] & 0x80 ? 0xFF << 24 : 0)) / 10000;
            i += 5;
            break
        case TYPE_PULSE1: //Pulse input 1
            obj.pulse1 = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_PULSE1_ABS: //Pulse input 1 absolute value
            var pulseAbs = (bytes[i + 1] << 24) | (bytes[i + 2] << 16) | (bytes[i + 3] << 8) | (bytes[i + 4]);
            obj.pulseAbs = pulseAbs;
            i += 4;
            break
        case TYPE_EXT_TEMP1: //External temp
            var temp = (bytes[i + 1] << 8) | (bytes[i + 2]);
            temp = bin16dec(temp);
            obj.externalTemperature = temp / 10;
            i += 2;
            break
        case TYPE_EXT_DIGITAL: //Digital input
            obj.digital = (bytes[i + 1]);
            i += 1;
            break
        case TYPE_EXT_DISTANCE: //Distance sensor input
            obj.distance = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_ACC_MOTION: //Acc motion
            obj.accMotion = (bytes[i + 1]);
            i += 1;
            break
        case TYPE_IR_TEMP: //IR temperature
            var iTemp = (bytes[i + 1] << 8) | (bytes[i + 2]);
            iTemp = bin16dec(iTemp);
            var eTemp = (bytes[i + 3] << 8) | (bytes[i + 4]);
            eTemp = bin16dec(eTemp);
            obj.irInternalTemperature = iTemp / 10;
            obj.irExternalTemperature = eTemp / 10;
            i += 4;
            break
        case TYPE_OCCUPANCY: //Body occupancy
            obj.occupancy = (bytes[i + 1]);
            i += 1;
            break
        case TYPE_WATERLEAK: //Water leak
            obj.waterleak = (bytes[i + 1]);
            i += 1;
            break
        case TYPE_GRIDEYE: //Grideye bytes
            var ref = bytes[i+1];
            i++;
            obj.grideye = [];
            for(var j = 0; j < 64; j++) {
                obj.grideye[j] = ref + (bytes[1+i+j] / 10.0);
            }
            i += 64;
            break
        case TYPE_PRESSURE: //External Pressure
            var temp = (bytes[i + 1] << 24) | (bytes[i + 2] << 16) | (bytes[i + 3] << 8) | (bytes[i + 4]);
            obj.pressure = temp / 1000;
            i += 4;
            break
        case TYPE_SOUND: //Sound
            obj.soundPeak = bytes[i + 1];
            obj.soundAvg = bytes[i + 2];
            i += 2;
            break
        case TYPE_PULSE2: //Pulse 2
            obj.pulse2 = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_PULSE2_ABS: //Pulse input 2 absolute value
            obj.pulseAbs2 = (bytes[i + 1] << 24) | (bytes[i + 2] << 16) | (bytes[i + 3] << 8) | (bytes[i + 4]);
            i += 4;
            break
        case TYPE_ANALOG2: //Analog input 2
            obj.analog2 = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        case TYPE_EXT_TEMP2: //External temp 2
            var temp = (bytes[i + 1] << 8) | (bytes[i + 2]);
            temp = bin16dec(temp);
            if(typeof obj.externalTemperature2 === "number") {
                obj.externalTemperature2 = [obj.externalTemperature2];
            } 
            if(typeof obj.externalTemperature2 === "object") {
                obj.externalTemperature2.push(temp / 10);
            } else {
                obj.externalTemperature2 = temp / 10;
            }
            i += 2;
            break
        case TYPE_EXT_DIGITAL2: //Digital input 2
            obj.digital2 = (bytes[i + 1]);
            i += 1;
            break
        case TYPE_EXT_ANALOG_UV: //Load cell analog uV
            obj.analogUv = (bytes[i + 1] << 24) | (bytes[i + 2] << 16) | (bytes[i + 3] << 8) | (bytes[i + 4]);
            i += 4;
            break
        case TYPE_TVOC:
            obj.tvoc = (bytes[i + 1] << 8) | (bytes[i + 2]);
            i += 2;
            break
        default: //somthing is wrong with bytes
            i = bytes.length;
            break
        }
    }
    return obj;
}

document.getElementById("convert").onclick = function () {
    var res = DecodeElsysPayload(hexToBytes(document.getElementById("inputbytes").value));
    var json = JSON.stringify(res, null, 4);
    document.getElementById("result").innerHTML = json;
};