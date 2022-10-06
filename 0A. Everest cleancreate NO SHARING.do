*use "/Users/sarahkirker/Desktop/Thesisdata/Everest.dta"
*Everest data
destring myear, replace
destring year, replace

*Tibet side in control do file
drop if host == 2

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

**remember to leave out observation in calculating mean
***24 Hour Risk above high camp: msmtbid>3
egen nabandon_24hc = total(msmtterm != 1) if msmtbid > 3 & death == 0 & injury == 0, by(highptdate)
replace nabandon_24hc = nabandon_24hc - (msmtterm != 1 & msmtbid >3 & death == 0 & injury == 0) 
egen nsuccess_24hc = total(msmtterm == 1) if msmtbid > 3 & death == 0 & injury == 0, by(highptdate)
replace nsuccess_24hc = nsuccess_24hc - (msmtterm == 1 & msmtbid > 3 & death == 0 & injury == 0)
egen ndeath_24hc = total(death == 1) if msmtbid > 3, by(highptdate)
replace ndeath_24hc = ndeath_24hc - (death==1 & msmtbid > 3)
egen ninjury_24hc = total(injury == 1) if msmtbid > 3 & death == 0, by(highptdate)
replace ninjury_24hc = ninjury_24hc - (injury == 1 & msmtbid > 3 & death == 0)
generate totattempt_24hc = nabandon_24hc + nsuccess_24hc + ninjury_24hc + ndeath_24hc
generate risk_24hc = (ndeath_24hc + ninjury_24hc)/totattempt_24hc

**24h for all above BC msmtbid>1
egen nabandon_24 = total(msmtterm != 1) if msmtbid > 1 & death == 0 & injury == 0, by(highptdate)
replace nabandon_24 = nabandon_24hc - (msmtterm != 1 & msmtbid >1 & death == 0 & injury == 0) 
egen nsuccess_24 = total(msmtterm == 1) if msmtbid > 1 & death == 0 & injury == 0, by(highptdate)
replace nsuccess_24 = nsuccess_24 - (msmtterm == 1 & msmtbid > 1 & death == 0 & injury == 0)
egen ndeath_24 = total(death == 1) if msmtbid > 1, by(highptdate)
replace ndeath_24 = ndeath_24 - (death==1 & msmtbid > 1)
egen ninjury_24 = total(injury == 1) if msmtbid > 1 & death == 0, by(highptdate)
replace ninjury_24 = ninjury_24 - (injury == 1 & msmtbid > 1 & death == 0)
generate totattempt_24 = nabandon_24 + nsuccess_24 + ninjury_24 + ndeath_24
generate risk_24 = (ndeath_24 + ninjury_24)/totattempt_24

***Season risk above high camp => msmtbid > 3, no leave out means
egen nabandon_shc = total(msmtterm != 1) if msmtbid > 3 & death == 0 & injury == 0, by(myear season)
egen nsuccess_shc = total(msmtterm == 1) if msmtbid > 3 & death == 0 & injury == 0, by(myear season)
egen ndeath_shc = total(death == 1) if msmtbid > 3, by(myear season)
egen ninjury_shc = total(injury == 1) if msmtbid > 3 & death == 0, by(myear season)
generate totattempt_shc = nabandon_shc + nsuccess_shc + ninjury_shc + ndeath_shc
generate risk_shc = (ndeath_shc + ninjury_shc)/totattempt_shc

***Season level above BC
egen nabandon_s = total(msmtterm != 1) if msmtbid > 1 & death == 0 & injury == 0, by(myear season)
egen nsuccess_s = total(msmtterm == 1) if msmtbid > 1 & death == 0 & injury == 0, by(myear season)
egen ndeath_s = total(death == 1) if msmtbid > 1, by(myear season)
generate totattempt_s = nabandon_s + nsuccess_s + ninjury_s + ndeath_s
egen ninjury_s = total(injury == 1) if msmtbid > 1 & death == 0, by(myear season)
generate risk_s = (ndeath_s + ninjury_s)/totattempt_s

***Season level incl BC
egen nabandon_sbc = total(msmtterm != 1) if death == 0 & injury == 0, by(myear season)
egen nsuccess_sbc = total(msmtterm == 1) if death == 0 & injury == 0, by(myear season)
egen ndeath_sbc = total(death == 1), by(myear season)
egen ninjury_sbc = total(injury == 1) if death == 0, by(myear season)
generate totattempt_sbc = nabandon_sbc + nsuccess_sbc + ninjury_sbc + ndeath_sbc
generate risk_sbc = (ndeath_sbc + ninjury_sbc)/totattempt_sbc

***Collapse status
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

