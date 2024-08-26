***/////////////////////////////////////////////////////////////////////***********
*****MODELO A: CLIMA DE INVERSION Y CRECIMIENTO DE LAS EMPRESAS ES 2010********************
*****///////////////////////////////////////////////////////////////////***********

/*

Objetivo del dofile:       Crear los promedios de celda del CI por sector-tamaño
Investigación:             Explorando los efectos heterogéneos del clima de inversión en el empleo y la productividad en Nicaragua
Base de datos:             Enterprise Survey 2010 NIC
Autor del dofile:          Gabriela Judith López Gutiérrez
Fecha de creación:         2017
Fecha de modificación:     Junio - 2024

*/*Indice ES 2010**********************************************************************/*
/*

0. PREPARACIÓN: Preparación de la base y espacio de trabajo
1. LIMPIEZA: Transformación de variables (asignación de códigos ISIC)
2. GENERACIÓN: Generación de variable dependiente y variables de control
3. PROMEDIOS CI: Creación de los promedios sector-tamaño para el CI iniciales y finales
4. LABELING: Asignar nombres a las variables a utilizar

*//////////////////////////////////////////////////////////////////////////////*
///////0. PREPARACIÓN: Preparación de la base y espacio de trabajo***/////////*/
////////////////////////////////////////////////////////////////////////////////*

cd "C:\Users\Hp\OneDrive\Escritorio\Investigacion efectos CI e informalidad\Datos\Enterprise Survey 2010 NIC"
use "Nicaragua-2010-full-data-.dta", clear
numlabel, add

//////////////////////////////////////////////////////////////////////////////*/
/////1. LIMPIEZA: Transformación de variables (asignación de códigos ISIC)***/////*/
///////////////////////////////////////////////////////////////////////////////

**No es necesario en el caso de la ES 2010, ya los codigos ISIC estaban asignados*

//////////////////////////////////////////////////////////////////////////////*/
/////2. GENERACIÓN: Generación de variable dependiente y variables de control*****/////*/***
///////////////////////////////////////////////////////////////////////////////

***GENERANDO CREACION DE EMPLEO*******************************************************
describe l1
describe l2 
gen average=(l1+l2)/2 
replace average=l1 if l2==-7 | l2==-9 
replace average=l2 if l1==-7 | l1==-9 
replace average=b6 if l1==-7 & l2==-7 | l1==-9 & l2==-9 | l1==-7 & l2==-9 | l1==-9 & l2==-7
replace average=. if average<0 

****ALTERNATIVO: CREACIÓN***********************************************************************
replace l1=. if l1==-7 | l1==-9 
replace l2=. if l2==-7 | l2==-9
gen dif2=cond(missing(l1,l2), min(l1,l2), l1-l2)
gen l_growth=dif2/average

***cambio entre periodo actual y año de nacimiento***
gen dif3=cond(missing(l1,b6), min(l1,b6), l1-b6)
gen dif4=dif2
replace dif4=dif3 if dif4==0

gen average2=(l1+b6)/2
gen average3=average
replace average3=average2 if dif2==0

gen l_growth_nonzero=dif4/average3

***cambio entre periodo anterior y año de nacimiento***
replace b6=. if b6==-9
gen dif5=cond(missing(l2,b6),min(l2,b6),l2-b6)
replace dif5=dif2 if b6==.

***dirección de cambio entre periodo actual y periodo anterior***
gen size_change2=0
replace size_change2=1 if dif2>=1
replace size_change2=2 if dif2<0
label define direction 1"creación de empleo" 2"destrucción de empleo" 0"sin cambio", modify
label values size_change2 direction

***dirección de cambio priorizando cambio entre periodo actual y periodo anterior y remplazando cuando no exista***
gen size_change3=0
replace size_change3=1 if dif4>=1
replace size_change3=2 if dif4<0
label values size_change3 direction

***dirección de cambio entre periodo anterior y año de inicio***
gen size_change4=0
replace size_change4=1 if dif5>=1
replace size_change4=2 if dif5<0
label values size_change4 direction


**////*****VARIABLES DE CONTROL: CARACTERISTICAS DE LA EMPRESA*****************///////
***////////////////////////////////////////////////////////////////****///////////////
***ANTIGUEDAD DE LA FIRMA*************************************************************
gen age=a14y-b5
replace age=. if b5==-9 
gen firm_age1=0
replace firm_age1=1 if age<=5
replace firm_age1=2 if age>=6 & age<=15
replace firm_age1=3 if age>15
label define age1 1"Young(3-5)" 2"Mature(6-15)" 3"Old(>15)"
label values firm_age1 age1

