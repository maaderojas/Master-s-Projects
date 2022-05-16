
gen produccion=aãoproduccion 
gen cantidad=cantidadproducciãn
drop  aãoproduccion cantidadproducciãn
keep if tipocontraprestacion=="REGALIA"

//choix mineraux 

// carbon, cobre, esmeraldas, hierro, niquel, oro, plata, platino, grava y arcilla 
replace recursonatural="ARCILLA" if recursonatural=="ARCILLA"|recursonatural=="ARCILLAS"|recursonatural=="ARCILLAS BENTONITICA"|recursonatural=="ARCILLAS CAOLINITICA"|recursonatural=="ARCILLAS CERAMICAS"|recursonatural=="ARCILLAS FERRUGINOSAS"|recursonatural=="ARCILLAS MISCELANEAS"|recursonatural=="ARCILLAS REFRACTARIAS"
keep if recursonatural=="NIQUEL"| recursonatural=="CARBON" | recursonatural=="COBRE"|recursonatural=="GRAVAS"|recursonatural=="HIERRO"|recursonatural=="ORO"|recursonatural=="PLATA"|recursonatural=="PLATINO"| recursonatural=="ARCILLA"

//choix departement 
keep if departamento=="Amazonas"| departamento=="Antioquia"|departamento=="Arauca"|departamento=="Atlantico"|departamento=="Bogota, D.C."|departamento=="Bolivar"|departamento=="Boyaca"|departamento=="Caldas"|departamento=="Cauca"|departamento=="Cesar"|departamento=="Cordoba"|departamento=="Cundinamarca"|departamento=="Huila"|departamento=="Magdalena"|departamento=="Meta"|departamento=="NariÃ±o"|departamento=="Norte de Santander"|departamento=="Risaralda"|departamento=="Santander"|departamento=="Tolima"|departamento=="Valle del Cauca"

//Passage a mesure annuelle 
//Choix année de production 
keep if produccion==2018 
collapse (sum) valorcontraprestacion, by(departamento)
