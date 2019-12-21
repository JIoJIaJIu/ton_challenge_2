## MLM Smarcontract

The smartcontract provides hierahical bounty for the payments

### How to

* `./build.sh`
* `./test.sh`


Smartcontract works as simple wallet and accept simple transfer message where in binary comment (0xff) the referral address exists. After processing amount of Gram is transfered to the source wallet minus referral fee if referral address exists and found in the scm data. Also the referral address and his parent (and parent of the parent, depends on scm configs) earns 

### Smarcontracts Plans

#### 1_level (simple referral bonty)

Only direct parent gets the fee


#### 3_level

parent -> parent -> parent get the fee


### TLB 

```
config#_
  = MLMScmConfig
participant#_ parent:MsgAdressInt
              created_at:uint32
  = MLMParticipant
data#_ seqno:uint32 public_key:bits256
       payment_address:MsgAddressInt
       config:^MLMScmConfig
       participants:^Hashmap 288 Participant
  = MLMScmData
```

```
_ _: MessageUpgrade = MessageBody;
_ _: MessageDropData = MessageBody;
_ _: SignUp = MessageBody

ext_message$_
  signature:uint512
  message_body:MessageBody
```

### Internal Messages

```
message_body$_ {X:Type}
               operation:uint32
               query_id:(MayBe uint64)
               data:^X
  = MessageBodyInt X
```

**MoneyTransfer**
```
message_body$_ operation:$0
  0xff MsgAdressInt
```

**Register**

### External Messages

**StateInit**
```
```

**MessageUpgrade**
```
upgrade_action$0001: ActionUpgrade
ext_message_body$_
  seqno: uint32
  action: ActionUpgrade
  code: ^Cell = MessageUpgrade;
```

**MessageDropData**
```
upgrade_action$0010: ActionDropData
ext_message_body$_
  seqno: uint32
  action: ActionDropData = MessageDropData
```
