# Create a CLTV script with a timestamp of 1495584032 and public key below:
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277


# Here is the clue : we convert the timestamp in little endian hex
# we then construct our CLTV Script like this 
# OP_PUSHDATA (4 bytes) <le> OP_CHECKLOCKTIMEVERIFY OP_DROP OP_DUP OP_HASH160 <pubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
# When we serialzed it we'll see 
# 04 <le> b1 75 76 a9 14 <pukeyhash> 88 ac
# and then we'll decode it


# converting the timestamp (dec) in hex and reverse it to be a LE
timestamp=1495584032
le=$(printf "%08x" $timestamp | sed 's/\(..\)\(..\)\(..\)\(..\)/\4\3\2\1/')
#echo $le

# Now we hash160 our pubkey
pubkey="02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277"
pubkeyhash=$(echo -n "$pubkey" | xxd -r -p | openssl sha256 -binary | openssl ripemd160 | awk '{print $2}')
#echo $pubkeyhash

redeem_script_hex=$(echo "04"$le"b17576a914"$pubkeyhash"88ac")
echo $redeem_script_hex

decode_script=$(bitcoin-cli -regtest decodescript $redeem_script_hex)
#echo $decode_script | jq '.'

p2sh_segwit=$(echo $decode_script | jq -r '.segwit."p2sh-segwit"')
#echo $p2sh_segwit