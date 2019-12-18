## MLM Smarcontract

The smartcontract provides hierahical bounty for the payments

### How to

* `./build.sh`
* `./test.sh`

### TLB 

```
address#_ workchain_id:int8 address:bits256
  = PaymentAddress
config#_
  = MLMScmConfig
participant#_ parent:PaymentAddress
              created_at:uint32
              address:PaymentAddress
  = MLMParticipant
data#_ seqno:uint32 public_key:bits256
       payment_address: PaymentAddress
       config: MLMScmConfig
       participants: Hashmap 288 Participant
  = MLMScmData
```

```
_ _: MessageUpgrade = MessageBody;
_ _: MessageDropData = MessageBody;

ext_message$_
  signature: uint512
  message_body: MessageBody
```

**MessageUpgrade**
```
upgrade_action$0001: ActionUpgrade
ext_message_body$_
  seqno: uint32
  action: ActionUpgrade
  code: ^Cell = MessageUpgrade;
```

```
upgrade_action$0010: ActionDropData
ext_message_body$_
  seqno: uint32
  action: ActionDropData = MessageDropData
```
