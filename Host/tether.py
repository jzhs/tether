import serial
import binascii


ser = serial.Serial('/dev/ttyUSB1', 115200)

def Load(adr):
    ser.write(b'\01')
    byts = adr.to_bytes(4, 'big')
    ser.write(byts)
    ser.flush()
    return ser.read()

def Store(adr, val):
    ser.write(b'\02')
    byts = adr.to_bytes(4, 'big')
    ser.write(byts)
    ser.write(val)
    ser.flush()
    
def Call(addr):
    ser.write(b'\03')
    byts = adr.to_bytes(4, 'big')
    ser.write(byts)
    ser.flush()
