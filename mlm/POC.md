# POC [in progress]

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

### Internal Messages

```
message_body$_ {X:Type}
               operation:uint32
               query_id:(MayBe uint64)
               data:^X
  = MessageBodyInt X
```

### External Messages

**MessageUpgrade**
```
upgrade_action$0001: ActionUpgrade
ext_message_body$_
  seqno: uint32
  action: ActionUpgrade
  code: ^Cell = MessageUpgrade;
```
