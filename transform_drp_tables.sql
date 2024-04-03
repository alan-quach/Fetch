create schema drp;
create or replace table drp.brand
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
