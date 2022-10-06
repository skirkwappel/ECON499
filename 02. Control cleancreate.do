*use "/Users/sarahkirker/Desktop/Thesisdata/Controlappended.dta"

*initialize
destring myear, replace 
destring year, replace
drop if host == 1 & peakid == "EVER"

**Season risk above high camp
egen nabandon_shc = total(msmtterm != 1) if msmtbid > 3 & death == 0 & injury == 0, by(myear season peakid)
replace nabandon_shc = nabandon_shc - (msmtterm != 1 & msmtbid >3 & death == 0 & injury == 0)
egen nsuccess_shc = total(msmtterm == 1) if msmtbid > 3 & death == 0 & injury == 0, by(myear season peakid)
replace nsuccess_shc = nsuccess_shc - (msmtterm == 1 & msmtbid >3 & death == 0 & injury == 0)
egen ndeath_shc = total(death == 1) if msmtbid > 3, by(myear season peakid)
replace ndeath_shc = ndeath_shc - (msmtbid >3 & death == 1)
egen ninjury_shc = total(injury == 1) if msmtbid > 3 & death == 0, by(myear season peakid)
replace ninjury_shc = ninjury_shc - (injury == 1 & msmtbid >3 & death == 0)
generate totattempt_shc = nabandon_shc + nsuccess_shc + ninjury_shc + ndeath_shc
generate risk_shc = (ndeath_shc + ninjury_shc)/totattempt_shc

** Season risk above base camp 
egen nabandon_s = total(msmtterm != 1) if msmtbid > 1 & death == 0 & injury == 0, by(myear season peakid)
replace nabandon_s = nabandon_s - (msmtterm != 1 & msmtbid >1 & death == 0 & injury == 0)
egen nsuccess_s = total(msmtterm == 1) if msmtbid > 1 & death == 0 & injury == 0, by(myear season peakid)
replace nsuccess_s = nsuccess_s - (msmtterm == 1 & msmtbid >1 & death == 0 & injury == 0)
egen ndeath_s = total(death == 1) if msmtbid > 1, by(myear season peakid)
replace ndeath_s = ndeath_s - (msmtbid >1 & death == 1)
egen ninjury_s = total(injury == 1) if msmtbid > 1 & death == 0, by(myear season peakid)
replace ninjury_s = ninjury_s - (injury == 1 & msmtbid >1 & death == 0)
generate totattempt_s = nabandon_s + nsuccess_s + ninjury_s + ndeath_s
generate risk_s = (ndeath_s + ninjury_s)/totattempt_s

**Season Risk ALL
egen nabandon_sbc = total(msmtterm != 1) if death == 0 & injury == 0, by(myear season peakid)
replace nabandon_sbc = nabandon_sbc - (msmtterm != 1 & death == 0 & injury == 0)
egen nsuccess_sbc = total(msmtterm == 1) if death == 0 & injury == 0, by(myear season peakid)
replace nsuccess_sbc = nsuccess_sbc - (msmtterm == 1 & death == 0 & injury == 0)
egen ndeath_sbc = total(death == 1), by(myear season peakid)
replace ndeath_sbc = ndeath_sbc - (death == 1)
egen ninjury_sbc = total(injury == 1) if death == 0, by(myear season peakid)
replace ninjury_sbc = ninjury_sbc - (injury == 1 & death == 0)
generate totattempt_sbc = nabandon_sbc + nsuccess_sbc + ninjury_sbc + ndeath_sbc
generate risk_sbc = (ndeath_sbc + ninjury_sbc)/totattempt_sbc

*Date of high point variable
replace msmtdate1= "." if msmtdate1 == "  -   -"
generate datevar = msmtdate1
drop if msmtbid==1 & datevar=="."
replace datevar=smtdate if datevar=="."
split datevar, g(part) p("/")
replace part1 = "0" + part1 if length(part1) < 2
replace part2 = "0" + part2 if length(part2) < 2
gen tmp= part1+part2+part3
gen highptdate= date(tmp, "MDY")
form highptdate %td
drop tmp part1 part2 part3 datevar

