*================================================================================
                            CHEMIN D'ACCES
*===============================================================================        

	di c(judos)

		if  "`c(judos)'" == "Julian" { 
			global path "C:\Users\judos\Google Drive\MASTER 2. ESDP\S2\Spatial Econometrics\Group\BD spatial"
			global slash	"\"
		}

		
use "C:\Users\judos\Google Drive\MASTER 2. ESDP\S2\Spatial Econometrics\Group\BD spatial\Latinobarometro_2018_Esp_Stata_v20190303.dta"
		
set more off	

set scheme plotplain	
*================================================================================
                            LISTE DES VARIABLES ARCH - LOG 
*===============================================================================        

  describe, short
	log using "C:\Users\judos\Documents\Drive\MASTER 2. ESDP\Mémoire\log_liste des variables.smcl",  
	describe
	log off                                                    
	list in 1/5
	list demo* in 1/5
	sum
*================================================================================
                            CODE RENAME VARIABLES
*===============================================================================        

local i 0
foreach varname of varlist * {
    local ++i
    if ( "`varname'" != ustrtoname("`varname'") ) {
        mata : st_varrename(`i', ustrtoname("`varname'") )
    }
}

exit

*===============================================================================
                      Variables 
*===============================================================================

IDENPA = Identificación del País

REG = Región/ Provincia

CIUDAD = Ciudad

TAMCIUD = Tamano de la ciudad 

EDAD = 

P21STGBS_B = Voto gobierno-oposición

P22ST = Escala Izquierda-Derecha

P67STC ¿Cree Ud. que su voto es secreto o los partidos o el gobierno pueden descubrir por quien Ud. votó?

P71TI.A Proporción de personas involucradas en corrupción: Presidente y sus funcionarios

P72TI.B Proporción de personas involucradas en corrupción: Los parlamentarios

P73TI.C Proporción de personas involucradas en corrupción: Los empleados públicos

P74TI.D Proporción de personas involucradas en corrupción: Concejales del Gobierno local

P75TI.E Proporción de personas involucradas en corrupción: La policia

P76TI.F Proporción de personas involucradas en corrupción: Oficina Nacional de Impuestos

P77TI.G Proporción de personas involucradas en corrupción: Jueces y magistrados

P78TI.H Proporción de personas involucradas en corrupción: Lideres religiosos

P79TI.I Proporción de personas involucradas en corrupción: Empresarios

S1 Clase social subjetiva

S10 Estudios del entrevistado

describe, short

// Variables // 

list IDENPA REG CIUDAD TAMCIUD EDAD SEXO P21STGBS_B P22ST P31NI P74TI_D P75TI_E P76TI_F P77TI_G S1 S10 S11 

// Netoyage // 

cd "C:\Users\judos\Google Drive\MASTER 2. ESDP\S2\Spatial Econometrics\Group\BD spatial"

foreach X in "base mod" {  
	use "`X.dta'", clear
	keep IDENPA CIUDAD EDAD P21STGBS_B Educ corrup civic_eng ICT trad cap_c d_t_open
	save "`X'_v1_nc.dta", replace
	}

	taP21STGBS_B 
	desc
	
// Filtre BD = colombie (170), équateur (218) et venezuela (862) //// 
	
keep if IDENPA == 170 | IDENPA == 218 | IDENPA == 862 | IDENPA == 591
keep if CIUDAD == 170000000 | CIUDAD == 170001000 | CIUDAD == 170002000 |  CIUDAD == 170004000 | CIUDAD == 170005000 | CIUDAD == 170006000 | CIUDAD == 170007000 | CIUDAD == 170010000 | CIUDAD == 170011000 | CIUDAD == 170013000 | CIUDAD == 170014000 |  CIUDAD ==170017000 |  CIUDAD ==170019000 | CIUDAD == 170020000 |  CIUDAD ==170021000 |  CIUDAD ==170022000 |  CIUDAD ==170025000 |  CIUDAD ==170027000 | CIUDAD ==170029000 | CIUDAD ==170030000 | CIUDAD ==218017003 | CIUDAD ==218017001 | CIUDAD ==218011004 | CIUDAD ==218019003 | CIUDAD ==218019012 | CIUDAD ==218019026 | CIUDAD ==218021004 | CIUDAD ==218022002 | CIUDAD == 218022004| CIUDAD ==218022005 | CIUDAD ==862005001 | CIUDAD ==862005002 | CIUDAD ==862005003 | CIUDAD ==862005011 | CIUDAD ==862019006 | CIUDAD ==862019010 | CIUDAD ==862019013 | CIUDAD ==862019021 | CIUDAD ==862019023 | CIUDAD ==862023003 | CIUDAD ==862023004 | CIUDAD ==862023008 | CIUDAD ==862023009 | CIUDAD ==862023024 


keep if id==6601 | id==6987 | id==6254 | id==5878 | id==5906 |id==6411 |id==6519 |id==6838 |id==5894 |id==6021 |id==6792 |id==5876 | id==6693 |id==6937 |id==6053 |id==6587 |id==6132 |id==6634 |id==6770 |id==7008 |id==7049 |id==7030 |id==7033 |id==7038 |id==7041| id==7039 |id==8407 |id==8467 |id==8431 |id==8498 |id==8522 |id==8515 |id==8510 |id==8388 |id==8196 |id==8195 | id==8211 |id==8158 

/*  Boucle standardisation des variables corruption. */

// test normalité =  vars ne sont pas issues d'une population normalment distribuée// 

foreach var in P71TI_A P72TI_B P73TI_C P74TI_D P75TI_E P76TI_F P77TI_G P78TI_H P79TI_I {
sum `var'                                          //`altgr + 7 suivit de ' la touche 4//
sfrancia `var'
}

// Corruption Gov Local = P74TI_D //

gen corr_sc_govl = 0 if P74TI_D == 1 
replace corr_sc_govl = 0.33 if P74TI_D == 2
replace corr_sc_govl = 0.66 if P74TI_D == 3
replace corr_sc_govl = 0.99 if P74TI_D == 4
replace corr_sc_govl = . if P74TI_D == -4 & P74TI_D == -2 & P74TI_D == -1

// Corruption Police = P75TI_E //

gen corr_sc_pol = 0 if P75TI_E == 1 
replace corr_sc_pol = 0.33 if P75TI_E == 2
replace corr_sc_pol = 0.66 if P75TI_E == 3
replace corr_sc_pol = 0.99 if P75TI_E == 4
replace corr_sc_pol = . if P75TI_E == -4 & P75TI_E == -2 & P75TI_E == -1

// Corruption impot = P76TI_F //

gen corr_sc_imp = 0 if P76TI_F == 1 
replace corr_sc_imp = 0.33 if P76TI_F == 2
replace corr_sc_imp = 0.66 if P76TI_F == 3
replace corr_sc_imp = 0.99 if P76TI_F == 4
replace corr_sc_imp = . if P76TI_F == -4 & P76TI_F == -2 & P76TI_F == -1

// Corruption juge et magistrat = P74TI_G //

gen corr_sc_mag = 0 if P77TI_G == 1 
replace corr_sc_mag = 0.33 if P77TI_G == 2
replace corr_sc_mag = 0.66 if P77TI_G == 3
replace corr_sc_mag = 0.99 if P77TI_G == 4
replace corr_sc_mag = . if P77TI_G == -4 & P77TI_G == -2 & P77TI_G == -1

// Index corruption // 

gen corrup = (corr_sc_govl+corr_sc_pol+corr_sc_imp+corr_sc_mag)/4 

// Education // 

ta S10, nolabel

recode S10 (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (11=11) (12=12) (13=13) (14/15=14) (16/17=15), gen(Educ) 

// Moyenne par ville en fonction des catégories de la variable éducation = S10 // 
   
// Classe social subjetive var= S1 // 

gen S1a = S1
recode S1 -1=0 -2=0 1=1 2=2 3=3 4=4 5=5 6=6 7=7, gen(S1b)
replace S1b = . if S1b == 0
tab S1b

// Civic Engagement // 

ta P19ST_A,nolabel  // Con la familia // 
ta P19ST_B, nolabel  // Los amigos  //
ta P19ST_C   // Compañeros de trabajo  //
ta P19ST_D // Mis compañeros de estudio //
ta P19ST_E // Radio // 
ta P19ST_F  // Diarios/ Revistas // 
ta P19ST_G // M. Electronicos: Internet // 
ta P19ST_H   // Tele // 
tab P19NC_I  // Facebook //
ta P19NC_J  // Twitter //
ta P19F_K   // Youtube //
ta P19ST_L // otro //
ta P19ST_M // Ninguno // 

tab P19ST_G

gen trad = ((P19ST_F==1)+ (P19ST_D==1) + (P19ST_C==1) + (P19ST_B==1) + (P19ST_A==1))/5
gen ICT  = ((P19ST_H==1) + (P19ST_E==1) + (P19ST_G==1) + (P19NC_I==1) + (P19NC_J==1) + (P19F_K ==1)) / 6
gen civic_eng = ((ICT)*0.60)+((trad)*0.40) // WEIGHTING = (ICT=0.60) ; (trad=0.40) // 

tabstat civic_eng, stat(mean sd min max)

// levels of civic enagement interval [0, 4.166667] // 

    variable |      mean        sd       min       max
-------------+----------------------------------------
   civic_eng |   .319381  .1971871         0         1
------------------------------------------------------

// Political Momentum =  P21STGBS_B vote oposition // 

ta P21STGBS_B 
recode P21STGBS_B (-3=1) (2=2)

gen pol_momen = 1 if P21STGBS_B== 1
replace pol_momen = 0 if pol_momen != 1 

// Degree of Trade Openess // 

gen d_t_open =1 if CIUDAD == 170001000 | CIUDAD == 170004000 | CIUDAD == 170005000 |  CIUDAD == 170013000 |  CIUDAD ==170019000 | CIUDAD == 170021000 | CIUDAD ==170022000 | CIUDAD ==170030000 | CIUDAD ==218022002 | CIUDAD == 218022004| CIUDAD ==218022005 | CIUDAD ==218019003 | CIUDAD ==862005001 | CIUDAD ==862005002 | CIUDAD ==862005003 | CIUDAD ==862005011 |CIUDAD ==862019006 | CIUDAD ==862023003
replace d_t_open = 0 if d_t_open != 1 

ta d_t_open

// Capital city // 

gen cap_c =1 if CIUDAD == 170000000 | CIUDAD == 218019003  
replace cap_c = 0 if cap_c != 1 

// Log GDP //

gen lg_GDP_cap= ln(GDP_capita)


// Natural capital log // 

gen lg_Nat_cap= ln(Nat_cap)

drop lg_GDP_cap


// Collapse // 

// drop if CIUDAD== 862003001 | CIUDAD==862003002 | CIUDAD==862003004| CIUDAD==862003005 | CIUDAD==170014000

// drop if CIUDAD==170014000 // 

collapse (mean) trad ICT corrup civic_eng EDAD pol_momen Educ cap_c d_t_open, by(IDENPA CIUDAD)


// Merge bd latinobarometro + bd extended data // 

use "C:\Users\judos\Google Drive\MASTER 2. ESDP\S2\Spatial Econometrics\Group\BD spatial\base mod_v1_c.dta"

destring Ciudades id Population GDP GDP_capita Superficie_km2 Density Minority Migration Nat_cap Latitud Longitud ParticipationPolitica, replace 

// DISTANCE : Spatial matrix // 

 global xcor Latitud  // cordenadas latitudes 
 global ycor Longitud //cordenadas longitudes 
 global band 10  // distancia threshold 
 global ylist corrup // var expliqué 
 global xlist Minority Migration lg_Nat_cap lg_GDP_cap Density cap_c d_t_open // variables explicatives 
 global betalist lg_Nat_cap lg_GDP_cap Density corrup
 //spatial matrix Methode 1 // 
 
 spatwmat, name(W) xcoord($xcor) ycoord($ycor) band(0 10) standardize eigenval(r)

 * Regression naive
 
reg corrup $xlist
 
 * Spatial diagnostics
 
 spatdiag, weights(W)
 
 * ECONOMETRIC MODEL ESTIMATION: 2SLS 
 
predict Hat_corrup
  
ivreg ParticipationPolitica Educ civic_eng (corrup= Hat_corrup) 

predict ivresid, res 
est store IVREG

reg ParticipationPolitica Educ civic_eng corrup Minority Migration lg_GDP_cap
est store OLS

hausman IVREG OLS, constant sigmamore // si rejet h(0) alors on prefere 2sls au OLS 

estimates table IVREG OLS, star (0.1 0.05 0.01)stat(N)

 
// MAPS // 

cd "C:\Users\judos\Google Drive\MASTER 2. ESDP\S2\Spatial Econometrics\Group\BD spatial\SHAPE\SUDAMERICA_ADM2"

shp2dta using sudamerica_adm2.shp, database(databd_comp) coordinates(databd_coord) replace gencentroids(center) genid (id) 

clear all
set more off
use "databd_c_vf"

spmap using "databd_c_vf", id(id) 
point(data("databd_coord.dta") xcoord(Longitud) ycoord(Latitud) ocolor(black) fcolor(red)) ///
label(data("databd_c_vf") label(NOM) xcoord(x_center) ycoord(y_center)) ///
title("Level of Corruption") 
graph export "corruption.png", replace

 
// Code javascript spatial matrix // 

/*

La distance à été calculé avec la formule de Haversine :

R = rayon de la Terre

Δlat = lat2− lat1

Δlong = long2− long1

a = sin²(Δlat/2) + cos(lat1) · cos(lat2) · sin²(Δlong/2)

c = 2 · atan2(√a, √(1−a))

d = R · c

Afin de faciliter ce calcul pour tous les paramètres en question, le code suivant à été écrit en le langage de programation Javascript et il est composé des trois fonctions : 
- function degreesToRadians(degrees) {
  return degrees * Math.PI / 180;
}
Elle permet tout simplement de transformes les degrés donnés par la longitude et la latitude en radians. 

- function distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
  var earthRadiusKm = 6371;

  var dLat = degreesToRadians(lat2-lat1);
  var dLon = degreesToRadians(lon2-lon1);

  lat1 = degreesToRadians(lat1);
  lat2 = degreesToRadians(lat2);

  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  return earthRadiusKm * c;
}

Cette fonction décrit la formule d'Haversine mentionnée précédemment. Elle retourne la distance étant données  une longitude et une latitude.

- function getDistances(origins, destinations){
  const distances = [];
  let distancesRow = [];
  for (o of origins){
    for(d of destinations){
      const distance = distanceInKmBetweenEarthCoordinates(o.lon, o.lat, d.lon, d.lat);
      distancesRow.push(distance);
    }
    distances.push([...distancesRow]);
    distancesRow = [];
  }
  return distances;
}

Et finalement, cette fonction  permet de calculer la matrice des distances en passant la liste des coordonnées de départ et la liste des coordonnées d'arrivée.
 
 */
