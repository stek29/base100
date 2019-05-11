# Licensed under UNLICENSE
# See UNLICENSE provided with this file for details

def encode(data: bytes):
    out = [240, 159, 0, 0]*len(data)
    for i, b in enumerate(data):
        out[4*i+2] = (b + 55) // 64 + 143
        out[4*i+3] = (b + 55) % 64 + 128
    return bytes(out).decode('utf-8')


def decode(s: str):
    data = s.encode('utf-8')
    if len(data) % 4 != 0:
        raise Exception('Lenth of string should be divisible by 4')
    tmp = 0
    out = [None]*(len(data) // 4)
    for i, b in enumerate(s.encode('utf-8')):
        if i % 4 == 2:
            tmp = ((b - 143) * 64) % 256
        elif i % 4 == 3:
            out[i//4] = (b - 128 + tmp - 55)&0xff
    return bytes(out)

