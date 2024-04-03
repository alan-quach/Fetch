

//What are the top 5 brands by receipts scanned for most recent month?

select b.name, r.rewardsreceiptstatus, count(distinct r.receiptid) as count_unique_receipts
from FETCH.drp.receipts r
inner join FETCH.drp.receiptitem ri on r.receiptid = ri.receiptid
left join FETCH.drp.brand b on ri.barcode = b.barcode
where date_trunc(month,r.datescanned) = date_trunc(month, current_date)
group by all
order by count_unique_receipts desc;

//How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

select date_trunc(month,r.datescanned) month_scanned,  b.name, r.rewardsreceiptstatus,  count(distinct r.receiptid) as count_unique_receipts, dense_rank() over (order by count(distinct r.receiptid))
from FETCH.drp.receipts r
inner join FETCH.drp.receiptitem ri on r.receiptid = ri.receiptid
left join FETCH.drp.brand b on ri.barcode = b.barcode
where date_trunc(month,r.datescanned) IN ('2021-01-1')
and rewardsreceiptstatus = 'FINISHED'
group by all
UNION ALL
select date_trunc(month,r.datescanned) month_scanned,  b.name, r.rewardsreceiptstatus,  count(distinct r.receiptid) as count_unique_receipts, dense_rank() over (order by count(distinct r.receiptid))
from FETCH.drp.receipts r
inner join FETCH.drp.receiptitem ri on r.receiptid = ri.receiptid
left join FETCH.drp.brand b on ri.barcode = b.barcode
where date_trunc(month,r.datescanned) IN ( '2021-02-01')
and rewardsreceiptstatus = 'FINISHED'
group by all
order by count_unique_receipts desc;

//When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

select rewardsreceiptstatus, avg(totalspent) as average_spent
from FETCH.drp.receipts
where rewardsreceiptstatus in ('ACCEPTED', 'REJECTED')
group by all;

//When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

select rewardsreceiptstatus, sum(purchaseditemcount) as totalItems
from FETCH.drp.receipts
where rewardsreceiptstatus in ('ACCEPTED', 'REJECTED')
group by all;

//Which brand has the most spend among users who were created within the past 6 months?

select u.createddate, b.name, SUM(r.totalspent) as total_brand_spend
from FETCH.drp.receipts r
left join FETCH.drp.users u on r.userid = u.userid
inner join FETCH.drp.receiptitem ri on r.receiptid = ri.receiptid
left join FETCH.drp.brand b on ri.barcode = b.barcode
where u.createddate > dateadd(month, -6, current_date)
group by all
order by total_brand_spend desc;

//Which brand has the most transactions among users who were created within the past 6 months?

select b.name, count(distinct r.receiptid) as count_unique_transactions
from FETCH.drp.receipts r
left join FETCH.drp.users u on r.userid = u.userid
inner join FETCH.drp.receiptitem ri on r.receiptid = ri.receiptid
left join FETCH.drp.brand b on ri.barcode = b.barcode
where u.createddate > dateadd(month, -6, current_date)
group by all
order by count_unique_transactions desc;
