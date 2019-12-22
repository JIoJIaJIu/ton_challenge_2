#!/bin/bash
#
# Creates transfer message to the smartcontract from the wallet
#
# Stack:
# Constants:
# Variables: WC OUTPUT_PK
# Functions: error
#
usage() {
  echo
  echo "MESSAGE_OPTIONS:"
  echo "  --seqno=seqno                sequence number for preventing replay attacks"
  echo "                                 default=0"
  echo "  -s, --scm=hash               hash address of the smartcontract"
  echo "  -f, --from=hash              source wallet hash"
  echo "  -k, --key=file               source wallet private key"
  echo "  -r, --ref=hash               reference wallet hash"
  echo "      --amount                 amount in grams"
}

opts=`getopt -o h,s:,f:,r: \
      -l help,scm:,from:,amount:,seqno:,ref: \
      -- $@`

eval set -- $opts
while [[ $# -gt 0 ]]; do
  case $1 in
    --seqno)
      SEQNO=$2
      shift 2
      ;;
    -s|--scm)
      SCM=$2
      shift 2
      ;;
    -f|--from)
      FROM=$2
      shift 2
      ;;
    -r|--ref)
      REF=$2
      shift 2
      ;;
    --amount)
      AMOUNT=$2
      shift 2
      ;;
    -h|--help)
      usage
      exit
      ;;
    *)
      break
      ;;
  esac
done
shift

if [ -z "$AMOUNT" ]; then
  error "MUST provide amount of grams, --amount, check -h"
  exit 1
fi

if [ -z "$FROM" ]; then
  error "MUST provide source wallet hash, -f/--from, check -h"
  exit 1
fi

if [ -z "$SCM" ]; then
  error "MUST provide smartcontract hash, -s/--scm, check -h"
  exit 1
fi

if [ -z "$REF" ]; then
  error "MUST provide referal hash, -r/--ref, check -h"
  exit 1
fi

if [ -f "$OUTPUT_ADDR" ]; then
  error "$OUTPUT_ADDR file already exists, it cannot be overwritten"
  exit 1
fi

SEQNO=${SEQNO:-0}
cat <<EOF
  "TonUtil.fif" include
  ."Request to transfer ${AMOUNT} grams from ${FROM} to ${SCM} with ref:${REF}" cr cr
  true constant bounce
  "$OUTPUT_PK" load-keypair constant wallet_pk drop
  "$FROM" $>smca 0 = { 1 halt } if drop 2constant addr
  "$SCM" bounce parse-load-address =: bounce 2=: dest_addr
  "$REF" $>smca 0 = { 1 halt } if drop 2constant ref_addr

  <b
    b{01} s,
    bounce 1 i,
    b{000100} s,
    dest_addr addr,
    "${AMOUNT}" $>GR Gram,
    0 9 64 32 + + 1+ 1+ u,
    0 32 u,
    b{11111111} s,
    ref_addr addr,
  b>
  <b ${SEQNO} 32 u, 3 8 u, swap ref, b>
  dup ."Signing message: " <s csr. cr
  dup hash wallet_pk ed25519_sign_uint

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
    b{0} s,                // nothing$0
    b{0} s,                // body:(Either X ^X)
      swap B, swap <s s,
  b>
  cr
  dup <s ."Transfer Message:" cr csr.
EOF
