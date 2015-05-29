//open NVM dataset and clean up

clear
capture log close
cd "C:\Users\Pieter\Documents\StreemMaster\THESIS\Stata\"
log using model.smcl, replace

insheet using "C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\ConstructedData\\NVM20052013all01.csv", comma

//
drop if hwdist > 1000
drop if maxspeed < 50
drop if roadtype == "Weg voor alle verkeer"
drop if surfacetype == "NA"
gen barrier = 0
replace barrier = 1 if bardist <= hwdist
gen rampdistsq = rampdist*rampdist

gen logpricesq = log(pricesq)

gen autoweg = 0
replace autoweg = 1 if roadtype == "Autoweg"
gen autosnelweg = 0
replace autosnelweg = 1 if roadtype == "Autosnelweg"
gen otherroad = 0
replace otherroad = 1 if roadtype == "Weg gesloten voor (brom)fietsers" | roadtype == "Weg gesloten voor langzaam verkeer"

gen geluidswand = 0
replace geluidswand = 1 if barriertype == "Geluidswand" | barriertype == "Geluidswand met luifelconstructie"
gen barrierwall = geluidswand*barrier
gen geluidsscherm = 0
replace geluidsscherm = 1 if barriertype == "Doorzichtig geluidsscherm" | barriertype == "Niet doorzichtig geluidsscherm"
gen barrierscreen = geluidsscherm*barrier
gen geluidswal = 0
replace geluidswal = 1 if barriertype == "Geluidswal" | barriertype == "Geluidswal met daarop of -in een scherm"
gen barrierearth = geluidswal*barrier

gen wallbarrier = 0
replace wallbarrier = 1 if barriertype == "Geluidswand" | barriertype == "Geluidswand met luifelconstructie" | barriertype == "Doorzichtig geluidsscherm" | barriertype == "Niet doorzichtig geluidsscherm"
gen bermbarrier = 0
replace bermbarrier = 1 if barriertype == "Geluidswal"
gen combobarrier = 0
replace combobarrier = 1 if barriertype == "Geluidswal met daarop of -in een scherm"

gen walbar = barrier*wallbarrier
gen berbar = barrier*bermbarrier
gen combar = barrier*combobarrier

gen max120130 = 0
replace max120130 = 1 if maxspeed == 120 | maxspeed == 130

gen max5070 = 0
replace max5070 = 1 if maxspeed >= 50 & maxspeed < 70
gen max7090 = 0
replace max7090 = 1 if maxspeed == 70 | maxspeed == 80 | maxspeed == 90
gen max100 = 0
replace max100 = 1 if maxspeed == 100
gen max12030 = 0
replace max120130 = 1 if maxspeed == 120 | maxspeed == 130


gen DB = 0
replace CB = 1 if surfacetype == "Cementbeton (CB)"
gen DAB = 0
replace DAB = 1 if surfacetype == "Dicht asfaltbeton (DAB)"
gen ZOAB = 0
replace ZOAB = 1 if surfacetype == "Zeer open asfalt beton (ZOAB)" | surfacetype == "Dubbel-/Tweelaags ZOAB (DZOAB)" | surfacetype == "Zeer open beton (ZOB)"

tabulate barriertype, gen(dbarriertype)

gen bermbarrier = barrier* dbarriertype2

gen combobarrier = barrier* dbarriertype3

gen wallbarrier = barrier* dbarriertype4

gen roofbarrier = barrier* dbarriertype5

gen intranspscreen = barrier* dbarriertype6


//
drop if hwdist1 > 1000
drop if maxspeed1 < 70
drop if roadtype1 == "Weg voor alle verkeer"
drop if surfacetype1 == "NA"
gen barrier1 = 0
replace barrier1 = 1 if bardist1 <= hwdist1
gen rampdistsq1 = rampdist1*rampdist1

gen autoweg1 = 0
replace autoweg1 = 1 if roadtype1 == "Autoweg"
gen autosnelweg1 = 0
replace autosnelweg1 = 1 if roadtype1 == "Autosnelweg"
gen otherroad1 = 0
replace otherroad1 = 1 if roadtype1 == "Weg gesloten voor (brom)fietsers" | roadtype1 == "Weg gesloten voor langzaam verkeer"

gen geluidswand1 = 0
replace geluidswand1 = 1 if barriertype1 == "Geluidswand" | barriertype1 == "Geluidswand met luifelconstructie"
gen barrierwall1 = geluidswand1*barrier1
gen geluidsscherm1 = 0
replace geluidsscherm1 = 1 if barriertype1 == "Doorzichtig geluidsscherm" | barriertype1 == "Niet doorzichtig geluidsscherm"
gen barrierscreen1 = geluidsscherm1*barrier1
gen geluidswal1 = 0
replace geluidswal1 = 1 if barriertype1 == "Geluidswal" | barriertype1 == "Geluidswal met daarop of -in een scherm"
gen barrierearth1 = geluidswal1*barrier1

gen max5070_1 = 0
replace max5070_1 = 1 if maxspeed1 >= 50 & maxspeed1 < 70
gen max7090_1 = 0
replace max7090_1 = 1 if maxspeed1 >= 70 & maxspeed1 <= 90
gen max100_1 = 0
replace max100_1 = 1 if maxspeed1 == 100
gen max120_1 = 0
replace max120_1 = 1 if maxspeed1 == 120
gen max130_1 = 0
replace max130_1 = 1 if maxspeed1 == 130

gen CB1 = 0
replace CB1 = 1 if surfacetype1 == "Cementbeton (CB)"
gen DAB1 = 0
replace DAB1 = 1 if surfacetype1 == "Dicht asfaltbeton (DAB)"
gen ZOAB1 = 0
replace ZOAB1 = 1 if surfacetype1 == "Zeer open asfalt beton (ZOAB)" | surfacetype1 == "Dubbel-/Tweelaags ZOAB (DZOAB)"
gen ZOB1 = 0
replace ZOB1 = 1 if surfacetype1 == "Zeer open beton (ZOB)"




drop if hwdist > 500
drop if ZOB == 1
drop if rampdist > 4000

xtreg  logprice  barrierwall1 barrierscreen1 barrierearth1 CB1 DAB1 ZOAB1 max7090_1 max100_1 max120_1 max130_1  autoweg1 autosnelweg1 otherroad1 hwdist1 rampdist1 logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 maintgood garage gardenx centralhea i.year,fe robust


reg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, robust
est sto model
xtset pc6
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model1
xtset pc5
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model2
xtset pc5
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model3
xtset mun
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model4

keep if prov_id == 7 | prov_id == 8 | prov_id ==9
xtset pc6
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model5
xtset pc5
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model6
xtset pc5
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model7
xtset mun
xtreg logpricesq hwdist1 barrier rampdist rampdistsq logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, fe robust
est sto model8

esttab model model1 model2 model3 model4 model5 model6 model7 model8 using models.rtf
areg logpricesq loghwdist barrier logrampdist logsize logrooms apartment terraced semidetach detached  constrlt45 constr1945 constr1960 constr1971 constr1981 constr1991 constrlt00 garage garden centralhea listed maintgood i.year, absorb(pc6) robust