gen firm_age2=. 
replace firm_age2=1 if age<=2
replace firm_age2=2 if age>=3 & age<=5
replace firm_age2=3 if age>=6 & age
replace firm_age2=4 if age>15
label define age2 1"New(1-2)" 2"Young(3-5)" 3"Mature(6-15)" 4"Old(>15)"
label values firm_age2 age2

***DIFERENCIANDO MICRO Y PEQUEÑA (TAMAÑO INICIAL t-3)*****************************************
gen firm_size=.
replace l2=b6 if l2==. | l2==-7 | l2==-9 
drop if l2==-9 | l2==-7 | l2==.
replace firm_size=1 if l2<=5 
replace firm_size=2 if l2>5 & l2<=19
replace firm_size=3 if l2>=20 & l2<=99
replace firm_size=4 if l2>=100
label define size 1"Micro <=5" 2"Small >5 and <=19" 3"Medium >=20 and <=99" 4"Large >=100", replace
label values firm_size size


***TAMAÑO PROMEDIO************************************************************************
gen avg_firm_size=.
replace avg_firm_size=(l2+l1)/2
gen clas_avg_size=1 if avg_firm_size<=5
replace clas_avg_size=2 if avg_firm_size>5 & avg_firm_size<=19.9
replace clas_avg_size=3 if avg_firm_size>=20 & avg_firm_size<=99
replace clas_avg_size=4 if avg_firm_size>=100
label values clas_avg_size size


***TAMAÑO FINAL (t)***************************************************************************
gen firm_size_final=.
replace l1=l2 if l1==. | l1==-7 | l1==-9 
replace l1=b6 if l1==. | l1==-7 | l1==-9 
drop if l1==-9 | l1==-7 | l1==.
replace firm_size_final=1 if l1<=5 
replace firm_size_final=2 if l1>5 & l1<=19
replace firm_size_final=3 if l1>=20 & l1<=99
replace firm_size_final=4 if l1>=100
label define size 1"Micro <=5" 2"Small >5 and <=19" 3"Medium >=20 and <=99" 4"Large >=100", replace
label values firm_size_final size

***PROPIEDAD EXTRANJERO Y PROPIEDAD GOBIERNO, TIPO DE ESTABLECIMIENTO*********************
gen foreign=(b2b>=50)
label define foreign 0"No" 1"Yes"
label values foreign foreign
replace foreign=. if b2b==-9
gen government=(b2c>=50)
label values government foreign
replace government=. if b2c==-9
gen single_est=(a7==1)
label values single_est foreign
replace single_est=. if a7==-9
gen exporter=(d3b>=10 | d3c>=10)
label values exporter foreign
replace exporter=. if d3b==-9 | d3c==-9
gen manufacturing=(a0==1)
label values manufacturing foreign
gen small_city=(a3==5 & a2!=1)
label values small_city foreign

***Cambio de categoria entre periodo anterior y periodo actual***********************************************
gen size_change = .
replace size_change = 1 if firm_size_final > firm_size   
replace size_change = -1 if firm_size_final < firm_size  
replace size_change = 0 if firm_size_final == firm_size 
label values size_change direction


*** table firm_size firm_size_final, row col **
*** tab size_change***

//////////////////////////////////////////////////////////////////////////////*///////*/
/////3. PROMEDIOS CI: Creación de los promedios sector-tamaño para el CI utilizando tamaño inicial y final///
//////////////////////////////////////////////////////////////////////////////////////

****antes: utiliza a6a en vez de firm_size**************************************
sort a4b a6a
egen N_secsize=count(id), by(a4b firm_size)
egen N_secsize2=count(id), by(a4b firm_size_final)


********************************************************************************
***IRA DIMENSIÓN: ACCESO A FINANZAS INICIAL*********************************************
********************************************************************************
foreach v of varlist k3bc k3e k5bc k5e {
 replace `v'=. if `v'==-9 | `v'==-7
 egen fin_tot`v'= total(`v'), by(a4b firm_size)
 }
foreach v of varlist  k3bc k3e k5bc k5e {
 gen fin_totmin`v'=fin_tot`v'-cond(missing(`v'),0,`v')
 }
 foreach v of varlist  k3bc k3e k5bc k5e {
 gen fin_mean`v'=fin_totmin`v'/(N_secsize-!missing(`v'))
 }
gen wk_finext=fin_meank3bc+fin_meank3e
gen wk_invest=fin_meank5bc+fin_meank5e

gen log_wk_finext=log(wk_finext)
gen log_wk_invest=log(wk_invest)



********************************************************************************
***IRA DIMENSIÓN: ACCESO A FINANZAS FINAL*********************************************
********************************************************************************
foreach v of varlist k3bc k3e k5bc k5e {
 replace `v'=. if `v'==-9 | `v'==-7
 egen final_fin_tot`v'= total(`v'), by(a4b firm_size_final)
 }
