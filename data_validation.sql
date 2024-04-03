//identify data issues as duplicates for PK
select count(userid), count(distinct userid)
from users;

//issue with data from fetch-staff in dataset - per users data schema documentation role is constant value set to 'consumer'
select *
from users
where role <> 'consumer';

//check if there is data integrity issue where last login is before create date
select *
from users
where lastlogin < createddate;

//identify data issues as duplicates for PK
select count(receiptid), count(distinct receiptid)
from fetch.drp.receipts;

//identify data issues for missing status
select *
from fetch.drp.receipts
where receipts.rewardsreceiptstatus is null;

//identify data issues for missing userid
select *
from fetch.drp.receipts
where receipts.userid is null;


//identify data integrity issue where finish status and finish date is null
select *
from fetch.drp.receipts
where rewardsreceiptstatus = 'FINISHED'
  and finisheddate is null;

//identify data issues for missing FK barcode
select *
from fetch.drp.receiptitems
where barcode is null;

// identify missing barcodes that are showing up in receipt items
select *
from fetch.drp.receiptitems ri
         left join fetch.drp.brands b on ri.barcode = b.barcode
where b.barcode is null;

// Missing brandcode, category, categoryCode, name for some barcode records
// test records are in the dataset
select *
from brands;

// additional issues that need to be revisited include the userflagged items in the receiptItemsList
// brands dataset does not have a brand grouping element to allow for parent/child grouping
// brands cpg column is not unique and overlaps across different categories and brands 
