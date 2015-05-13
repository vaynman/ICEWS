
# Load the ICEWS data from the local mysql database. Note, obviously dont run this without the database hosted localy!

 library("RMySQL")
# Connect to a MySQL database running locally
con <- dbConnect(RMySQL::MySQL(), dbname = "icews", 
		user = "vaynman", password="igor123");

sql <- "select E.*, 
	  CC.Description, CC.Intensity, 
      C1.StateAbb as SrcStateAbb, C1.CCode as SrcStateCode,
      C2.StateAbb as TrgStateAbb, C2.CCode as TrgStateCode
from icews.events E
left outer join icews.cameo_codes CC on E.CAMEO_code = CC.CAMEO_Code
left outer join icews.countries C1 on E.Source_Country = C1.StateNme
left outer join icews.countries C2 on E.Target_Country = C2.StateNme
where
	(
		Source_Country = 'Russian Federation' and 
        Target_Country in ('Armenia','Azerbaijan','Belarus','Estonia','Georgia', 'Kazakhstan','Kyrgyzstan','Latvia','Lithuania','Moldova','Tajikistan','Turkmenistan','Ukraine','Uzbekistan')
	) or
    (
		Source_Country = 'China' and 
        Target_Country in ('Cambodia','Indonesia','Japan','Laos','Malaysia', 'Mongolia','Myanmar','Nepal','North Korea','Philippines','Singapore','South Korea','Thailand','Vietnam')
	);"

data = dbGetQuery(con, sql);
saveRDS(data, file="icews_CHN_RUS.Rda");

sql <- "select * from event_sector";
event_sector = dbGetQuery(con, sql);
saveRDS(event_sector, file="event_sector.Rda");
dbDisconnect(con);