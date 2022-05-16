//Methode Evaluation D'impact: Sri Lanka 

keep district qa4 qa6 qa7 qa8 qa12 qb2 qb3 qb4 qb19 qb20 qb24 qb45 workingchild hazard_ff childla_15_17 childla_12_14 childla_5_11 childla_labour qf13 qf19
keep if qa6 <18 
drop if qa8==5 //Seulement une observation

gen Tleisure=0 if qb19<=10 & qb19>0 //regroupement temps loisir 
replace Tleisure=1 if qb19>10 
replace Tleisure=2 if qb19 >=15
replace Tleisure=3 if qb19 >=30
ta Tleisure 

gen HouseK=1 if qb45==1      //Regroupement temps travail tâches ménagères 
replace HouseK=2 if qb45==2
replace HouseK=3 if qb45==3
replace HouseK=4 if qb45==4
replace HouseK=5 if qb45==5
replace HouseK=6 if qb45>5 
replace HouseK=7 if qb45==.
ta HouseK 

gen educ=1 if qb3>=1 & qb3<=5 //Primary Education
replace educ=2 if qb3>6 // Junior Secondary Level
replace educ=3 if qb3>9 //Senior Secondary Level 
replace educ=4 if qb3>11  // General Certificate Education or Ordinary Level 
ta educ 

gen livestock=qf13
gen income=qf19
gen ethnicity=qa7
gen religion=qa8
gen age=qa6
gen sex=qa4
gen loan=qf15 

ta qa7 
replace qa7=5 if qa7>=5 //Regroupement minorités 5,6,7 : 5 Autres 

//workingchild plus d'enfant mais diff a childla_labour  
ta district workingchild, chi2 exact //Il y a une relation significative entre les district et le travail infantil 
ta working child qb2 // 60% des enfants qui travaillent ne vont pas à l'école au moment de l'enquête 
ta qb2 // environ 10% des enfants enquêtés ne vont pas à l'école dont 14% sont des workingchild 
tab2 district qb2 if workingchild==1 //Tab des enfants par districts et sscolarisation si workingchild

*probit workingchild district qa4 qa6 qa7  qa8 qa12 qb4 qb19 qb45 qf13 qf19 //distance to school non sig,ni niveau educ, 
*probit workingchild district qa4 qa6 qa7 qa8 qb45 qf13 qf19
drop if workingchild==. 
*xi: logit workingchild district qa4 qa6 i.qa7 qb45 qf13 qf19 //Best one 
corr qa7 district 

gen enrollement=qb2
gen land=qf12_1a 
drop ethnicity 

melogit workingchild qa4 qa6 i.qa7 i.qa8 qb19 qb2 qb45 qf12_1a qf13 qf15 qf19 || district : 

melogit workingchild sex age i.ethnicity i.religion enrollement Tleisure livestock income loan || district : 
est store enrollement 
melogit workingchild sex age i.ethnicity i.religion i.educ Tleisure livestock income loan || district : 
est store educ
esttab enrollement educ, b(%10.3f) se scalars(N ll) mtitles(Enroll NEduc)
esttab using modeles.tex,replace 
estout 


/*using modeles.tex,replace ///
nobaselevels longtable eform label booktabs star(* 0.10 ** 0.05 *** 0.01) ///
title("Résultats  working children melogistic model") mtitle("Enroll" "Neduc")
estout*/


esttab enrollement educ, b(%10.3f) se scalars(N ll) compress mtitles(Enroll NEduc)

 
//Voire pour latex 

*melogit workingchild qa4 qa6 i.qa7 i.qa8  qb2 qb19 qb45 qf13 qf19|| district :
estat icc //rho = 0.095 

clustersampsi, binomial samplesize p1(0.38) p2(0.52) k(25) rho(0.095) alpha(0.05) beta(0.78)

clustersampsi, binomial samplesize p1(0.38) p2(0.52) k(32) rho(0.095) alpha(0.025) beta(0.8)

//25 Clusters-Villages - 28 menages lotterie 2 traitements et 28 controle par cluster 
//Total de menages enquêtés 700 par T ou C : N=1400 
 // Choisit apres baisline les villages avec plus de ultra pauvres, on donne aleatoirement aux ultra pauvre d'un nombre déterminer de village, à 28 menages un type de traitement, 
 //des villages qui n'ont été pas pris: on selection aléatoirement 28 menages qui servent de controle 
 
 //MDE de 14%: disp (1.96+1.68)*sqrt(1/(0.38*0.62*50))*sqrt(0.095*(0.905/28)*5.83)=0.14189598

 //Proportion variation en termes de scolarisation des workingchildren p1 et p2, p1 selon le Child Activity Survey 2016
 //Passage de l'obeserver dans l'échantillon à la moyenne nationale 
 
 
 




