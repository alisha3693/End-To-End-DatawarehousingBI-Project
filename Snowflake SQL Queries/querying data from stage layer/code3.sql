
-- count the number of records in customer csv file in stage

select count($1)
from @util_db.public.my_stage2/data.csv
(file_format=>'CSV_SOURCE_FILE_FORMAT');

-- give the customerid where the dob is after 1st january 2000


select $1,$2,$3,$4,$5,$6
from @util_db.public.my_stage2/data.csv
(file_format=>'CSV_SOURCE_FILE_FORMAT')
where $4>'2000-1-1';