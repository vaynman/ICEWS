filterSectors <- function(events, event_sector, sectors) {
# Inputs:
#   events - a dataframe with column Event_ID
#   event_sector - dataframe with columns Event_ID, Sector
#   sectors - array of sector names to keep

    # Grab unique event_id with desired sectors
    event_sector_tmp = unique(event_sector[event_sector$Sector %in% sectors,c('Event_ID'), drop = FALSE])

    # Merge with events to only keep events with desired sector (inner join)
    merge(events, event_sector_tmp, by = "Event_ID");
}

cat('Loading event data ... ');
events <- readRDS('icews_CHN_RUS.Rda');
cat('Finished.\n');

cat('Loading (event_id, sector) file ... ');
event_sector <- readRDS('event_sector.Rda');
cat('Finished\n');

# Filter on desired sectors
sectors <- c('Government', 'Parties', 'Elite', 'News', 'Defense / Security Business');
filtered_events <- filterSectors(events, event_sector, sectors);

# remove the (event_id,sector) data to clear up memory
rm(event_sector);


# Convert dates to from string to date format
events$Event_Date <- as.Date(events$Event_Date, "%Y-%m-%d");

# Change columns to factors
df$SrcStateAbb <- factor(df$SrcStateAbb);
df$SrcStateCode <- factor(df$SrcStateCode);
df$Source_Country <- factor(df$Source_Country);
df$TrgStateAbb <- factor(df$TrgStateAbb);
df$TrgStateCode <- factor(df$TrgStateCode);
df$Target_Country <- factor(df$Target_Country);

aggregate(filtered_events$Intensity, list(year(filtered_events$Event_Date)), mean)
aggregate(!is.na(filtered_events), list(year(filtered_events$Event_Date)), sum)
aggregate(df$Intensity ~ df$SrcStateAbb + df$TrgStateAbb, df, mean);


# Some summary stats on Intensity by Source and Target Country
x = aggregate(Intensity ~ Source_Country + Target_Country, df,  
        FUN = function(x) { c(mean = mean(x), sd = sd(x), quantile(x, probs = c(0, 0.25,0.5,0.75,1 )), nobs = sum(!is.na(x)))});
x = x[order(x$Source_Country, x$Target_Country),];
format(x, digits=2, scientific=FALSE, drop0trailing = TRUE, big.mark = ",");