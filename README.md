For this exercise we used a Snowflake instance to load the data and the EDA exercise. 
Normally we would use S3 external stages to load data but in this case we use an internal stage within Snowflake.

During this exercise a couple different issues were encountered with the JSON files and the compression used. 
The users JSON was the file impacted by the use of tar versus gzip.
