use "/Users/sarahkirker/Desktop/Thesisdata/Main.dta"

*Keep ALL SEASONS 

collapse (mean) avgriskcount_s = countrisk_s avgriskcount_shc = countrisk_shc avgriskcount_sbc = countrisk_sbc avgrisk_sbc = drisk_sbc avgrisk_s = drisk_s avgrisk_shc = drisk_shc avgrisk_24=drisk_24 avgrisk_24hc = drisk_24hc avgage=calcage avghiredratioclimb = hiredratioclimb avgprev8000=prev8000atmpt avgteamsize = expclimbers sznclimbers=sumsznclimbers, by(peak year peakid)

label variable avgrisk_s "Season Death and Injury Rate (%)"
label variable sznclimbers "Season Climbers"
label variable avghiredratioclimb "Average # of Climbers to Hired Climber"


*Balance panel
*Khumbu Avalanche
drop if year == 2014
*Earthquake
drop if year == 2015
*Unpopular year for climbing
drop if year == 2001 


*Peaks missing years 
drop if peak == 6

tsset peak year, yearly

*edit graph to put treatment line at 2015, which is when "treatment" actually occurred, I could not specify 2015 as the treatment time because that year's observations are absent due to the 2015 Earthquake
synth avgrisk_s avghiredratio(2005) avghiredratio(2009) avghiredratio(2011) avghiredratio(2012) avghiredratio(2013) avgprev8000(2005) avgprev8000(2009) avgprev8000(2011) avgprev8000(2012) avgprev8000(2013) avgrisk_s(2000) avgrisk_s(2002) avgrisk_s(2003) avgrisk_s(2005) avgrisk_s(2006) avgrisk_s(2007) avgrisk_s(2009) avgrisk_s(2010) avgrisk_s(2011) avgrisk_s(2012) avgrisk_s(2013), trunit(1) trperiod(2016) nested fig