**Risk measures, no difference in host here, only Nepal  
**24h Risk above high camp
egen nabandon_24hc = total(msmtterm != 1) if msmtbid > 3 & death == 0 & injury == 0, by(highptdate peakid)
replace nabandon_24hc = nabandon_24hc - (msmtterm != 1 & msmtbid >3 & death == 0 & injury == 0) 
egen nsuccess_24hc = total(msmtterm == 1) if msmtbid > 3 & death == 0 & injury == 0, by(highptdate peakid)
replace nsuccess_24hc = nsuccess_24hc - (msmtterm == 1 & msmtbid > 3 & death == 0 & injury == 0)
egen ndeath_24hc = total(death == 1) if msmtbid > 3, by(highptdate peakid)
replace ndeath_24hc = ndeath_24hc - (death==1 & msmtbid > 3)
egen ninjury_24hc = total(injury == 1) if msmtbid > 3 & death == 0, by(highptdate peakid)
replace ninjury_24hc = ninjury_24hc - (injury == 1 & msmtbid > 3 & death == 0)
generate totattempt_24hc = nabandon_24hc + nsuccess_24hc + ninjury_24hc + ndeath_24hc
generate risk_24hc = (ndeath_24hc + ninjury_24hc)/totattempt_24hc

**24h Risk above base camp
egen nabandon_24 = total(msmtterm != 1) if msmtbid > 1 & death == 0 & injury == 0, by(highptdate peakid)
replace nabandon_24 = nabandon_24hc - (msmtterm != 1 & msmtbid >1 & death == 0 & injury == 0) 
egen nsuccess_24 = total(msmtterm == 1) if msmtbid > 1 & death == 0 & injury == 0, by(highptdate peakid)
replace nsuccess_24 = nsuccess_24 - (msmtterm == 1 & msmtbid > 1 & death == 0 & injury == 0)
egen ndeath_24 = total(death == 1) if msmtbid > 1, by(highptdate peakid)
replace ndeath_24 = ndeath_24 - (death==1 & msmtbid > 1)
egen ninjury_24 = total(injury == 1) if msmtbid > 1 & death == 0, by(highptdate peakid)
replace ninjury_24 = ninjury_24 - (injury == 1 & msmtbid > 1 & death == 0)
generate totattempt_24 = nabandon_24 + nsuccess_24 + ninjury_24 + ndeath_24
generate risk_24 = (ndeath_24 + ninjury_24)/totattempt_24


**collapse status, drop non-climbers 
gen Z = lower(status)
rename status role
rename Z status

replace status = "hired climber" if hired == 1 & msmtbid > 1
replace status = "climber" if hired == 0 

**Climber:Hired
gen expclimbers = totmembers
gen exphired = tothired
gen hiredratio = expclimbers/exphired
replace hiredratio = 0 if nohired == 1
*Ratio hired climbers only
egen exphiredclimb = total(status=="hired climber"), by(expid)
gen hiredratioclimb = expclimbers/exphiredclimb
replace hiredratioclimb = 0 if nohired == 1

*Bad Weather, Adverse Conditions dummy
gen bw = 0
replace bw = 1 if msmtterm==3
replace bw = 1 if weather == 1
egen badweath= max(bw), by(msmtdate1 host)
gen adco= 0
replace adco = 1 if msmtterm == 4
egen advcon = max(adco), by(msmtdate1 host)

*crowding, how many other people summit
gen s = 1
egen sds = total(s) if msmtbid>3, by(msmtdate1 host)
replace sds= sds - 1
drop s
gen crowding = 0 if msmtbid>3
replace crowding = 1 if sds>=150 & msmtbid>3

*Narrow time period
drop if myear<2000
drop if expid == "KANG10101" & myear == 1910
*Pandemic
drop if myear == 2020
*Khumbu Avalanche
drop if year == 2014 & season == 1 & peakid == "LHOT"
*Not to base camp, never climbed
drop if msmtbid == 0
*Disputed climbs
drop if disputed == 1
*No age
drop if calcage == 0
*No season, monsoon season
drop if season == 0
drop if season == 2
*Missed in cleaning
drop if year == 1986
*Earthquake year
drop if myear == 2015 & season ==1 
*Support and hired climbers/personel
drop if bconly == 1
drop if support == 1
drop if hired == 1 


*** Permits
gen expclimbers7=expclimbers-7 if expclimbers>7 & status == "climber"
*2015-2019 Nepal
gen permit = 1800 if host == 1 & myear>2014 & season ==1 & citizen!="Nepal" & status == "climber"
replace permit = 900 if host == 1 & myear>2014 & season ==3 & citizen!="Nepal" & status == "climber"
replace permit = 450 if host == 1 & myear>2014 & season ==4 & citizen!="Nepal" & status == "climber"
replace permit = 100.93 if host == 1 & myear>2014 & season == 1 & citizen=="Nepal" & status == "climber"
replace permit = 50.45 if host == 1 & myear>2014 & season == 3 & citizen=="Nepal" & status == "climber"
replace permit = 25.23 if host == 1 & myear>2014 & season == 4 & citizen=="Nepal" & status == "climber"

