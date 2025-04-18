# Create a CSV script that would lock funds until one hundred and fifty blocks had passed
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277

# This a test when reading the book"
# Seconds for six months
seconds=$((6*30*24*60*60))
nvalue=$(($seconds/512))
#echo "nvalue = $nvalue"
#Then, turn it into hex:

hexvalue=$(printf '%x\n' $nvalue)
#echo $hexvalue
#Finally, bitwise-or the 23rd bit into the hex value you created:

relativevalue=$(printf '%x\n' $((0x$hexvalue | 0x400000)))
#echo "relativevalue in hex= $relativevalue and in dec= $((0x$relativevalue))"

hex_test="80000000"
#echo "hexvalue: 0x$hex_test in dec is: $((0x$hex_test))"

hex_test="f0000000"
#echo "hexvalue: 0x$hex_test in dec is: $((0x$hex_test))"

######### Now we begin the exercise
relative_block=150
pubkey="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"

# So we follow the same process as in 04.sh but here we use OP_CHECKSEQUENCEVERIFY
# And we encode our relative_block on 3 bytes or 2 bytes
# hash the pubkey, and our redeem script we'll look like:
# OP_PUSHDATA (2 bytes) <le> OP_CHECKSEQUENCEVERIFY OP_DROP OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
# 02 <le> b2 75 76 a9 14 <pukeyhash> 88 ac

# converting the relative block (dec) in hex and reverse it to be a LE
le=$(printf "%04x" $relative_block | sed 's/\(..\)\(..\)/\2\1/')
#le=$(printf '%06x' $sequence_lock | sed 's/../& /g' | awk '{printf "%s%s%s", $3, $2, $1}')
#echo $le

# Now we hash160 our pubkey
pubkeyhash=$(echo -n "$pubkey" | xxd -r -p | openssl sha256 -binary | openssl ripemd160 | awk '{print $2}')
#echo $pubkeyhash

redeem_script_hex=$(echo "02"$le"b27576a914"$pubkeyhash"88ac")
echo $redeem_script_hex

decode_script=$(bitcoin-cli -regtest decodescript $redeem_script_hex)
#echo $decode_script | jq '.'

p2sh_segwit=$(echo $decode_script | jq -r '.segwit."p2sh-segwit"')
#echo $p2sh_segwit