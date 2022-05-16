//Import Spatial Matrix 
ename a CityName
label variable CityName "City"
encode (CityName),gen(IdCity) // genera codigo num por ciudades 
drop CityName
global cities //poner nombre de las ciudades como vectores

//
 global xcor xcoordinate  // cordenadas latitudes 
 global ycor ycoordinate //cordenadas longitudes 
 global band 85 // distancia threshold so everyone has a neighbour 
 global $corrup indexcorruption // var expliqué 
 global $xlist  var explicative // variables explicatives 
 
 //spatial matrix Methode 1 
 spatwmat, name(W) xcoord($xcor) ycoord($ycor) band(0 $band) standardize eigenval(r)
 
 //ou Methode 2 
 
 spmat idistance DistMat $xcoord $ycoord, id(IdCity) norm(row) 
 
 
 //Do regular OLS Estimation and multicolinarity estimations, omitted variables 
 pwcorr 
 reg
 ovtest //omitted variables 
 vif //multicolinearity 
 estat hettest//test homoscedasticity  Breusch-Pagan 
 
 //test on distibution of residuals 
 predict r, resid
 kdensity r, normal 
 swilk r //h(0) r suit une loi normale 
 
 //Spatial Diagnostic 
 spatdiag, weights(W) //or spatdiag, wieghts(DistMat) tests whether data analyzed via OLS regression exhibits spatial correlatiom
 // this commands shows the results of Moran's I test, Lagrange Multiplier and Robust Lagrange Multiplier 
 //if p-value <0.05 then we need a spatial model 

 
 * Spatial Error Model with spatial matrix method 1 
 spatreg $corrup $xlist, weights(W) eigenval(r) model(error) //look for lamda to interpret coefficien for spatial dependance to justify the model
 estimates store SEM 
 *Spatial  Lag Model with spatial matrix method 1 
 spatreg $corrup $xlist, weights(W) eigenval(r) model(lag) //look rho the spatial lag coefficient to justify the model 
 estimates store SLM 
 estimates tab SEM SLM 
 
 //AFTER CHOOSING THE BEST MODEL RE DO THE REGRESSION AND ...
 predict Hat_Corrupt 
 
 //If boths models are ok just do two ivregs one with the estimated corruption with SEM and the other with SLM 
 predict Hat_Corrupt_SEM
 predict Hat_Corrupt_SLM 
 
 //2SLS 
 
ivreg politicalparticipation $xlist (corrup= Hat_Corrupt) // 2sls $xlist enxogenous variables (educ, civic engagement) entre parentesis IV 
predict ivresid, res 
est store IVREG
reg politicalparticipation $betalist //beta list are xlist variables + variable corrup not estimated by the spatial model 
est store OLS
hausman ivreg ., constant sigmamore // si rejet h(0) alors on prefere 2sls au OLS 


 

 
 
 