*Narrow time
drop if myear<2000
*Claims summit, disputed
drop if disputed == 1
*No age
drop if calcage == 0
*No climbing
drop if bconly == 1
*Climbing only as support
drop if support == 1 
drop if hired == 1 
*Earthquake year
drop if year == 2015 & season == 1
*Pandemic
drop if year == 2020
*Khumbu Avalanche
drop if year == 2014 & season == 1 
*Didn't make it to base camp
drop if mperhighpt<5100 & host == 2
drop if mperhighpt<5300 & host == 1
drop if msmtbid == 0
*Monsoon climbing
drop if season == 2
*Missed in narrowing time
drop if expid=="EVER19185"

replace status = "climber"

*Main route dummy
gen SCSER = 0
replace SCSER = 1 if route1 == "S Col-SE Ridge"

*PERMITS
replace expclimbers = totmembers
gen expclimbers7=expclimbers-7 if expclimbers>7 & status == "climber"
**Nepal after 2015
*Spring
gen permit = 11000 if status == "climber" & SCSER == 1 & host == 1 & myear> 2014 & season == 1
replace permit = 10000 if status == "climber" & SCSER == 0 & host == 1 & myear> 2014 & season == 1
replace permit = 757 if status =="climber" & SCSER == 1 & host == 1 & myear > 2015 & season ==1 & citizen == "Nepal"
replace permit = 605.6 if status == "climber" & SCSER == 0 & host == 1 & myear > 2015 & season ==1 & citizen == "Nepal"
*Autumn
replace permit = 5500 if status == "climber" & SCSER == 1 & host == 1 & myear> 2015 & season == 3
replace permit = 5000 if status == "climber" & SCSER == 0 & host == 1 & myear> 2015 & season == 3
replace permit = 378.5 if status == "climber"  & SCSER == 1 & host == 1 & myear > 2015 & season ==3 & citizen == "Nepal"
replace permit = 302.8 if status == "climber" & SCSER == 0 & host == 1 & myear > 2015 & season ==3 & citizen == "Nepal"
*Winter
replace permit = 2750 if status == "climber" & SCSER == 1 & host == 1 & myear> 2015 & season == 4
replace permit = 2500 if status == "climber" & SCSER == 0 & host == 1 & myear> 2015 & season == 4
replace permit = 184.2 if status == "climber" & SCSER == 1 & host == 1 & myear > 2015 & season ==3 & citizen == "Nepal"
replace permit = 151.4 if status == "climber" & SCSER == 0 & host == 1 & myear > 2015 & season ==3 & citizen == "Nepal"

*Nepal Main Route before 2015
replace permit= 25000 if host == 1 & myear<2015 & season == 1 & expclimbers== 1 & status == "climber" & SCSER == 1
replace permit= 20000 if host == 1 & myear<2015 & season == 1 & expclimbers== 2 & status == "climber" & SCSER == 1
replace permit= 48000/3 if host == 1 & myear<2015 & season == 1 & expclimbers== 3 & status == "climber" & SCSER == 1
replace permit= 14000 if host == 1 & myear<2015 & season == 1 & expclimbers== 4 & status == "climber" & SCSER == 1
replace permit= 60000/5 if host == 1 & myear<2015 & season == 1 & expclimbers== 5 & status == "climber" & SCSER == 1
replace permit= 66000/6 if host == 1 & myear<2015 & season == 1 & expclimbers== 6 & status == "climber" & SCSER == 1
replace permit= 10000 if host == 1 & myear<2015 & season == 1 & expclimbers>= 7 & status == "climber" & SCSER == 1


