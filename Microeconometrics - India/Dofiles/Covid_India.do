
*===============================================================================
*================ Microeconometrie _ Impact Covid Inde =========================
*===============================================================================

* Set directory 

cd "C:\Users\ade_rojas\Universidad\Master 2\Microeconometrie\Exploitation des données\base de données\MICS\dta bd files"

//Tableaux De State Descrptive
sum con_wk,d 
sum con_feb, d

//Création variable d'intensité d'impact 

ta geo_state
gen covid_intensity=0 if geo_state==20
replace covid_intensity=1 if geo_state==23 | geo_state==10| geo_state==8
replace covid_intensity=2 if geo_state==28 | geo_state==9
label var covid_intensity "Case Intensity COVID-19"
label define casesoct2020 0 "Less than 100 000" 1 "Less than 200 000" 2 "Over 400 000"
label values covid_intensity casesoct2020
ta covid_intensity

gen diff_inc=lab_march_wage-lab_curr_wage 
label var diff_in "Wage Variation" 
ta diff_inc 

//Intensités déterminer d'après les résultats en le 09/10/2010 : https://www.statista.com/statistics/1103458/india-novel-coronavirus-covid-19-cases-by-state/
//On assumme des persitances des tendance de niveau de contagion au cours du temps

*==================================================================================
 *Variables Supprimées
*==================================================================================
 
 ta agr_sell_lckdwn 
 // De base comme agr_sell_lckdwn n'a que 18 observations on peut l'éliminer directement
 ta con_curr_rice 
 // De même comme le prix du riz n'as que 389 observations par rapport à notre échantillon on peut l'éliminer
 ta agr_curr_land 
 //On a que 114 observations, on elimine 
 ta agr_sell_diff
 //On aque 153 observations, on elimine or elle était très intéressante pour savoir quels étaient les problèmes liés à la vente agricole
 ta agr_curr_borrow 
 // QUe 152 observations, on elimine  or interresant car c'était une source de revenu possible or dépend des facilités d'accès aux prêts des ménages
 ta agr_curr_inputs 
 //que 172 observations, on elimine or interresant car c'était une source de revenu possible or depend des facilités de prêts pour les ménages
 ta agr_curr_land 
 //que 114 observations, on elimine 
 
 drop agr_sell_lckdwn con_curr_rice agr_curr_land agr_sell_diff agr_curr_borrow agr_curr_inputs agr_curr_land  
 
 *==================================================================================
 * Test 
 *=================================================================================
 
//reg con_wk con_feb geo_state demo_gender demo_age demo_selfhelp demo_caste demo_edu demo_ag_hh con_curr_atta con_curr_onions lab_curr_wage lab_curr_occu  agr_crop_grown agr_crop_planted agr_crop_status rel_transfer_amt covid_intensity 
// no observations 

*TEST VARIABLES CONTROL 
reg con_wk con_feb_wk geo_state //significatifs mais R trop faible 
reg con_wk con_feb_wk geo_state covid_intensity // intensité covid pas significative 
reg con_wk con_feb_wk geo_state diff_inc //diff_inc pas significative p-value=0.7 
reg con_wk con_feb_wk geo_state demo_ag_hh //demo pas significative 
reg con_wk con_feb_wk geo_state demo_selfhelp // Si on rajoute demo_selfhelp celui-ci est significatif mais pas geo_state 
reg con_wk con_feb_wk geo_state demo_gender //demo_gender pas significative
reg con_wk con_feb_wk geo_state demo_age //demo_age pas significative 
reg con_wk con_feb_wk geo_state demo_edu  //toutes significatives 
reg con_wk con_feb_wk geo_state demo_caste // demo_caste pas significative 
reg con_wk con_feb_wk geo_state demo_hh_size //toutes les variables sont significatif a ve p-value de geo-state=0,05
reg con_wk con_feb_wk geo_state demo_selfhelp demo_edu //Au seuil de 5% geo_state pas significatif mais significatif au seuil 10%

reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size //Geo-state devient pas significative 
reg con_wk con_feb_wk geo_state demo_selfhelp demo_edu  demo_hh_size rel_transfer_amt // En rajoutant les transfers geo_state devient pas significatif, rel_transfer_amt et demo_selfhelp pas significative
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size con_curr_atta // con_curr_atta pas siginificative 
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size con_curr_onions //con_curr_onions significative 
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size lab_curr_wage // lab_curr_wage pas significative et rend demo_selfhelp, demo_hh_size et geo_state pas significatif
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size lab_curr_occu  //lab_curr_occu pas significative et rend demo_selfhelp puis geo_state pas significative
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size agr_crop_grown // agr_crop_grown pas significative et rend geo_state pas significative 
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size agr_crop_planted //agr_crop_planted pas significative et rend geo_state puis demo_selfhelp pas significatives
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size agr_crop_status //agr_crop_status siginificative mais rend geo_state et demo_selfhelp pas singificatives
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu demo_hh_size diff_inc //pas significatif et rend geo_state, demo_selfhelp puis demo_hh_size pas significatives 
reg con_wk con_feb_wk  geo_state demo_selfhelp demo_edu con_curr_onions demo_hh_size agr_crop_status // geo_state et demo_selfhelp pas significatives mais on gaigne des points en R (0,14) 
reg con_wk con_feb_wk  demo_edu demo_hh_size con_curr_onions agr_crop_status //toutes significatives R=0,14 


