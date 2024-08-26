***/////////////////////////////////////////////////////////////////////***********
*****MODELO A: CLIMA DE INVERSION Y CRECIMIENTO DE LAS EMPRESAS ES 2010************
*****///////////////////////////////////////////////////////////////////***********

/*

Objetivo del dofile:       Estimar Modelo B: Efectos heterogeneos del CI según caracteristicas de las empresas
Investigación:             Explorando los efectos heterogéneos del clima de inversión en el empleo y la productividad en Nicaragua
Base de datos:             Enterprise Survey 2010 NIC
Autor del dofile:          Gabriela Judith López Gutiérrez
Fecha de creación:         2017
Fecha de modificación:     Junio - 2024

*//////////////////////////////////////////////////////////////////////////////*
///////0. PREPARACIÓN: Preparación de la base y espacio de trabajo***/////////*/
////////////////////////////////////////////////////////////////////////////////

cd "C:\Users\Hp\OneDrive\Escritorio\Investigacion efectos CI e informalidad\Datos\Enterprise Survey 2010 NIC"
use "Microdatos ES 2010 Modificada", clear
numlabel, add

/////////////////////////////////////////////////////////////////////////////*//
///////1.ESTIMACIÓN: Estimación de modelos (modelo de efectos heterogeneos)**///
////////////////////////////////////////////////////////////////////////////////*

reg l_growth i.firm_age1 i.firm_size i.foreign i.single_est i.government i.exporter i.female_manager b7 i.small_city wk_* reg_meanj14 reg_meanj2 reg_meanj11 corru_m* inf_m* pss_c* i.firm_size#c.wk_* i.firm_size#c.reg_meanj14 i.firm_size#c.reg_meanj2 i.firm_size#c.corru_m* i.firm_size#c.inf_m* i.firm_size#c.pss_count* i.a2 , robust
estat ovtest
predict estimates1
predict resid1, residuals
scatter resid1 estimates1
estat imtest,white

/////////////////////////////////////////////////////////////////////////////*//
///////2.ESTIMACIÓN MEDIDAS ALTERNATIVAS: Estimación de modelos (modelo de efectos heterogeneos)**///
////////////////////////////////////////////////////////////////////////////////*

replace d2=. if d2==-9 | d2==-7
replace n2e=. if n2e==-9 | n2e==-7
gen VA=d2-n2e
gen log_ValueAdd=ln(VA/l1)

replace l6=. if l6==-9 | l6==-7
replace l8=. if l8==-9 | l8==-7
gen temp_workers=l6*(l8/12)
replace temp_workers=0 if temp_workers==.
gen tot_workers=l1+temp_workers
gen log_produc=ln(d2/tot_workers)

***Alternativos***

reg log_ValueAdd i.firm_age1 i.firm_size i.foreign i.single_est i.government i.exporter i.female_manager b7 i.small_city wk_* reg_meanj14 reg_meanj2 reg_meanj11 corru_m* inf_m* pss_c* i.firm_size#c.wk_* i.firm_size#c.reg_meanj14 i.firm_size#c.reg_meanj2 i.firm_size#c.corru_m* i.firm_size#c.inf_m* i.firm_size#c.pss_count* i.a2 , robust
estat ovtest
estat imtest,white

reg log_produc i.firm_age1 i.firm_size i.foreign i.single_est i.government i.exporter i.female_manager b7 i.small_city wk_* reg_meanj14 reg_meanj2 reg_meanj11 corru_m* inf_m* pss_c* i.firm_size#c.wk_* i.firm_size#c.reg_meanj14 i.firm_size#c.reg_meanj2 i.firm_size#c.corru_m* i.firm_size#c.inf_m* i.firm_size#c.pss_count* i.a2 , robust
estat ovtest
estat imtest,white
