clear all
use citations_raw, clear

%browse

reghdfe citations x
estimates store reg_wide_yx

reghdfe citations x, a(journal)
estimates store reg_wide_yxj

local i=1
foreach au in AutA AutB AutC AutD AutE AutF {
gen aut`i'=regexm(authors,"`au'")
local ++i
}
save citations_wide, replace

%browse

reghdfe citations x aut1-aut6, a(journal)
estimates store reg_wide_yxja

reshape long aut, i(art_id) j(j)
drop if aut==0
drop aut
rename j author_id
drop authors _est*
save citations_long, replace

%browse

reghdfe citations x, group(art_id)
estimates store reg_long_yx

estimates table reg_wide_yx reg_long_yx, keep(x) b(%7.4f) se(%7.4f) stats(N r2_a)

reghdfe citations x, group(art_id) a(journal)
estimates store reg_long_yxj

estimates table reg_wide_yxj reg_long_yxj, keep(x) b(%7.4f) se(%7.4f) stats(N r2_a)

reghdfe citations x, group(art_id) individual(author_id) a(journal_id author_id) aggregation(sum)
estimates store reg_long_yxja

estimates table reg_wide_yxja reg_long_yxja, keep(x) b(%7.4f) se(%7.4f) stats(N r2_a)

reghdfe citations x i.journal_id, group(art_id) individual(author_id) a(author_id) keepsingletons
estimates store reg_long_yxja2
reghdfe citations x, group(art_id) individual(author_id) a(journal_id author_id) keepsingletons
estimates store reg_long_yxja3

use citations_wide, clear

 egen naut=rowtotal(aut1-aut6)

forval j=1/6 {
qui replace aut`j'=aut`j'/naut
}

%browse

reghdfe citations x aut1-aut6, nocons a(journal_id) keepsingletons
estimates store reg_wide_yxja2

estimates table reg_wide_yxja2 reg_long_yxja2 reg_long_yxja3, keep(x) b(%7.4f) se(%7.4f) stats(N r2_a)