*Observation corrélation entre variables 
pwcorr geo_state demo_selfhelp, star (0.05) //Corrélation positive autour de 0,3585
pwcorr geo_state rel_transfer_amt, star (0.05) // Corrélation négatice autour de -0,1587 
pwcorr lab_curr_wage demo_selfhelp, star (0.05) // Pas de corrélation (-0,0224)
pwcorr lab_curr_occu demo_selfhelp, star (0.05) // Pas de corrélation (-0,0279) 
pwcorr geo_state agr_crop_grown, star (0.05) //Corrélation positive de 0,2230
pwcorr geo_state agr_crop_planted, star (0.05)//Corrélation négative de (-0,1584) 
pwcorr demo_selfhelp agr_crop_planted, star (0.05)//Pas de corrélation (-0,0399) 
pwcorr demo_hh_size geo_state, star(0.05)  // Corrélation négative de (-0,1512) 

 *test de variables omises et colinéarité 
 reg con_wk con_feb_wk  demo_edu demo_hh_size con_curr_onions agr_crop_status //regression idéale selon les observations précédentes, toutes les variables sont significatives
 est store reg1
 ovtest  // on rejtte H0, il y a des varibales omises 
 
 reg con_wk con_feb_wk geo_state demo_selfhelp demo_edu demo_hh_size con_curr_onions agr_crop_status rel_transfer_amt //Ici, d'après les p-values seulement con_feb, demo_edu et demo_hh_size seraient significatives au seuil de 5% 
 est store reg2 
 ovtest  // il n' y pas  des variables omises p-value (0.1878) 
 vif //vif autour de 1 et 1/VIF supérieure à 0,7 
 
 reg con_wk con_feb_wk demo_edu demo_hh_size con_curr_onions agr_crop_status covid_intensity //Covid intensity pas significative 
 est store regcovid1 
 ovtest //on rejette H0 
 vif //pas de colinéarité 
 
 reg con_wk con_feb_wk geo_state demo_selfhelp demo_edu demo_hh_size con_curr_onions agr_crop_status rel_transfer_amt covid_intensity 
 est store regcovidintes2
 ovtest // il n'y a pas des variables omises (p-value de 0,0617) or seulement con_feb, demo_edu et demo_hh_size significatives 
 vif //Pas de colinéarité apparante 
 

 *==============================================================================================
 * QUALITÉ DES REGRESSIONS 1 ET 2 
 *=============================================================================================
 
 //Regression 1 : REGRESSION DE BASE 
 reg con_wk con_feb_wk  demo_edu demo_hh_size con_curr_onions agr_crop_status
predict fitted_values, xb
predict res_con1, res
 hettest //On a de l'hétéroscédasticité 
 reg con_wk con_feb  demo_edu demo_hh_size con_curr_onions agr_crop_status, robust //Ici agr_crop_status devient pas significative
 
 //Regression 2 
 reg con_wk con_feb_wk geo_state demo_selfhelp demo_edu demo_hh_size con_curr_onions agr_crop_status rel_transfer_amt
 predict fitted_values2, xb
predict res_con2, res
hettest // On a de l'hétéroscédacticité 
reg con_wk con_feb geo_state demo_selfhelp demo_edu demo_hh_size con_curr_onions agr_crop_status rel_transfer_amt, robust
// On a les mêmes variables significatives que dans le modèle 1 

//Regression 3 : INTENSITÉ SELON LE NOMBRE DE CAS 
reg con_wk con_feb_wk  demo_edu demo_hh_size con_curr_onions agr_crop_status covid_intensity , robust 
*==============================================================================================
*Option Avec Difference De Wage
*=============================================================================================

  reg con_wk con_feb_wk demo_edu demo_hh_size con_curr_onions diff_inc //r=0,12
  ovtest //probleme variables omises 
  vif //pas de probleme de colinéarite 
  predict fittes_valueswage, xb
  predict res_wagediff, res
  hettest //hétéroscédasticité 
  reg con_wk con_feb demo_edu demo_hh_size diff_inc, robust //demo_hh_size et diff_inc deviennent pas significatives 
  pwcorr diff_inc demo_hh_size, star (0.05) //pas colinearite 

  reg con_wk con_feb demo_edu demo_hh_size con_curr_onions diff_inc geo_state demo_selfhelp rel_transfer_amt //Seulement con_feb signficative 
