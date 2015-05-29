//open NVM dataset and clean up

clear
capture log close
cd "C:\Users\Pieter\Documents\StreemMaster\THESIS\Stata\"
log using opennvm.smcl, replace

import delimited "C:\Users\Pieter\Documents\StreemMaster\THESIS\Data\OriginalData\Geodata\nvm_2000_2001306_DucodeVos.csv", delim(",")

	
drop if transaprijs > 1000000
drop if transaprijs < 25000
drop if m2 > 250
drop if m2 < 25
g prijsm2 = transaprijs/m2
drop if prijsm2 > 5000
drop if prijsm2 < 500
drop if nkamers > 25
drop if x == 0
drop if y == 0

egen houseid1 = group(pc6code huisnummer huisnrtoev type bwper)
by houseid1, sort: egen corr_m2 = mean(m2)
by houseid1, sort: egen corr_nkamers = mean(nkamers)

replace corr_m2 = int((m2-corr_m2-0.0001)/10) // 0 = no more than 5 m2 difference from mean
replace corr_nkamers = int((nkamers-corr_nkamers-0.0001)/5) // 0 = no more than 2.5 rooms difference from mean
egen houseid2 = group(pc6code huisnummer huisnrtoev type corr_m2 corr_nkamers bwper)
drop houseid1 corr_m2 corr_nkamers

*translating to English
g price = transaprijs
drop transaprijs
g pricesqm = prijsm2
drop prijsm2
g priceask = oorspr
drop oorspr
g priceaskadj = laats 
drop laats
g size = m2
drop m2
g rooms = nkamers
drop nkamers
g apartment = 0
replace apartment = 1 if type==-1 | type==0
g terraced = 0
replace terraced = 1 if type==1 | type==2
g semidetached = 0
replace semidetached = 1 if type==3 | type==4
g detached = 0
replace detached = 1 if type==5
g constrlt1945 = 0
drop type
g garage = 0
replace garage = 1 if parkeer==3 | parkeer==4 | parkeer==6 | parkeer==8
drop parkeer
g garden = 0
replace garden = 1 if tuinlig>0
drop tuinlig
g onbibu = onbi+onbu
g maintgood = 0
replace maintgood = 1 if onbibu>13
drop onbibu
drop onbi
drop onbu
g centralheating = 0
replace centralheating = 1 if verw > 1
drop verw
g listed = monument
drop monument
replace constrlt1945 = 1 if bwper==0 | bwper==1 | bwper==2 | bwper==3
g constr19451959 = 0 
replace constr19451959 = 1 if bwper==4
g constr19601970 = 0 
replace constr19601970 = 1 if bwper==5
g constr19711980 = 0 
replace constr19711980 = 1 if bwper==6
g constr19811990 = 0 
replace constr19811990 = 1 if bwper==7
g constr19912000 = 0 
replace constr19912000 = 1 if bwper==8
g constrgt2000 = 0 
replace constrgt2000 = 1 if bwper==9
order constr*, after(listed)
drop bwper
g year = substr(datum_afm,1,4)
destring year, force replace
g month = substr(datum_afm,6,2)
destring month, force replace
g day = substr(datum_afm,9,2)
destring day, force replace
g pc6 = pc6code
drop pc6code
tostring pc6, force g(pc4)
replace pc4 = substr(pc4,1,4)
destring pc4, force replace
g mun = gem_id
drop gem_id
g xcoord = x
drop x
g ycoord = y
drop y
gen date = date( datum_aanm,"YMD")
gen date2 = date(datum_afm,"YMD")
g daysonmarket = date2-date

* Generate unique house id
duplicates tag houseid2, g(times)
replace times = times+1
duplicates tag houseid2 year, g(yeartimes)
replace yeartimes = yeartimes+1
g random = 0
replace random = runiform() if times > 8 // change houseid if more than 8 times transacted in 26 year
replace random = runiform() if yeartimes > 1 // change houseid if more than 1 times transacted in one year
egen houseid = group(houseid2 random)
egen xyid = group(xcoord ycoord)
drop houseid2 times yeartimes random

drop geom loc_status bag_identificatie makelaar kelder ged_verhrd permanent erfpacht ligdrukw ligmooi ligcentr isol tuinafw inpandig nbadk nwc nbijkeuk nkeuken ndakterras ndakkap nbalkon woonka praktijkr vlier zolder vtrap nverdiep kwaliteit lift openportk status isbelegging isnieuwbw nvmcijfers datum_afm datum_aanm loopt verkpcond procverschil soortwon soortapp kenmerkwon soorthuis huisklasse inhoud woonopp perceel categorie woonplaats postcode huisnrtoev huisnummer straatnaam afd_id nvmreg_id prov_id
rename id obsid
order houseid xyid, after(obsid)

label variable price "transaction price in €"
label variable pricesqm "transaction price in € per m2"
label variable priceask "first asking price in €"
label variable priceask "asking price in €"
label variable priceaskadj "adjusted asking price in €"
label variable size "size of property in m2"
label variable rooms "number of rooms"
label variable garage "property has garage"
label variable apartment "apartment"
label variable terraced "terraced property"
label variable semidetached "semi-detached property"
label variable detached "detached property"
label variable garden "property has garden"
label variable maintgood "maintenance state is good"
label variable centralheating "property has central heating"
label variable listed "property is (part of) listed building"
label variable constrlt1945 "construction year <1945"
label variable constr19451959 "construction year 1945-1959"
label variable constr19601970 "construction year 1960-1970"
label variable constr19711980 "construction year 1971-1980"
label variable constr19811990 "construction year 1981-1990"
label variable constr19912000 "construction year 1991-2000"
label variable constrgt2000 "construction year >2000"
label variable year "year of observation"
label variable month "month of observation"
label variable day "day of observation"
label variable pc6 "postcode 6-digit"
label variable pc4 "postcode 4-digit"
label variable mun "municipality code"
label variable xcoord "x-coordinate (gcs amersfoort)"
label variable ycoord "y-coordinate (gcs amersfoort)"
label variable daysonmarket "days on the market"
label variable houseid "property id"
label variable xyid "location id"

save "`path'\NVM_cleaned.dta", replace