*Nepal before 2015
replace permit= 5000 if host == 1 & myear<2015 & season == 1 & expclimbers== 1 & status == "climber"
replace permit= 3000 if host == 1 & myear<2015 & season == 1 & expclimbers== 2 & status == "climber"
replace permit= 7000/3 if host == 1 & myear<2015 & season == 1 & expclimbers== 3 & status == "climber"
replace permit= 2000 if host == 1 & myear<2015 & season == 1 & expclimbers== 4 & status == "climber"
replace permit= 8500/5 if host == 1 & myear<2015 & season == 1 & expclimbers== 5 & status == "climber"
replace permit= 9000/6 if host == 1 & myear<2015 & season == 1 & expclimbers== 6 & status == "climber"
replace permit= 10000/7 if host == 1 & myear<2015 & season == 1 & expclimbers== 7 & status == "climber"
replace permit= (10000+1500*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 1 & expclimbers>7 & status == "climber"

replace permit= 2500 if host == 1 & myear<2015 & season == 3 & expclimbers== 1 & status == "climber"
replace permit= 1500 if host == 1 & myear<2015 & season == 3 & expclimbers== 2 & status == "climber"
replace permit= 3500/3 if host == 1 & myear<2015 & season == 3 & expclimbers== 3 & status == "climber"
replace permit= 1000 if host == 1 & myear<2015 & season == 3 & expclimbers== 4 & status == "climber"
replace permit= 4250/5 if host == 1 & myear<2015 & season == 3 & expclimbers== 5 & status == "climber"
replace permit= 4500/6 if host == 1 & myear<2015 & season == 3 & expclimbers== 6 & status == "climber"
replace permit= 5000/7 if host == 1 & myear<2015 & season == 3 & expclimbers== 7 & status == "climber"
replace permit= (5000+1000*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 3 & expclimbers>7 & status == "climber"

replace permit= 1250 if host == 1 & myear<2015 & season == 4 & expclimbers== 1 & status == "climber"
replace permit= 750 if host == 1 & myear<2015 & season == 4 & expclimbers== 2 & status == "climber"
replace permit= 1750/3 if host == 1 & myear<2015 & season == 4 & expclimbers== 3 & status == "climber"
replace permit= 500 if host == 1 & myear<2015 & season == 4 & expclimbers== 4 & status == "climber"
replace permit= 2125/5 if host == 1 & myear<2015 & season == 4 & expclimbers== 5 & status == "climber"
replace permit= 2250/6 if host == 1 & myear<2015 & season == 4 & expclimbers== 6 & status == "climber"
replace permit= 2500/7 if host == 1 & myear<2015 & season == 4 & expclimbers== 7 & status == "climber"
replace permit= 3000/8 if host == 1 & myear<2015 & season == 4 & expclimbers== 8 & status == "climber"
replace permit= (3000+500*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 4 & expclimbers>7 & status == "climber"

*Nepal before 2008
replace permit= 4500 if host == 1 & myear<2009 & expclimbers<8 & status == "climber"
replace permit = (4500 + 500*(expclimbers7))/expclimbers if host == 1 & myear<2009 & expclimbers>7 & status == "climber"

**Tibet for Cho Oyu
replace permit = 3800 if myear == 2000 & host == 2 & status == "climber"
replace permit = 4000 if myear == 2008 & host == 2 & status == "climber"
replace permit = 7400 if myear >2017 & host == 2 & status == "climber"
ipolate permit myear if host == 2 & status =="climber", generate(permit1)
replace permit = permit1 if status == "climber" & host == 2

**Tibet Permits for Everest -North 
replace permit = 4300 if status == "climber" & host == 2 & myear == 2000 & peakid == "EVER"
replace permit = 4900 if status == "climber" & host == 2 & myear == 2007 & peakid == "EVER"
replace permit = 5500 if status == "climber" & host == 2 & myear > 2008 & peakid == "EVER"
replace permit = 8000 if status == "climber" & host == 2 & myear > 2011 & peakid == "EVER"
ipolate permit myear if host == 2 & status =="climber" & peakid == "EVER", generate(permit2)
replace permit = permit2 if host == 2 & status == "climber" & peakid == "EVER"
replace permit = 11000 if status == "climber" & host == 2 & myear == 2019 & expclimbers >3 & peakid == "EVER"
replace permit = 21000 if status == "climber" & host == 2 & myear == 2019 & expclimbers <4 & peakid == "EVER"

drop permit1 permit2 expclimbers7 bw adco
replace risk_24 = 2/3 if expid == "CHOY10113"


*save "/Users/sarahkirker/Desktop/Thesisdata/Controlappendedcleaned.dta"
