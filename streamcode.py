#!/usr/bin/env python3 -u


'''
    Тулза для кодирования/декодирования base64/base85/base32/ascii85/hex,
    которая в отличие от некоторых специализированных инструментов
    (не будем показывать пальцем на утилиту base64)
    не пытается запихать в память обрабатываемые данные полностью
'''


from base64 import *
import sys


# недопилено вроде (или нет)
class CoderWriter:
    def __init__(self, func, min_size, outstream):
        self.func = func
        self.min_size = min_size
        self.buffer = bytearray()
        self.outstream = outstream

    def code(self, data):
        data = memoryview(data)
        if len(self.buffer) != 0:
            needed_size = self.min_size - len(self.buffer)
            self.buffer.extend(data[:needed_size])
            data = data[needed_size:]
            if len(self.buffer) == self.min_size:
                self.outstream.write(self.func(self.buffer))
                self.buffer.clear()
            else:
                return

        d, m = divmod(len(data), self.min_size)
        if d:
            d *= self.min_size
            self.outstream.write(self.func(data[:d]))
            data = data[d:]
        if m:
            self.buffer.extend(data)

    def flush(self):
        if len(self.buffer) > 0:
            self.outstream.write(self.func(self.buffer))


# base64: 3 байта -> 4 символа
# base85: 4 байта -> 5 символов
# base32: 5 байт -> 8 символов
# hex: 1 байт -> 2 символа

CODERS = {
    'b64': ((b64encode, 3),
            (b64decode, 4)),
    'b85': ((b85encode, 4),
            (b85decode, 5)),
    'a85': ((a85encode, 4),
            (a85decode, 5)),
    'b32': ((b32encode, 5),
            (b32decode, 8)),
    'hex': ((bytes.hex, 1),
            (bytes.fromhex, 2)),
}

def get_optimal_size(size_limit, min_size):
    return size_limit - (size_limit % min_size)


def run(block_size, func, min_size, inp, outp):
    inp.seek(0, 2)
    total_bytes = inp.tell()
    inp.seek(0, 0)
    passed_bytes = 0

    size = get_optimal_size(block_size, min_size)
    while True:
        data = inp.read(size)
        if not data:
            break
        outp.write(func(data))

        passed_bytes += len(data)
        print(f'{passed_bytes} / {total_bytes} [{int(passed_bytes / total_bytes * 100)}%]'.ljust(30, ' '), end='\r')



def main():
    if len(sys.argv) == 6:
        mode, coder_name, fin_name, fout_name, block_size = sys.argv[1:]
        block_size = int(block_size)
    else:
        print('Usage:', sys.argv[0], '[mode] coder input output block_size')
        print('    mode - [d]ecode/[e]ncode (decode by default)')
        print('    coder - one of this (', ', '.join(CODERS) ,')')
        print('    input - input file name')
        print('    output - output file name')
        print('    block_size - max size of blocks to read')
        return

    if mode == 'e':
        func, min_size = CODERS[coder_name][0]
    elif mode == 'd':
        func, min_size = CODERS[coder_name][1]
    else:
        print('mode must be `e` or `d`')
        return

    with open(fin_name, 'rb') as fin, open(fout_name, 'wb') as fout:
        run(block_size, func, min_size, fin, fout)


    
if __name__ == '__main__':
    main()
