## MLM Smarcontract
**Disclamer: current version of the smartcontract implements only send hardcoded 1% to the pointed referal in the transaction binary body**

The smartcontract provides <del>hierahical</del> bounty for the payments for marketing purposes. It can be used for creating referal programs and <del>support MLM (multi-level marketing) structure</del> (not implemented).  

Smartcontract works as simple wallet proxy and accept simple transfer message where in binary comment (0xff) the referral address exists. After processing amount of Grams is transfered to the source wallet minus referral bounty if referral address exists. <del>The referral address and his parent (and parent of the parent, depends on scm configs) earns its part</del>

### How to

* `./build.sh -h`
* `./test.sh -h`

#### How to init

* `./build.sh init -s addr`   
  where  
  `addr` is the wallet where the grams minus bounties should be transfered

#### How to transfer grams from existed wallet

* `./build.sh transfer -f from_addr -k from_addr.pk -s scm_addr --amount grams --ref ref_addr --seqno seqno`  
  where   
  `from_addr` - your wallet addr  
  `from_addr.pk` - your wallet private key for subscribing external request  
  `scm_addr` - this smarconctract scm  
  `ref_addr` - referral addr  
  `seqno` - your wallet external msg seqno  
  So **1%** of the transferred amount will be transfered to the referral

#### Example
```
Source wallet address = -1:4d7ab84e1f2a1dd3f375b1cbbb033944ae409926bfd3b624729a46ed71f3e15 
Non-bounceable address (for init only): 0f8E16uE4fKh3T83Wxy7sDOUSuQJkmv9O2JHKaRu1x8-FW6q
Bounceable address (for later access): kf8E16uE4fKh3T83Wxy7sDOUSuQJkmv9O2JHKaRu1x8-FTNv
```
