import serial
import binascii

ser = serial.Serial('/dev/ttyUSB1', 115200)

def Load(adr):
    ser.write(b'\01')
    bins = binascii.unhexlify(adr)
    ser.write(bins)
    out = binascii.hexlify(ser.read())
    print(out)


def Store(adr, val):
    ser.write(b'\02')
    bins = binascii.unhexlify(adr)
    ser.write(bins)
    bins = binascii.unhexlify(val)
    ser.write(bins)
    
def Call(addr):
    ser.write(b'\03')
    bins = binascii.unhexlify(adr)
    ser.write(bins)
