var SerialPort = require('serialport');
var port = new SerialPort('/dev/tty.usbmodem00196521', {
  baudRate: 50000
});

setInterval(() => {
  port.write([0xFF, 0x09, 5]);
})