foreach v of varlist  k3bc k3e k5bc k5e {
 gen final_fin_totmin`v'=final_fin_tot`v'-cond(missing(`v'),0,`v')
 }
 foreach v of varlist  k3bc k3e k5bc k5e {
 gen final_fin_mean`v'=final_fin_totmin`v'/(N_secsize2-!missing(`v'))
 }
gen final_wk_finext=final_fin_meank3bc+final_fin_meank3e
gen final_wk_invest=final_fin_meank5bc+final_fin_meank5e


********************************************************************************
***IIDA DIMENSIÓN: REGULACIONES INICIAL*************************************************
********************************************************************************
 foreach v of varlist j4 j14 j2 j11{
 replace `v'=. if `v'==-9 | `v'==-7 | `v'==-5 | `v'==-6 
 egen reg_tot`v'= total(`v'), by(a4b firm_size)
 }
foreach v of varlist j4 j14 j2 j11{
 gen reg_totmin`v'=reg_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist j4 j14 j2  j11{
 gen reg_mean`v'=reg_totmin`v'/(N_secsize-!missing(`v'))
 }
 foreach v of varlist j4 j14 j2  j11 {
 gen log_reg_mean`v'=log(reg_mean`v')
 }

 
********************************************************************************
***IIDA DIMENSIÓN: REGULACIONES FINAL*************************************************
********************************************************************************
 foreach v of varlist j4 j14 j2 j11{
 replace `v'=. if `v'==-9 | `v'==-7 | `v'==-5 | `v'==-6 
 egen final_reg_tot`v'= total(`v'), by(a4b firm_size_final)
 }
foreach v of varlist j4 j14 j2 j11{
 gen final_reg_totmin`v'=final_reg_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist j4 j14 j2  j11{
 gen final_reg_mean`v'=final_reg_totmin`v'/(N_secsize2-!missing(`v'))
 }
 
 
********************************************************************************
***IIIRA DIMENSIÓN: CORRUPCIÓN INICIAL**************************************************
********************************************************************************
foreach v of varlist j6 j7a{
 replace `v'=. if `v'==-9 | `v'==-7
 egen corru_tot`v'= total(`v'), by(a4b firm_size)
 }
foreach v of varlist j6 j7a{
 gen corru_totmin`v'=corru_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist j6 j7a{
 gen corru_mean`v'=corru_totmin`v'/(N_secsize-!missing(`v'))
 }
 foreach v of varlist j6 j7a {
 gen log_corru_mean`v'=log(corru_mean`v')
 }

 
 ********************************************************************************
***IIIRA DIMENSIÓN: CORRUPCIÓN FINAL**************************************************
********************************************************************************
foreach v of varlist j6 j7a{
 replace `v'=. if `v'==-9 | `v'==-7
 egen final_corru_tot`v'= total(`v'), by(a4b firm_size_final)
 }
foreach v of varlist j6 j7a{
 gen final_corru_totmin`v'=final_corru_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist j6 j7a{
 gen final_corru_mean`v'=final_corru_totmin`v'/(N_secsize2-!missing(`v'))
 }
 foreach v of varlist j6 j7a {
 gen log_corru_mean`v'=log(corru_mean`v')
 }
 
********************************************************************************
***IVTA DIMENSIÓN: INFRAESTRUCTURA INICIAL**********************************************
********************************************************************************
 foreach v of varlist c7 c9a  d11 {
 replace `v'=. if `v'==-9 | `v'==-7
 egen inf_tot`v'= total(`v'), by(a4b firm_size)
 }
foreach v of varlist c7 c9a  d11 {
 gen inf_totmin`v'=inf_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist c7 c9a  d11 {
 gen inf_mean`v'=inf_totmin`v'/(N_secsize-!missing(`v'))
 }
  foreach v of varlist c7 c9a d11 {
 gen log_inf_mean`v'=log(inf_mean`v')
 }
 
 ********************************************************************************
***IVTA DIMENSIÓN: INFRAESTRUCTURA FINAL**********************************************
********************************************************************************
 foreach v of varlist c7 c9a d11{
 replace `v'=. if `v'==-9 | `v'==-7
 egen final_inf_tot`v'= total(`v'), by(a4b firm_size_final)
 }
foreach v of varlist c7 c9a d11 {
 gen final_inf_totmin`v'=final_inf_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist c7 c9a d11{
 gen final_inf_mean`v'=final_inf_totmin`v'/(N_secsize2-!missing(`v'))
 }

 
********************************************************************************
***VTA DIMENSIÓN: LABOR INICIAL*************************************************
********************************************************************************
gen n2a_sq=n2a*n2a 
 foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e{
 replace `v'=. if `v'==-9 | `v'==-7
 egen labor_tot`v'= total(`v'), by(a4b firm_size)
 }
foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e {
 gen labor_totmin`v'=labor_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e {
 gen labor_mean`v'=labor_totmin`v'/(N_secsize-!missing(`v'))
 }
  foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e {
 gen log_labor_mean`v'=log(labor_mean`v')
 }
 
 ********************************************************************************
***VTA DIMENSIÓN: LABOR FINAL*************************************************
********************************************************************************
gen n2a_sq=n2a*n2a 
 foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e{
 replace `v'=. if `v'==-9 | `v'==-7
 egen final_labor_tot`v'= total(`v'), by(a4b firm_size_final)
 }
foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e {
 gen final_labor_totmin`v'=labor_tot`v'-cond(missing(`v'),0,`v')
 }
foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e {
 gen final_labor_mean`v'=labor_totmin`v'/(N_secsize-!missing(`v'))
 }
  foreach v of varlist n2a n2a_sq LACl10b LACl10d LACl10e {
 gen final_log_labor_mean`v'=log(labor_mean`v')
 }
 
                                           
********************************************************************************
***VARIABLES ADICIONALES DE FINANCIAMIENTO Y PAGOS INFORMALES: INICIAL**********
********************************************************************************						   
										   
foreach c of varlist k7 j5 {
 replace `c'=. if `c'==-9 | `c'==-7 | `c'==-8 
 bys a4b firm_size: gen byte iss_count`c'=inlist(`c',1)
 bys a4b firm_size: egen totss_count`c'=sum(iss_count`c')
 bys a4b firm_size: gen minss_count`c'=totss_count`c'-iss_count`c'
 }
foreach c of varlist k7 j5 {
 bys a4b firm_size: gen pss_count`c'=(minss_count`c'/(N_secsize-!missing(`c')))*100
 }
 
*******************************************************************************
***VARIABLES ADICIONALES DE FINANCIAMIENTO Y PAGOS INFORMALES: FINAL************
********************************************************************************		
 foreach c of varlist k7 j5 {
 replace `c'=. if `c'==-9 | `c'==-7 | `c'==-8 
 bys a4b firm_size_final: gen byte final_iss_count`c'=inlist(`c',1)
 bys a4b firm_size_final: egen final_totss_count`c'=sum(final_iss_count`c')
 bys a4b firm_size_final: gen final_minss_count`c'=final_totss_count`c'-final_iss_count`c'
 }
foreach c of varlist k7 j5 {
 bys a4b firm_size_final: gen final_pss_count`c'=(final_minss_count`c'/(N_secsize2-!missing(`c')))*100
 }
 
 
