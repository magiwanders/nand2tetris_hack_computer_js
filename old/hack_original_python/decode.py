import sys

hex = sys.argv[1]
bin = bin(int(hex, 16))[2:]

print('Received Hex:', hex)
print('Binary:', bin)
print('Valid:', bin[-2:]=='11')
#########################################################
#  f   #  f   #  f   #  f   #  f   #  f   #  f   #  f   #
# 0000 # 0000 # 0000 # 0000 # 0000 # 0000 # 0000 # 0000 # 
# 0000000 00000 00000 000 00000