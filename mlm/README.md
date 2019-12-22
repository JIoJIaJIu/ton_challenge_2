## MLM Smarcontract

The smartcontract provides hierahical bounty for the payments. It can be used for creating referal programs and support MLM (multi-level marketing) structure (not implemented).  

Smartcontract works as simple wallet and accept simple transfer message where in binary comment (0xff) the referral address exists. After processing amount of Grams is transfered to the source wallet minus referral bounty if referral address exists. The referral address and his parent (and parent of the parent, depends on scm configs) earns its part

### How to

* `./build.sh -h`
* `./test.sh -h`

#### How to init

* `./build.sh init -s addr`   
  where  
  `addr` is the wallet where the grams minus bounties should be transfered

#### How to transfer grams from existed wallet

* `./build.sh transfer -f from_addr -k from_addr.pk -s scm_addr --amount grams --ref ref_addr`  
  where   
  `from_addr` - your wallet addr  
  `from_addr.pk` - your wallet private key for subscribing external request  
  `scm_addr` - this smarconctract scm  
  `ref_addr` - referral addr  

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

**MessageUpgrade**
```
upgrade_action$0001: ActionUpgrade
ext_message_body$_
  seqno: uint32
  action: ActionUpgrade
  code: ^Cell = MessageUpgrade;
```
