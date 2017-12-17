var SerialPort = require('serialport');
// var port = new SerialPort('/dev/tty.usbmodem00196521', {
var port = new SerialPort('/dev/ttyACM0', {
  baudRate: 50000
});

let servo = 0;

setInterval(() => {
  servo++
  if (servo > 254)
    servo = 0
  port.write([0xFF, 10, servo]);
}, 20)
