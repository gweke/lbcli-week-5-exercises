# What is the redeem script in this transaction
# transaction="020000000121654fa95d5a268abf96427e3292baed6c9f6d16ed9e80511070f954883864b100000000d90047304402201c97b48215f261055e41b765ab025e77a849b349698ed742b305f2c845c69b3f022013a5142ef61db1ff425fbdcdeb3ea370aaff5265eee0956cff9aa97ad9a357e301473044022000a402ec4549a65799688dd531d7b18b03c6379416cc8c29b92011987084e9f402205470e24781509c70e2410aaa6d827aa133d6df2c578e96a496b885584fb039200147522102da2f10746e9778dd57bd0276a4f84101c4e0a711f9cfd9f09cde55acbdd2d1912102bfde48be4aa8f4bf76c570e98a8d287f9be5638412ab38dede8e78df82f33fa352aeffffffff0188130000000000001600142c48d3401f6abed74f52df3f795c644b4398844600000000"

RAW_TX="020000000121654fa95d5a268abf96427e3292baed6c9f6d16ed9e80511070f954883864b100000000d90047304402201c97b48215f261055e41b765ab025e77a849b349698ed742b305f2c845c69b3f022013a5142ef61db1ff425fbdcdeb3ea370aaff5265eee0956cff9aa97ad9a357e301473044022000a402ec4549a65799688dd531d7b18b03c6379416cc8c29b92011987084e9f402205470e24781509c70e2410aaa6d827aa133d6df2c578e96a496b885584fb039200147522102da2f10746e9778dd57bd0276a4f84101c4e0a711f9cfd9f09cde55acbdd2d1912102bfde48be4aa8f4bf76c570e98a8d287f9be5638412ab38dede8e78df82f33fa352aeffffffff0188130000000000001600142c48d3401f6abed74f52df3f795c644b4398844600000000"

decode_tx=$(bitcoin-cli -regtest decoderawtransaction $RAW_TX)
#echo $decode_tx | jq '.'

# so what if, we get the txid and the vout_index of the inputs, 
# then we use gettransaction txid to get the hex of that inputs
# then we use decoderawtransaction hex, to access the vout_index to get the scriptsig.hex or asm
# but we can't get information about this txid as it's not in the wallet tx

#vin_txid=$(echo $decode_tx | jq -r '.vin[].txid')
#echo "vin_tixd: $vin_txid"

#vin_vout_index=$(echo $decode_tx | jq -r '.vin[].vout')
#echo "vin_vout_index: $vin_vout_index"

#vin_tx_hex=$(bitcoin-cli -regtest gettransaction "$vin_txid" | jq -r '.hex')
#echo "vin_tx_hex: $vin_tx_hex"

#decode_vin_tx=$(bitcoin-cli -regtest decoderawtransaction $vin_tx_hex)
#echo $decode_vin_tx | jq '.'

# so we will get the hex of the redeem script in vout[index].Scrippubkey.hex
#redeem_script_hex=$(echo $decode_vin_tx | jq -r '.vout[$vin_vout_index].scriptPubKey.hex')
#echo $redeem_script_hex

# So we'll use the simplest way, as we know that the redeem script, is the unlocking script of the fund
# and it will be in scriptsig as a form of data or sigs redeemscript, 
# It's the operand that will be use by the locking script to chek if everything goes right

redeem_script_hex=$(echo $decode_tx | jq -r '.vin[0].scriptSig.asm' | awk '{print $NF}')
echo $redeem_script_hex