function Decoder(bytes, fport) {
	var decoded = {};
	if (fport === 6) { // then its ReportDataCmd
		if ((bytes[1] === 0x95) && (bytes[2] === 0x01)) { // device type 95 (R718B)
			decoded.battery = bytes[3] / 10;
			decoded.temperature = ((bytes[4] << 24 >> 16) + bytes[5]) / 10;
        }
	} else if (fport === 7) { // then its a ConfigureCmd response
		if ((bytes[0] === 0x82) && (bytes[1] === 0x01)) { // R711 or R712
			decoded.mintime = ((bytes[2] << 8) + bytes[3]);
			decoded.maxtime = ((bytes[4] << 8) + bytes[5]);
			decoded.battchange = bytes[6] / 10;
			decoded.tempchange = ((bytes[7] << 8) + bytes[8]) / 100;
			decoded.humidchange = ((bytes[9] << 8) + bytes[10]) / 100;
		} else if ((bytes[0] === 0x81) && (bytes[1] === 0x01)) { // R711 or R712
			decoded.success = bytes[2];
		}
	}
	return decoded;
}


// Chirpstack decoder wrapper
function Decode(fPort, bytes) {
	return Decoder(bytes, fPort);
}

// Direct node.js CLU wrapper (payload bytestring as argument)
try {
    console.log(Decoder(Buffer.from(process.argv[2], 'hex'), 6));
} catch(err) {}