*append
use "/Users/sarahkirker/Desktop/Thesisdata/Everestcleaned.dta"
append using "/Users/sarahkirker/Desktop/Thesisdata/Controlappendedcleaned.dta", force

***experience
gen nameyob = fname + " " + lname+ " " +yob
drop _merge
merge 1:1 expid membid peakid myear nameyob using "/Volumes/Lexar/Thesis/8000experience/8000.dta"
*Drop hired- not included in main dataset, only experience 
drop if _merge==2
drop _merge

gen risk_24pct = risk_24*100
gen risk_24hcpct = risk_24hc*100
gen risk_spct = risk_s*100
gen risk_shcpct = risk_shc*100
gen risk_sbcpct = risk_sbc*100


gen peak = 1 if peakid == "EVER" & host == 1
replace peak = 2 if peakid == "EVER" & host == 2
replace peak = 3 if peakid == "ANN1"
replace peak = 4 if peakid == "CHOY"
replace peak = 5 if peakid == "DHA1"
replace peak = 6 if peakid == "KANG"
replace peak = 7 if peakid == "LHOT"
replace peak = 8 if peakid == "MAKA"
replace peak = 9 if peakid == "MANA"

gen c = 1
egen sumsznclimbers= total(c), by(season year peak)
drop c

gen month = 04 if season == 1
replace month = 09 if season == 3
replace month = 12 if season == 4
gen day = 01
gen datevar = mdy(month, day, myear)
format datevar %td
gen year1 =year(datevar) 

gen O2 = mo2used
drop age
gen age = calcage

label variable O2 "Oxygen"
label variable age "Age"
label variable prev8000atmpt "Previous 8000m attempt"
label variable preveveratmpt "Previous Everest attempt"
label variable preveversucc "Previous Everest success"
label variable prev8000succ "Previous 8000m Success"
label variable advcon "Bad Conditions"
label variable badweat "Bad Weather"
label variable crowding "Crowding"
label variable sds "Same day summitters"
label variable risk_24pct "Percentage Risk- 24h above Base Camp"
label variable risk_24hcpct "Percentage Risk- 24h above High Camps"
label variable risk_spct "Season Risk above BC"
label variable risk_shcpct "Season Risk above HC"
label variable risk_sbcpct "Season Risk"
label variable hiredratioclimb "Climbers: Hired Climbers"
label variable hiredratio "Climbers: Hired"
label variable permit "Permit Cost"
label variable expclimbers "Team Size" 
label variable sds "Same day Summitters"
label variable sumsznclimbers "Season Climbers"

*Permit transformations
gen lnpermit = ln(permit)
gen permitA = permit/1000
rename year eyear
rename year1 year
drop expclimbers7 bw adco SCSER
label variable permitA "Permit Royalty"
label variable lnpermit "ln(Permit)"

*Count variables
gen countrisk_24 = ndeath_24 + ninjury_24
gen countrisk_24hc = ndeath_24hc + ninjury_24hc
gen countrisk_s = ndeath_s + ninjury_s
gen countrisk_sbc = ndeath_sbc + ninjury_sbc
gen countrisk_shc = ndeath_shc + ninjury_shc

label variable countrisk_24 "Deaths & Injuries in 24h"
label variable countrisk_24hc "Deaths & Injuries in 24h>7900"


gen treated = 0 if peak == 1
replace treated = 1 if peak == 1 & year > 2014

*Everest Permit
gen permitE = 10 if year<2015
replace permitE = 11 if year>2015


gen drisk_s = risk_s*100
gen drisk_shc = risk_shc*100
gen drisk_sbc = risk_sbc*100
gen drisk_24 = risk_24*100
gen drisk_24hc = risk_24hc*100

*save "/Users/sarahkirker/Desktop/Thesisdata/Main.dta"
