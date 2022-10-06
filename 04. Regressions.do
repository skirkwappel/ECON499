use "/Users/sarahkirker/Desktop/Thesisdata/Main.dta"
*Panel A: OLS 
eststo: reg countrisk_24 permitA badweat advcon i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA age O2 prev8000atmpt crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24hc permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year i.season if peak==1, robust

esttab using 1.tex, indicate("Year FE =*.year" "Weather/Conditions Controls = advcon badweath" "Season FE = *.season" "Individual Controls = age prev8000atmpt O2" "Expedition Controls = hiredratioclimb expclimbers" ) star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber scalar(r2)

eststo clear


*Panel B: NBREG

*eststo: nbreg countrisk_24 permitA badweat advcon i.year if peak== 1 & season == 1, vce(robust) difficult
*eststo: nbreg countrisk_24 permitA crowding advcon badweat i.year if peak==1 & season == 1,  vce(robust)
*eststo: nbreg countrisk_24 permitA age O2 prev8000atmpt crowding advcon badweat i.year if peak==1 & season == 1, difficult vce(robust)
*eststo: nbreg countrisk_24 permitA crowding age O2 prev8000atmpt expclimbers hiredratioclimb advcon badweat i.year if peak==1 & season == 1,vce(robust) 
*eststo: nbreg countrisk_24hc permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, difficult vce(robust)
*eststo: nbreg countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year i.season if peak==1, difficult vce(robust)

*esttab using 2.tex, indicate("Year FE =*.year""Weather FE = badweath""Conditions FE= advcon" "Individual Controls = age prev8000atmpt O2" "Expedition Controls = hiredratioclimb expclimbers" "Season FE = *.season") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se title(Regression Results\label{tab1}) page(dcolumn) nonumber scalar(r2_p)

eststo clear 
*Pandel B: ZINB
eststo: zinb countrisk_24 permitA badweat advcon i.year if peak==1 & season == 1, inflate(sds badweath) robust
eststo: zinb countrisk_24 permitA crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) robust
eststo: zinb countrisk_24 permitA age O2 prev8000atmpt crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) difficult robust
eststo: zinb countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) difficult robust
eststo: zinb countrisk_24hc permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) difficult robust
eststo: zinb countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year i.season if peak==1, inflate(sds badweath) difficult robust

esttab using 3.tex, indicate("Year FE =*.year" "Weather/Conditions Controls = advcon badweath" "Season FE = *.season" "Individual Controls = age O2 prev8000atmpt" "Expedition Controls = hiredratioclimb expclimbers") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label nonumber scalar(chi2 df_m)
eststo clear

balancetable treated age O2 prev8000atmpt prev8000succ preveveratmpt preveversucc hiredratioclimb hiredratio expclimbers sds crowding badweath advcon using bt.tex if peak == 1 & season == 1, robust varla

***Interactions with tests
*
eststo: reg countrisk_24 permitA c.permitA#c.hiredratioclimb hiredratioclimb  expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust
test c.permitA#c.hiredratioclimb + permitA=0
eststo: reg countrisk_24 permitA c.permitA#c.hiredratioclimb hiredratioclimb age O2 prev8000atmpt crowding advcon badweat i.year if peak==1 & season == 1, robust
test c.permitA#c.hiredratioclimb + permitA=0
eststo: reg countrisk_24 permitA c.permitA#c.hiredratioclimb hiredratioclimb age O2 prev8000atmpt expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust
test c.permitA#c.hiredratioclimb + permitA=0
eststo: zinb countrisk_24 permitA c.permitA#c.hiredratioclimb hiredratioclimb  expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust inflate(sds badweath) difficult
test c.permitA#c.hiredratioclimb + permitA=0
eststo: zinb countrisk_24 permitA c.permitA#c.hiredratioclimb hiredratioclimb age O2 prev8000atmpt crowding advcon badweat i.year if peak==1 & season == 1, robust inflate(sds badweath)
test c.permitA#c.hiredratioclimb + permitA=0
eststo: zinb countrisk_24 permitA c.permitA#c.hiredratioclimb hiredratioclimb age O2 prev8000atmpt expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust inflate(sds badweath) difficult
test c.permitA#c.hiredratioclimb + permitA=0

