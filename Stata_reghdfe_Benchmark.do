// RegHDFE by Sérgio Correia::Benchmark -- http://scorreia.com/software/reghdfe/
// Adapted from Stata reghdfe help file
// MPortela, June 2022

clear all
set more off
set rmsg on

cd /Users/miguelportela/Documents/GitHub/HDFE

capture log close
log using HDFE_Benchmark.txt, text replace

/*

-- http://scorreia.com/software/reghdfe/

	* Install ftools (remove program if it existed previously)
	cap ado uninstall ftools
	net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

	* Install reghdfe 6.x
	cap ado uninstall reghdfe
	net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

	* Install parallel, if using the parallel() option; don't install from SSC
	cap ado uninstall parallel
	net install parallel, from(https://raw.github.com/gvegayon/parallel/stable/) replace
	mata mata mlib index

	cap ado uninstall ivreghdfe
	cap ssc install ivreg2 // Install ivreg2, the core package
	net install ivreghdfe, from(https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/)

*/



/*
webuse nlswork
	save nlswork, replace
*/

use nlswork, clear
	des
	sort idcode year
	xtset idcode year
	xtdes
	xtsum

	// -- DEFINE A COMMON SAMPLE
	
	egen nmiss = rowmiss(ln_wage ttl_exp union not_smsa nev_mar occ_code south idcode year)
		tab nmiss
			keep if nmiss == 0
			drop nmiss
	
	keep ln_wage ttl_exp union not_smsa nev_mar occ_code south idcode year
	compress
	order idcode year
	sort idcode year
	xtset idcode year
	save nlswork_regression, replace

// -- START -- //
	timer on 1
	
**# 1. Simple case - one fixed effect

	xtreg ln_wage ttl_exp union not_smsa nev_mar, fe

	reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode)
		est store HDFE1


**# 2. As above, but also compute clustered standard errors

	reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode) vce(cluster south)
		est store HDFE1cluster


**# 3. Two and three sets of fixed effects

	reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode year)
		est store HDFE2

	reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode year occ_code)
		est store HDFE3


**# 4. Advanced examples

**# 4.1 Save the FEs as variables

	reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(FE1=idcode FE2=year)
		est store HDFE4


**# 4.2 Interactions in the absorbed variables (notice that only the # symbol is allowed)

	reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode#occ)
		est store HDFE5


**# 5. Parallel computation

**# 5.1 Using the parallel option in reghdfe

	// reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode#occ) parallel // -- DOES NOT WORK ON A MAC M1


**# 5.2 Using the parallel command

**# 5.2.1 Setup

/*
	net install parallel, from(https://raw.github.com/gvegayon/parallel/master/) replace
	mata mata mlib index
*/


**# 5.2.2 Initialize

	parallel initialize 4

**# 5.2.3 Estimation with bootstrap

	parallel bs: reghdfe ln_wage ttl_exp union not_smsa nev_mar, absorb(idcode#occ)
	est store HDFEbs


**# 6. Output Table

**# 6.1 Exporting to a Tex file

	esttab HDFE1 HDFE1cluster HDFE2 HDFE3 HDFE4 HDFE5 using regression_analysis.tex, replace ///
				drop(_cons) ///
				mtitle("Model (1)" "Model (2)" "Model (3)" "Model (4)" "Model (5)" "Model (6)" "Model (7)") nonumbers ///
				coeflabel (ttl_exp "Experience" union "Union" not_smsa "Not SMSA" nev_mar "Never married") ///
				b(%5.4f) se(%6.5f) sfmt(%7.2f) star(* 0.1 ** 0.05 *** 0.01) ///
				scalars("N Observations" "r2 R$^2$" "rss RSS") ///
				nonotes addnotes("Notes: standard errors in parenthesis. Significance levels: *, 10\%; **, 5\%; ***, 1\%. The dependent variable is" "log wage. SMSA: standard metropolitan statistical area. Model (7) is estimated by bootstrap. Source: own computations.")


**# 6.2 Print in Stata Results

		esttab HDFE1 HDFE1cluster HDFE2 HDFE3 HDFE4 HDFE5 HDFEbs, ///
				drop(_cons) ///
				mtitle("Model (1)" "Model (2)" "Model (3)" "Model (4)" "Model (5)" "Model (6)" "Model (7)") nonumbers ///
				coeflabel (ttl_exp "Experience" union "Union" not_smsa "Not SMSA" nev_mar "Never married") ///
				b(%5.4f) se(%6.5f) sfmt(%7.2f) star(* 0.1 ** 0.05 *** 0.01) ///
				scalars("N Observations" "r2 R$^2$" "rss RSS") ///
				nonotes addnotes("Notes: standard errors in parenthesis. Significance levels: *, 10\%; **, 5\%; ***, 1\%. The dependent variable is" "log wage. SMSA: standard metropolitan statistical area. Model (7) is estimated by bootstrap. Source: own computations.")


**# 7. Group Examples

**# 7.1 Setup
	//webuse toy-patents-long, clear
	
	use toy-patents-long, clear
		order inventor_id patent_id year
		sort inventor_id patent_id year

	// ssc install moremata

**# 7.2 Individual (inventor) & group (patent) fixed effects
	
	reghdfe citations funding, a(inventor_id) group(patent_id) individual(inventor_id)


**# 7.3 Individual & group fixed effects, with an additional standard fixed effects variable

	reghdfe citations funding, a(year inventor_id) group(patent_id) individual(inventor_id)


**# 7.4 Individual & group fixed effects, specifying with a different method of aggregation (sum)

	reghdfe citations funding, a(inventor_id) group(patent_id) individual(inventor_id) aggreg(sum)


**# -- If theory suggests that the effect of multiple authors will enter additively, as opposed to the average effect of the group of authors, this would be the appropriate treatment.  Mean is the default method.

**# 7.5 Use one observation per group

	reghdfe citations funding, a(year) group(patent_id)


// -- END -- //

	timer off 1
	timer list 1
	di _new(1) "MINUTES: " %9.2f r(t1)/60

log close
