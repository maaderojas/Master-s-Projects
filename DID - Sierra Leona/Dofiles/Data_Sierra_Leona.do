*===============================================================================
*========================== EXPLOTATION DES DONNEES DO =========================
*===============================================================================


*========================== Nettoyage des données/Data Cleaning ==============================

cd "C:\Users\ade_rojas\Universidad\Master 2\Microeconometrie\Exploitation des données\base de données\MICS\dta bd files"

*========================== SELECTION of VARIABLES ==============================


*Base women 

/* Variable List


- HH1: Cluster number 
- HH2: Household number
- HH7: region 
- HH6: Area 
- HH7A: district
- WM6Y: Year of interview (évaluer pertinence)

- LN: line number
- WM4: women's line number
- MA4: number of wives 
- MA8Y: year of first union 
- CP1: currently pregnant
- WM9: data entry clerk 
- CM10: children ever born 

========================================================================

varlist : HH1 HH2 HH7 HH6 HH7A LN WM6Y WB2 WB4 WB5 WM9 WM4 WAGE WB7 WAGEM MA1 MA4 MA8Y MA7 CP1 CP2 CM4 CM8 CM9A CM10 SB1 SB2 SB4 SB9 SB15 DV UN4 UN6


- WAGE : age group
- WB2 : Age of women (continous variable)
- WAGEM: Age at first marriage/union
- SB1: Age at first sexual intercourse
- CM4: Any sons or daughters living with you  -> (CM5A: sons ;CM5B: Daughters)
- CM9A: boys dead (not match found)
- WB7: can read part of these sentence? (90% cannont read at all !!!)
- SB2 4 9 : about use of condon last (not match found), first  sexual intercourse and used with prior parthner -> 91% (no), 97% (no) and 86% (no) respectly. 
- MA1: Currently married or living with a man
- CP2: Currently using a method to avoid pregnancy
- CM8: Ever had child who later died
- WB4 : Highest level of school you attended  -> ()
- WB5 : Highest grade completed at that level -> ()
- DV : variables about domestic violence 
- MA7 : Married or lived with a man once or more than once
- SB15 : number of sexual partners (not match found)
- UN4 : Would like to have another child (currently pregnant) 
- UN6 : Would like to have another child (not currently pregnant) => (not match found)

========================================================================

*/ 

foreach X in "wm_2010" "wm_2017"   {  
	use "`X.dta'", clear
	keep HH1 HH2 HH7 HH6 HH7A LN WM6Y WB2 WB4 WB5 WM9 WM4 WAGE WB7 WAGEM MA1 MA4 MA8Y MA7 CP1 CP2 CM4 CM8 CM10 SB1 SB4 SB9 UN4 
	save "`X'_keeped_vc.dta", replace
}
*Base Household 

/* Variables List

varlist : helevel HHSEX HC1A windex5 HH7A HH7 HH6 HH5Y HH1 HH2 HC1B HC1C HC10 HC15

- HH1: Cluster number 
- HH2: Household number
- HH7: region 
- HH6: Area 
- HH5Y: Year of interview (évaluer pertinence)

- helevel: Education of household head
- HHSEX: Sex of Household head
- HC1A: Religion of household
- windex5: Wealth index quintiles
- HH7A: district

========================================================================

- HC1B : Mother tongue of household head
- HC1C : Ethnic group of household head (not match found)
- HC10 : Household owns the dwelling (not match found)
- HC15 : Any household member own bank account

========================================================================

*/ 

foreach X in "hl_2010" "hh_2017"   {  
	use "`X.dta'", clear
	keep helevel HHSEX HC1A windex5 HH7A HH7 HH6 HH5Y HH1 HH2 HC1B HC15
	save "`X'_keeped_vc.dta", replace
}

*Base Household members 

/* Variables List

varlist : HH1 HH2 HL1 HL3 HL4 age Scolarisation helevel melevel felevel CL3 CL4 CL5 CL6

- HH1: Cluster number 
- HH2: Household number
- HL1: Line number
- HL3: Relationship to the head
- HL4: Sex
- age: age
- Scolarisation: Attended school during current school year (2009-2010)
- helevel: Education of household head
- melevel: Mother's education
- felevel: Father's education

========================================================================

- CL3 : Worked in past week for someone who is not a HH member (not match found)
- CL4 : Hours worked in past week for someone who is not a HH member
- CL5 : Worked in past week to fetch water or collect firewood for household use
- CL6 : Hours to fetch water or collect firewood

========================================================================

*/ 

foreach X in "hl_2010" "hl_2017"   {  
	use "`X.dta'", clear
	 keep HH1 HH2 HL1 HL3 HL4 age Scolarisation helevel melevel felevel 
	save "`X'_keeped_vc.dta", replace
}


*========================== Individual Base ==============================

/* Base de 2005
use wm_2005_keeped_vc
merge HH1 HH2 using hl_2005_keeped_vc
keep if _merge == 3 
rename _merge _m1
merge m:1 HH1 HH2 using hh_2005_keeped_vc
keep if _merge == 3
save 2005_vc, replace*/


*Base de 2010
use wm_2010_keeped_vc
merge HH1 HH2 using hl_2010_keeped_vc
keep if _merge == 3 
rename _merge _m1
merge m:1 HH1 HH2 using hh_2010_keeped_vc
keep if _merge == 3
save 2010_vc, replace