********************************************************************************
***VARIABLES ADICIONALES DE DIMENSION LABOR*************************************
********************************************************************************
 
 foreach c of varlist LACl10a LACl10c {
 replace `c'=. if `c'==-9 | `c'==-7 | `c'==-8 
 bys a4b firm_size: gen byte lab_iss_count`c'=inlist(`c',1)
 bys a4b firm_size: egen lab_totss_count`c'=sum(lab_iss_count`c')
 bys a4b firm_size: gen lab_minss_count`c'=lab_totss_count`c'-lab_iss_count`c'
 }
foreach c of varlist LACl10a LACl10c {
 bys a4b firm_size: gen lab_pss_count`c'=(lab_minss_count`c'/(N_secsize-!missing(`c')))*100
 }
 
//////////////////////////////////////////////////////////////////////////////*
///////5. LABELING: Asignar nombres a las variables a utilizar***/////////*////
////////////////////////////////////////////////////////////////////////////////*
 
note: k7= At This Time, Does This Establishment Have An Overdraft Facility? ///
note: k8=  Establishment has A Line Of Credit Or Loan From A Financial Institution? ///
note: j5= In Any Of These Inspections Was A Gift/Informal payment Requested ? ///
note: c6= Over last FY, Did This Establishment Experience Power Outages? ///
note: e1= Does This Establishment Compete Against Unregistered Or Informal Firms ///

label var pss_countk7 "Est. has an overdraft facility"
label var wk_finext "Sh of working capital financed externally"
label var wk_invest "Sh of investment financed externally"
 
label var reg_meanj14 "Operating license (days)"
label var reg_meanj2 "Managemente time"
label var reg_meanj11 "Import locense (days)"
 
label var pss_countj5 "Informal gift required" 
label var corru_meanj6 "Gift to gvm (% of contract value)"
label var corru_meanj7a "Percentage of sales used for gifts"
 
label var inf_meanc7  "Number of power outages in a month" 
label var inf_meanc9a "Average of Losses in Last Fiscal Yr (% Of Sales) Due to Power Outages"
 
save "Microdatos ES 2010 Modificada", replace
 