esttab using inter.tex, indicate("Year FE =*.year" "Weather/Conditions Controls = advcon badweath" "Season FE = *.season" "Individual Controls = age prev8000atmpt O2" "Expedition Controls = expclimbers" "Crowding Controls = crowding" ) star(* 0.10 ** 0.05 *** 0.01) drop(_cons hiredratioclimb) replace interaction(" X ") se label page(dcolumn) nonumber scalar( N)

*Externalities 
*panel A: OLS
eststo: reg countrisk_24 permitE advcon badweath i.year i.peak i.season if peak != 1, robust
eststo: reg countrisk_24 permitE expclimbers hiredratioclimb advcon badweath i.year i.peak i.season if peak != 1, robust
eststo: reg countrisk_24 permitE  age O2 prev8000atmpt advcon badweath i.year i.peak i.season if peak != 1, robust
eststo: reg countrisk_24 permitE crowding advcon badweath i.year i.peak i.season if peak != 1, robust
eststo: reg countrisk_24 permitE age O2 prev8000atmpt expclimbers hiredratioclimb advcon badweath i.year i.peak i.season if peak != 1, robust
eststo: reg countrisk_24 permitE crowding age O2 prev8000atmpt expclimbers hiredratioclimb advcon badweath i.year i.peak i.season if peak != 1, robust
esttab using 4.tex, indicate("Year FE =*.year" "Peak FE = *.peak" "Season FE = *.season" "Weather/Conditions Controls = advcon badweath" "Individual Controls = age O2 prev8000atmpt" "Expedition Controls = hiredratioclimb expclimbers" "Crowding Controls = crowding") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label nonumber scalar(r2)
eststo clear
*panel B: 
eststo: zinb countrisk_24 permitE advcon badweath i.year i.peak i.season if peak != 1, robust inflate(badweath sds)
eststo: zinb countrisk_24 permitE expclimbers hiredratioclimb advcon badweath i.year i.peak i.season if peak != 1, robust inflate(badweath sds)
eststo: zinb countrisk_24 permitE  age O2 prev8000atmpt advcon badweath i.year i.peak i.season if peak != 1, robust inflate(badweath sds)
eststo: zinb countrisk_24 permitE crowding advcon badweath i.year i.peak i.season if peak != 1, robust inflate(badweath sds)
eststo: zinb countrisk_24 permitE age O2 prev8000atmpt expclimbers hiredratioclimb advcon badweath i.year i.peak i.season if peak != 1, robust inflate(badweath sds)
eststo: zinb countrisk_24 permitE crowding age O2 prev8000atmpt expclimbers hiredratioclimb advcon badweath i.year i.peak i.season if peak != 1, robust inflate(badweath sds)
esttab using 5.tex, indicate("Year FE =*.year" "Peak FE = *.peak" "Season FE = *.season" "Weather/Conditions Controls = advcon badweath" "Individual Controls = age O2 prev8000atmpt" "Expedition Controls = hiredratioclimb expclimbers" "Crowding Controls = crowding") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label nonumber scalar(chi2 df_m)
eststo clear


*Full size regression table 
*Panel A: OLS 
eststo: reg countrisk_24 permitA badweat advcon i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA age O2 prev8000atmpt crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24hc permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, robust
eststo: reg countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year i.season if peak==1, robust

esttab using 1f.tex, indicate("Year FE =*.year" "Season FE = *.season") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label page(dcolumn) nonumber scalar(r2)
eststo clear 

*Panel B: ZINB
eststo: zinb countrisk_24 permitA badweat advcon i.year if peak==1 & season == 1, inflate(sds badweath) robust
eststo: zinb countrisk_24 permitA crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) robust
eststo: zinb countrisk_24 permitA age O2 prev8000atmpt crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) difficult robust
eststo: zinb countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) difficult robust
eststo: zinb countrisk_24hc permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) difficult robust
eststo: zinb countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year i.season if peak==1, inflate(sds badweath) difficult robust
*Additional Robustness Checks: zero-predictors, Poisson (low \alpha)
eststo: zinb countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds age O2 hiredratioclimb) vce(robust)
eststo: zip countrisk_24 permitA age O2 prev8000atmpt hiredratioclimb expclimbers crowding advcon badweat i.year if peak==1 & season == 1, inflate(sds badweath) difficult vce(robust)

esttab using 3f.tex, indicate("Year FE =*.year" "Season FE = *.season") star(* 0.10 ** 0.05 *** 0.01) drop(_cons) se label nonumber scalar(chi2 df_m N)
eststo clear
