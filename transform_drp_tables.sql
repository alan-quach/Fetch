create schema drp;
create or replace table drp.brands
as
select (json_data:_id):"$oid"::varchar(255)     as brandId
     , json_data:barcode::varchar(255)          as barcode
     , json_data:brandCode::varchar(255)        as brandCode
     , json_data:category::varchar(255)         as category
     , json_data:categoryCode::varchar(255)     as categoryCode
     , json_data:cpg:"$id":"$oid"::varchar(255) as cpg
     , json_data:cpg:"$ref"::varchar(255)       as ref
     , json_data:topBrand::boolean              as topBrand
     , json_data:name::varchar(255)             as name
from "stage_json"."brands"
;

create or replace table FETCH.drp.receipts
as
select
(json_data:_id):"$oid"::varchar(255)                            AS receiptId
, to_timestamp(json_data:createDate:"$date"::varchar)           AS createDate
, to_timestamp(json_data:dateScanned:"$date"::varchar)          AS dateScanned
, to_timestamp(json_data:finishedDate:"$date"::varchar)         AS finishedDate
, to_timestamp(json_data:modifyDate:"$date"::varchar)           AS modifyDate
, to_timestamp(json_data:purchaseDate:"$date"::varchar)         AS purchaseDate
, to_timestamp(json_data:pointsAwardedDate:"$date"::varchar)    AS pointsAwardedDate
, json_data:bonusPointsEarned::number(18,0)                     AS bonusPointsEarned
, json_data:bonusPointsEarnedReason::varchar(255)               AS bonusPointsEarnedReason
, json_data:pointsEarned::number(18,2)                          AS pointsEarned
, json_data:rewardsReceiptStatus::varchar(255)                  AS rewardsReceiptStatus
, json_data:purchasedItemCount::number                          AS purchasedItemCount
, json_data:totalSpent::number(18,2)                            AS totalSpent
, json_data:userId::varchar(255)                                AS userId
from "stage_json"."receipts"
;

create table drp.receiptItems
as
select distinct (json_data:_id):"$oid"::varchar(255)                     as receiptid
              , md5((json_data:_id):"$oid"::varchar(255) || ':' ||
                    receiptitems.value:partnerItemId::number)            as receiptitemsid
              , receiptitems.value:partnerItemId::number                 as partneritemid
              , receiptitems.value:barcode::varchar(255)                 as barcode
              , receiptitems.value:description::varchar(255)             as description
              , receiptitems.value:discountedItemPrice::number(18, 2)    as discounteditemprice
              , receiptitems.value:finalPrice::number(18, 2)             as finalprice
              , receiptitems.value:itemPrice::number(18, 2)              as itemprice
              , receiptitems.value:targetPrice::number(18, 2)            as targetprice
              , receiptitems.value:metabriteCampaignId::varchar(255)     as metabritecampaignid
              , receiptitems.value:originalReceiptItemText::varchar(255) as originalreceiptitemtext
              , receiptitems.value:pointsNotAwardedReason::varchar(255)  as pointsnotawardedreason
              , receiptitems.value:pointsEarned::number(18, 2)           as pointsearned
              , receiptitems.value:pointsPayerId::varchar(255)           as pointspayerid
              , receiptitems.value:quantityPurchased::number             as quantitypurchased
              , receiptitems.value:needsFetchReview::varchar(255)        as needsfetchreview
              , receiptitems.value:rewardsGroup::varchar(255)            as rewardsgroup
              , receiptitems.value:rewardsProductPartnerId::varchar(255) as rewardsproductpartnerid
              , receiptitems.value:competitorRewardsGroup::varchar(255)  as competitorrewardsgroup
              , receiptitems.value:competitiveProduct::boolean           as competitiveproduct
              , receiptitems.value:preventTargetGapPoints::boolean       as preventtargetgappoints
              , receiptitems.value:userFlaggedBarcode::varchar(255)      as userflaggedbarcode
              , receiptitems.value:userFlaggedDescription::varchar(255)  as userflaggeddescription
              , receiptitems.value:userFlaggedNewItem::boolean           as userflaggednewitem
              , receiptitems.value:userFlaggedPrice::number(18, 2)       as userflaggedprice
              , receiptitems.value:userFlaggedQuantity::number           as userflaggedquantity
from "stage_json"."receipts" receipt
   , lateral flatten(input =>receipt.json_data:rewardsReceiptItemList) receiptitems
;

create or replace table fetch.drp.users
as
select (json_data:_id):"$oid"::varchar(255)                 as userid
     , json_data:active::varchar(255)                       as active
     , to_timestamp(json_data:createdDate:"$date"::varchar) as createddate
     , to_timestamp(json_data:lastLogin:"$date"::varchar)   as lastlogin
     , json_data:"role"::varchar(255)                       as role
     , json_data:signUpSource::varchar(255)                 as signupsource
     , json_data:state::varchar(255)                        as state
from "stage_json"."users";
