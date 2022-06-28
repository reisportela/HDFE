estimates clear
use fakedata, clear
sum
list in 1/10

qui regress y x1 x2 i.i
estimates store reg_1
qui areg y x1 x2, absorb(i)
estimates store areg_1
qui xtset i
qui xtreg y x1 x2, fe
estimates store xtreg_1


which reghdfe
qui reghdfe y x1 x2 i.i
estimates store reghdfe_1a
qui reghdfe y x1 x2, absorb(i)
estimates store reghdfe_1b

estimates table *_1 reghdfe_1a reghdfe_1b, keep(x1 x2) b(%7.4f) se(%7.4f) stats(N r2 r2_a)

qui regress y x1 x2 i.i, vce(robust)
estimates store reg_2a
qui areg y x1 x2, absorb(i) vce(robust)
estimates store areg_2a
qui xtreg y x1 x2, fe vce(robust) 
estimates store xtreg_2a
qui reghdfe y x1 x2, absorb(i) vce(robust) 
estimates store reghdfe_2a
estimates table *_2a, keep(x1 x2) b(%7.4f) se(%7.4f) stats(N)

qui regress y x1 x2 i.i, vce(cluster i)
estimates store reg_2b
qui areg y x1 x2, absorb(i)  vce(cluster i)
estimates store areg_2b
qui xtreg y x1 x2, fe vce(cluster i) 
estimates store xtreg_2b
qui reghdfe y x1 x2, absorb(i)  vce(cluster i) 
estimates store reghdfe_2b
qui reghdfe y x1 x2, absorb(i)  vce(cluster i) keepsingletons 
estimates store reghdfe_2ba

estimates table *_2b *_2ba, keep(x1 x2) b(%7.4f) se(%7.4f) stats(N)

qui regress y x1 x2 i.i, vce(cluster j)
estimates store reg_2c
qui areg y x1 x2, absorb(i)  vce(cluster j)
estimates store areg_2c
*qui xtreg y x1 x2, fe vce(cluster j) 
*estimates store xtreg_2c
qui reghdfe y x1 x2, absorb(i)  vce(cluster j) 
estimates store reghdfe_2c
qui reghdfe y x1 x2, absorb(i)  vce(cluster j) keepsingletons 
estimates store reghdfe_2ca

estimates table *_2c *_2ca, keep(x1 x2) b(%7.4f) se(%7.4f) stats(N)

clear all
use data1fe

qui xtreg ln_wage age tenure i.year, fe
estimates store xtreg_3a
qui areg ln_wage age tenure i.year, absorb(idcode)
estimates store areg_3a
qui xtreg ln_wage age tenure ib(69).year, fe
estimates store xtreg_3b
qui areg ln_wage age tenure ib(69).year, absorb(idcode)
estimates store areg_3b
qui reghdfe ln_wage age tenure, absorb(idcode year)
estimates store reghdfe_3c
estimates table *_3a *_3b *_3c, keep(age tenure) b(%7.4f) se(%7.4f) stats(N)


clear all
use nlswork

qui reghdfe ln_wage ttl_exp union not_smsa nev_mar i.year, absorb(idcode)
estimates store reghdfe_4a
qui reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode year)
estimates store reghdfe_4b
estimates table *_4a *_4b, keep(ttl_exp union not_smsa nev_mar) b(%7.4f) se(%7.4f) stats(N)

reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode year occ_code)

reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(fe1=idcode fe2=year fe3=occ_code)
reghdfe ln_wage ttl_exp union not_smsa nev_mar fe1 fe2 fe3

reghdfe ln_wage union not_smsa nev_mar, absorb(idcode i.year##c.ttl_exp)

reghdfe ln_wage union not_smsa nev_mar, absorb(i.idcode##c.ttl_exp year)