*Base de 2017 
use wm_2017_keeped_vc
merge HH1 HH2 using hl_2017_keeped_vc 
keep if _merge == 3 
rename _merge _m1
merge m:1 HH1 HH2 using hh_2017_keeped_vc 
keep if _merge == 3
save 2017_vc, replace

 
*========================== Variables Creation ==============================
// Analyse var Scolarisation //

ta Scolarisation, nolabel
ta CP1, nolabel
ta HL4, nolabel

foreach X in "2010_vc" "2017_vc"   {  
	use "`X.dta'", clear
	*drop main
	 gen main = 1 if Scolarisation == 1 & CP1 == 1 & HL4 == 2 & age <19 & age >5
	 replace main = 0 if main == . 
	* label define main 1 "Yes" 2 "No"
	 *label values main main
	 gen mother_educ = 1 if melevel != 0 & melevel != 9
	 replace mother_educ = 0 if mother_educ ==.
	 gen father_educ = 1 if felevel != 0 & felevel != 9
	 replace father_educ = 0 if father_educ ==.
     label define mother_educ 1 "Education" 2 "No education"
	 label values mother_educ mother_educ
	 label define father_educ 1 "Education" 2 "No education"
	 label values father_educ father_educ 
	 drop melevel felevel
	save "`X'.dta", replace
}

foreach X in "2010_vc" "2017_vc"   {  
	use "`X.dta'", clear
	*drop educ2
	egen educ2 = count (main), by (HH1) 
	gen Islam = 1 if HC1A == 1 
	replace Islam = 0 if Islam ==. 
	gen Christian = 1 if HC1A == 1 
	replace Christian = 0 if Christian == .  
	drop HC1A
	gen pauvre = 1 if windex5 <= 3
	replace pauvre = 0 if pauvre == 0
	gen Riche = 1 if windex5 > 3
	replace Riche = 0 if Riche == 0
	drop windex5
	gen rural = 1 if HH6 == 1 
	replace rural = 0 if rural == . 
	gen urbain = 1 if HH6 == 2
	replace urbain = 0 if urbain == . 
	drop HH6
	save "`X'.dta", replace
}



*=================== BASE FINAL (PANEL 2010-2017) ========================


use 2010_vc, clear
*append using 2010_vc
append using 2017_vc
*label variable educ2 "Total enrolled by clusters"
save data.dta, replace

use data
keep HH1 HH2 HH5Y CP1 MA8Y HH7 HH7A age Scolarisation mother_educ father_educ main Islam Christian pauvre Riche rural urbain
replace CP1 = 0 if CP1 != 1 
replace age = . if age == 98
replace age = . if age == 99
collapse (mean) age (sum) Scolarisation mother_educ father_educ main Islam Christian pauvre Riche rural urbain CP1 , by (HH1 HH7A HH5Y)
sort HH7A
decode HH7A, gen(HH7A1)
sort HH7A1
save data2.dta, replace


use BD_Ebola_cas, clear
*gen HH7A = District
drop DIS Casedefinition Epiweek  idDistrict idyear cas_mean
rename District HH7A
label define HH7A 1 "Bo" 2 "Bombali" 3 "Bonthe" 4 "Kailahun" 5 "Kambia" 6 "Kenema" 7 "Koinadugu" 8 "Kono" 9 "Moyamba" 10 "Port Loko" 11 "Pujehun" 12 "Tonkolili" 13 "Western Rural" 14 "Western Urban", replace
label values HH7A HH7A
collapse (sum) CAS, by (HH7A)
sort HH7A
decode HH7A, gen(HH7A1)
sort HH7A1
save Cas_Ebola, replace

use data2, clear
merge m:1 HH7A1 using Cas_Ebola
save base_final 













/*  District |      Freq.     Percent        Cum.
------------+-----------------------------------
         11 |      8,766        6.99        6.99
         12 |     10,796        8.60       15.59
         13 |      7,440        5.93       21.52
         21 |      8,969        7.15       28.67
         22 |      9,313        7.42       36.09
         23 |      9,549        7.61       43.70
         24 |      9,776        7.79       51.49
         25 |      8,172        6.51       58.00
         31 |      9,484        7.56       65.56
         32 |      8,132        6.48       72.04
         33 |      6,666        5.31       77.35
         34 |      7,214        5.75       83.10
         41 |      8,109        6.46       89.56
         42 |     13,099       10.44      100.00
------------+-----------------------------------

     District |      Freq.     Percent        Cum.
--------------+-----------------------------------   
     Kailahun |      8,766        6.99        6.99
       Kenema |     10,796        8.60       15.59
         Kono |      7,440        5.93       21.52
      Bombali |      8,969        7.15       28.67
       Kambia |      9,313        7.42       36.09
    Koinadugu |      9,549        7.61       43.70
    Port Loko |      9,776        7.79       51.49
    Tonkolili |      8,172        6.51       58.00
           Bo |      9,484        7.56       65.56
       Bonthe |      8,132        6.48       72.04
      Moyamba |      6,666        5.31       77.35
      Pujehun |      7,214        5.75       83.10
Western Rural |      8,109        6.46       89.56
Western Urban |     13,099       10.44      100.00
--------------+-----------------------------------
*/

reg main CAS rural urbain Riche pauvre Christian Islam father_educ mother_educ age
