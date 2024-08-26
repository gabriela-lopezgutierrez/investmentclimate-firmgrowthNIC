***/////////////////////////////////////////////////////////////////////***********
*****MODELO A: CLIMA DE INVERSION Y CRECIMIENTO DE LAS EMPRESAS ES 2010************
*****///////////////////////////////////////////////////////////////////***********

/*

Objetivo del dofile:       Estimar Modelo A: Clima de inversión según características de la empresa y patron de crecimiento
Investigación:             Explorando los efectos heterogéneos del clima de inversión en el empleo y la productividad en Nicaragua
Base de datos:             Enterprise Survey 2010 NIC
Autor del dofile:          Gabriela Judith López Gutiérrez
Fecha de creación:         2017
Fecha de modificación:     Junio - 2024

*//////////////////////////////////////////////////////////////////////////////*
///////0. PREPARACIÓN: Preparación de la base y espacio de trabajo***/////////*/
////////////////////////////////////////////////////////////////////////////////*

cd "C:\Users\Hp\OneDrive\Escritorio\Investigacion efectos CI e informalidad\Datos\Enterprise Survey 2010 NIC"
use "Microdatos ES 2010 Modificada", clear
numlabel, add

*/////////////////////////////////////////////////////////////////////////////*
///////1.ESTIMACIÓN: Condiciones objetivas segun caracteristicas////////////////
////////////////////////////////////////////////////////////////////////////////*

********************************************************************************
***IRA DIMENSIÓN: ACCESO A FINANZAS*********************************************
********************************************************************************

reg final_wk_finext i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

reg final_wk_invest i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

********************************************************************************
***2DA DIMENSIÓN: REGULACIONES**************************************************
********************************************************************************
reg final_reg_meanj14 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_reg_meanj14

gen log_final_reg_meanj14=log( final_reg_meanj14)
reg log_final_reg_meanj14 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

reg final_reg_meanj2 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_reg_meanj2

gen log_final_reg_meanj2=log( final_reg_meanj2)
reg log_final_reg_meanj2 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

reg final_reg_meanj4 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_reg_meanj4

gen log_final_reg_meanj4=log( final_reg_meanj4)
reg log_final_reg_meanj4 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

reg final_reg_meanj11 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_reg_meanj11

gen log_final_reg_meanj11=log( final_reg_meanj11)
reg log_final_reg_meanj11 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

********************************************************************************
***IIIRA DIMENSIÓN: PAGOS INFORMALES********************************************
********************************************************************************

reg final_corru_meanj6 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_corru_meanj6

gen log_final_corru_meanj6=log(final_corru_meanj6)
reg log_final_corru_meanj6 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

reg final_corru_meanj7a i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_corru_meanj7a

gen log_final_corru_meanj7a=log(final_corru_meanj7a)
reg log_final_corru_meanj7a i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

********************************************************************************
***IVTA DIMENSIÓN: INFRAESTRUCTURA**********************************************
********************************************************************************

reg final_inf_meanc7 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_inf_meanc7

gen log_final_inf_meanc7=log(final_inf_meanc7)
reg log_final_inf_meanc7 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

reg final_inf_meanc9a i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_inf_meanc9a

gen log_final_inf_meanc9a=log(final_inf_meanc9a)
reg log_final_inf_meanc9a i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white

reg final_inf_meand11 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
hist final_inf_meand11

gen log_final_inf_meand11=log(final_inf_meand11)
reg log_final_inf_meand11 i.firm_size_final i.firm_age1 i.foreign i.government i.exporter i.small_city i.size_change2, robust
vif
estat ovtest
estat imtest, white