replace permit= 12500 if host == 1 & myear<2015 & season == 3 & expclimbers== 1 & status == "climber" & SCSER == 1
replace permit= 10000 if host == 1 & myear<2015 & season == 3 & expclimbers== 2 & status == "climber" & SCSER == 1
replace permit= 24000/3 if host == 1 & myear<2015 & season == 3 & expclimbers== 3 & status == "climber" & SCSER == 1
replace permit= 7000 if host == 1 & myear<2015 & season == 3 & expclimbers== 4 & status == "climber" & SCSER == 1
replace permit= 30000/5 if host == 1 & myear<2015 & season == 3 & expclimbers== 5 & status == "climber" & SCSER == 1
replace permit= 33000/6 if host == 1 & myear<2015 & season == 3 & expclimbers== 6 & status == "climber" & SCSER == 1
replace permit= 35000/7 if host == 1 & myear<2015 & season == 3 & expclimbers== 7 & status == "climber" & SCSER == 1
replace permit= (35000+5000*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 3 & expclimbers>7 & status == "climber" & SCSER == 1

replace permit= 6250 if host == 1 & myear<2015 & season == 4 & expclimbers== 1 & status == "climber" & SCSER == 1
replace permit= 5000 if host == 1 & myear<2015 & season == 4 & expclimbers== 2 & status == "climber" & SCSER == 1
replace permit= 12000/3 if host == 1 & myear<2015 & season == 4 & expclimbers== 3 & status == "climber" & SCSER == 1
replace permit= 14000/4 if host == 1 & myear<2015 & season == 4 & expclimbers== 4 & status == "climber" & SCSER == 1
replace permit= 15000/5 if host == 1 & myear<2015 & season == 4 & expclimbers== 5 & status == "climber" & SCSER == 1
replace permit= 16500/6 if host == 1 & myear<2015 & season == 4 & expclimbers== 6 & status == "climber" & SCSER == 1
replace permit= 17500/7 if host == 1 & myear<2015 & season == 4 & expclimbers== 7 & status == "climber" & SCSER == 1
replace permit= (17500+2500*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 4 & expclimbers>7 & status == "climber" & SCSER == 1

*Nepal Other Routes before 2015
replace permit= 15000 if host == 1 & myear<2015 & season == 1 & expclimbers== 1 & status == "climber" & SCSER == 0
replace permit= 21000/2 if host == 1 & myear<2015 & season == 1 & expclimbers== 2 & status == "climber" & SCSER == 0
replace permit= 27000/3 if host == 1 & myear<2015 & season == 1 & expclimbers== 3 & status == "climber" & SCSER == 0
replace permit= 33000/4 if host == 1 & myear<2015 & season == 1 & expclimbers== 4 & status == "climber" & SCSER == 0
replace permit= 39000/5 if host == 1 & myear<2015 & season == 1 & expclimbers== 5 & status == "climber" & SCSER == 0
replace permit= 45000/6 if host == 1 & myear<2015 & season == 1 & expclimbers== 6 & status == "climber" & SCSER == 0
replace permit= 50000/7 if host == 1 & myear<2015 & season == 1 & expclimbers>= 7 & status == "climber" & SCSER == 0
replace permit= (50000+10000*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 4 & expclimbers>7 & status == "climber" & SCSER == 0

replace permit= 7500 if host == 1 & myear<2015 & season == 3 & expclimbers== 1 & status == "climber" & SCSER == 0
replace permit= 10500/2 if host == 1 & myear<2015 & season == 3 & expclimbers== 2 & status == "climber" & SCSER == 0
replace permit= 13500/3 if host == 1 & myear<2015 & season == 3 & expclimbers== 3 & status == "climber" & SCSER == 0
replace permit= 17500/4 if host == 1 & myear<2015 & season == 3 & expclimbers== 4 & status == "climber" & SCSER == 0
replace permit= 19500/5 if host == 1 & myear<2015 & season == 3 & expclimbers== 5 & status == "climber" & SCSER == 0
replace permit= 22500/6 if host == 1 & myear<2015 & season == 3 & expclimbers== 6 & status == "climber" & SCSER == 0
replace permit= 25000/7 if host == 1 & myear<2015 & season == 3 & expclimbers== 7 & status == "climber" & SCSER == 0
replace permit= (25000+5000*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 3 & expclimbers>7 & status == "climber" & SCSER == 0

replace permit= 3750 if host == 1 & myear<2015 & season == 4 & expclimbers== 1 & status == "climber" & SCSER == 0
replace permit= 5250/2 if host == 1 & myear<2015 & season == 4 & expclimbers== 2 & status == "climber" & SCSER == 0
replace permit= 6750/3 if host == 1 & myear<2015 & season == 4 & expclimbers== 3 & status == "climber" & SCSER == 0
replace permit= 8750/4 if host == 1 & myear<2015 & season == 4 & expclimbers== 4 & status == "climber" & SCSER == 0
replace permit= 9750/5 if host == 1 & myear<2015 & season == 4 & expclimbers== 5 & status == "climber" & SCSER == 0
replace permit= 11250/6 if host == 1 & myear<2015 & season == 4 & expclimbers== 6 & status == "climber" & SCSER == 0
replace permit= 12500/7 if host == 1 & myear<2015 & season == 4 & expclimbers== 7 & status == "climber" & SCSER == 0
replace permit= (12500+2500*(expclimbers7))/expclimbers if host == 1 & myear<2015 & season == 4 & expclimbers>7 & status == "climber" & SCSER == 0

*known permit sharing, Arnette estimates 99.9% of expeditions on Nepal prior to new fee system shared permits in spring season to make each = $10000, literature confirms this. 
*replace permit = 10000 if host == 1 & myear<2015 & SCSER == 1 & season == 1 & status == "climber"
save "/Users/sarahkirker/Desktop/Thesisdata/EverestcleanedAPPENDIX.dta", replace
