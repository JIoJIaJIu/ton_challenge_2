#!/bin/bash
#
# Creates intialization message for the smartcontract
#
# Stack:
# Constants:
# Variables: WC OUTPUT_PK
# Functions: error
#
usage() {
  echo
  echo "MESSAGE_OPTIONS:"
  echo "  -s,--source=hash             source wallet where the grams should be transfered to"
}

opts=`getopt -o h,s:\
      -l help,source: \
      -- $@`

eval set -- $opts
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      usage
      exit
      ;;
    -s|--source)
      # ADDR=(`IFS=":"; echo $2`)

      #if [ ${#ADDR[@]} -ne 2 ]; then
      #  error "Wrong format of the resource $2. MUST be wc:addr"
      #  exit 1
      #fi
      #shift 2
      SOURCE=$2
      shift 2
      break
      ;;
    *)
      break
      ;;
  esac
done
shift

if [ -z "$SOURCE" ]; then
  error "MUST provide source smartcontract, check -h"
  exit 1
fi

if [ -f "$OUTPUT_ADDR" ]; then
  error "$OUTPUT_ADDR file already exists, it cannot be overwritten"
  exit 1
fi

cat <<EOF
  "TonUtil.fif" include

  <b
    0 32 u, // seqno
    "${OUTPUT_PK}" load-generate-keypair constant wallet_pk dup constant public_key
    B, // public key
    b{001} s, "${SOURCE}" $>smca 2drop addr,
    <b b{0} s, b> ref,
    <b null dict, b> ref,
  b> swap

  cr ."-- FIFT extension --" cr cr
  // StateInit
  <b
    // split_depth:(Maybe (## 5)) special:(Maybe TickTock)
    b{00} s,                // nothing$0
    // code:(Maybe ^Cell)
    b{1} s,                 // just$1
      swap ref,             // ^Cell
    b{1} s,                 // data:(Maybe ^Cell)
      swap ref,
    b{0} s,                 // library:(HashmapE 256 SimpleLib)
  b>
  ."StateInit:" cr dup <s csr.

  dup hash ${WC} swap 2constant addr
  addr "$OUTPUT_ADDR" save-address


  <b 0 32 u, 0 4 u, b>
  dup hash wallet_pk ed25519_sign_uint
  rot

  <b
    // info:CommonMsgInfo
    b{10} s,               // ext_in_msg_info$10
      // src:MsgAddressExt
      b{00} s,             // addr_none$00
      // dest:MsgAddressInt
      b{10} s,             // addr_std$10
        b{0} s,            // anycast:(Maybe Anycast)
        addr addr,         // workchain_id:int8 address:bits256
      // import_fee:Grams
      0 Gram,              // (VarUInteger 16) // b{0000} s,
    // init:(Maybe (Either StateInit ^StateInit))
    b{1} s,                // just$1
      b{1} s,              // right$1
        swap ref,          // ^StateInit
    // body:(Either X ^X)
    b{0} s,                // left$0 0
      swap B, swap <s s,
  b>
  dup <s ."INIT Message:" cr csr.
  cr
  ."Smart contract addr: " addr .addr cr
  ."Smart contract non-bounceable: " addr 7 .Addr cr
  ."Smart contract bounceable: " addr 6 .Addr cr
EOF
