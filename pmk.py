import hmac
import hashlib
from hashlib import sha1
import binascii
import sys

A           = "Pairwise key expansion"
APmac       = binascii.a2b_hex("0008223033fc")
Clientmac   = binascii.a2b_hex("000ef4ec2bc1")
ANonce      = binascii.a2b_hex("6f95ab5a8b093ccc1c6f7bb55a0abe273edaa0ca5832eecef9b2250f2c9b303c")
SNonce      = binascii.a2b_hex("98be4fa5212318c8c8068f6ccf4a7fae9e8273263d0a79b58f5e1b1b2f514af7")
B           = min(APmac,Clientmac)+max(APmac,Clientmac)+min(ANonce,SNonce)+max(ANonce,SNonce)

def customPRF512(key,A,B):
    blen = 64
    i    = 0
    R    = ''
    while i<=((blen*8+159)/160):
        hmacsha1 = hmac.new(key,A+chr(0x00)+B+chr(i),sha1)
        i+=1
        R = R+hmacsha1.digest()
        print "R: ",binascii.b2a_hex(hmacsha1.digest()),"\n"
    return R[:blen]

pmk = binascii.a2b_hex("36538960ae3fa4460e17d391d6d3645e5ff1f0370bb24a724103e46cff649f4b")

ptk = customPRF512(pmk,A,B)
print "pmk:\t\t",binascii.b2a_hex(pmk),"\n"
#print "ptk:\t\t",binascii.b2a_hex(ptk[0:16]),"\n"
print "ptk:\t\t",binascii.b2a_hex(ptk[0:48]),"\n"

print "A: ",binascii.b2a_hex(A),"\n"
print "CHR(0x00): ",chr(0x00),"\n"
print "B: ",binascii.b2a_hex(B),"\n"
print "key: ",binascii.b2a_hex(pmk),"\n"
print "CHR(0): ",chr(0),"\n"
i = 0
string = A+chr(0x00)+B+chr(i)
print "STRING: ",binascii.b2a_hex(string);
