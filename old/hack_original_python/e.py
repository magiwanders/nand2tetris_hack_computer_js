def bin2scomp(dec, nbits):
    binary = bin(((1 << nbits) - 1) & int(dec))[2:]
    sign = '0' if dec>=0 else '1'
    for i in range(nbits-len(binary)):
        binary = sign + binary
    return binary

print(bin2scomp(-32123, 16))

# @12345
# D=A
# @23456
# D=A-D
# @1000
# M=D
# @1001
# MD=D-1
