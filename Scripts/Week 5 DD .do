*Week 5: Natural Experiments and Intro to Diff-in-Diff
*Samuel Rowe
*Econ 645
*August 19, 2023

clear
set more off

********************************************************************************
*Wooldridge
********************************************************************************
* Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

**********
*FE and FD
**********

**********
*Effect of Grants on scrap rates
**********
use "jtrain.dta", clear

* Michigan implemented a job training grant program to reduce scrap rates.
* What is the effect of job training on reducing the scrap rate for firm_i 
* during time period t in terms of number of items scraped per 100 due to
* defects?  

*Set the Panel
sort fcode year
xtset fcode year

* Use FD or FE to take care of unobserved firm effects
reg d.scrap d.grant if year < 1989
xtreg scrap i.grant i.d88 if year < 1989, fe
* The change in grant is basically receiving the grant or not, because grant
* in 1987 is always zero.

**********
*Effect of Drunk Driving Laws on Traffic Fatalities
**********
use "traffic1.dta", clear

* We want to assess open container laws that make it illegal for passengers
* to have open containers of alcoholic beverages and administrative per se
* laws that allow courts to suspend licneses after a driver is arrested for 
* drunk driving but before the driver is convicted.

* The data contains the number of traffic deathts for all 50 states plus D.C.
* in 1985 and 1990. Our dependent variable is number of traffic deaths per 
* 100 million miles driven (dthrte). In 1985, 19 states had open container
* laws, and 22 states had open container laws in 1990. In 1985, 21 states
* had per se laws, which grew to 29 states by 1990. Note that some states had
* both.

* We can use a first difference here. We have two options. Subtract across
* columns, or reshape and set a panel data set.

reg cdthrte copen cadmn

* Open containers laws, assuming the strict exogeniety assumption holds, reduce
* deaths per 100 million miles driven by .42

**********
*Diff-in-Diff
**********
*****
*Effect of a garbage incinerator's location on housing prices
*****
use "kielmc.dta", clear

* Kiel and McClain (1995) studied the effects of garbage incinerator's location
* on housing prices in North Andover, MA. There were rumors of a new incinerator
* in 1978 and construction began in 1981, but did not begin operating until 
* 1985. A house that is within 3 miles of the incinerator is considered close
* All housing prices are in 1978 dollars (rprice) or log of nominal price
* (lprice)

* Naive and biased OLS model only using data from 1981
reg rprice nearinc if y81==1
* Naive and biased OLS model only using data from 1978
reg rprice nearinc if y81==0
* Results in a decrease in housing prices of almost 24.5K

* Diff-in-Diff is easy enough to implement if our data are prepared properly
reg rprice i.nearinc##i.y81

* Our Diff-in-Diff yields a decrease in housing prices of 11.9K

* Let add a sensitivity analysis by adding more variables
eststo m1: reg rprice i.nearinc##i.y81
eststo m2: reg rprice i.nearinc##i.y81 age agesq
eststo m3: reg rprice i.nearinc##i.y81 age agesq intst land area rooms baths

* Our model ranges from a reduction of -11.9K to -21.9K
esttab m1 m2 m3, keep(1.y81 1.nearinc 1.nearinc#1.y81 age agesq ///
                      intst land area rooms baths)

* Let's use elasticities by usig a log-linear model
est clear
eststo m1: reg lprice i.nearinc##i.y81
estimates store mod1
eststo m2: reg lprice i.nearinc##i.y81 age agesq
estimates store mod2
eststo m3: reg lprice i.nearinc##i.y81 age agesq intst land area rooms baths
estimates store mod3

* Our model ranges from a reduction housing prices between 6.1% and 16.9%
esttab m1 m2 m3, keep(1.y81 1.nearinc 1.nearinc#1.y81 age agesq ///
                      intst land area rooms baths)
					  
coefplot (mod1, label(Model 1)) (mod2, label(Model2)) (mod3, label(Model 3)), ///
         keep(1.nearinc#1.y81) xline(0) title("Diff-in-Diff Results")
		 
coefplot mod1, bylabel(Model 1) || mod2, bylabel(Model 2) || ///
         mod3, bylabel(Model 1) || , ///
         keep(1.nearinc#1.y81) xline(0) title("Diff-in-Diff Results")
* More on coefplot
* https://repec.sowi.unibe.ch/stata/coefplot/getting-started.html

***********
*Effect of Worker Compensation Laws on Weeks out of Work
***********
use "injury.dta", clear

* Meyer, Viscusi, and Durbin (1995) studied the length of time that an injured
* worker receives workers' compensation (in weeks). On July 15, 1980 Kentucky 
* raised the cap on weekly earnings that were covered by workers' compensation.
* An increase in the cap should affect high-wage workers and not affect low-wage
* workers, so low-wage workers are our control group and high-wage workers
* are our treatment group.

* Our diff-in-diff - limited to only KY
* The policy increased duration of workers' compensation by 21% to 26%
reg ldurat i.afchnge##i.highearn if ky==1
reg ldurat i.afchnge##i.highearn i.male i.married i.indust i.injtype if ky==1

* A triple DDD a way to test our DD - Placebo test
* We would expect high earners in KY to have an increase in duration but not
* other states.

* Our DD estimate i.afchgne#i.highearn is about the same but not statistically
* significant. Furthermore, our high earners in KY after the policy are not
* affected, so our original DD design might not be rigourous enough.
reg ldurat i.afchnge##i.highearn##i.ky 
reg ldurat i.afchnge##i.highearn##i.ky i.male i.married i.indust i.injtype


***********
*Exercises
**********
* 1)
use "kielmc.dta", clear

* What is a potential problem with using a binary variable (nearinc) 
* a continuous variable (dist)? 

* Estimate log(price)=a + b1*y81 + b2*nearinc + d*y81*nearinc
* Do a sensitivity test using additional covariates. Are the results robust, or
* are they sensitive to the specification?
* Plot the coefficients of the model.

* 2)
use "injury.dta", clear
* Estimate log(durat)=a + b1*afchnge + b2*highearn + d*afchnge*highearn
* Do a sensitivity tests using additional covariates. Are the results robust, or
* are they sensitive to the specification?
* Plot the coefficients of the model.

* 3)
use "traffic1_reshaped.dta", clear
* Set a panel data for the states for 1985 and 1990. 
* You cannot set a panel data set when the unit of analysis is in a string 
* format.
* Don't forget the delta option. Use a first differenced equation.
* Estimate d.thrte=a + b1*d.open + b2*d.admn
* Do you get the same results as above?
* Now try a sensitivity analysis with additional covariates.

********************************************************************************
*Mitchell
********************************************************************************

cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

* Appending and merging datasets are a crucial part of learning Stata. 
* Many times we are merging datasets by State FIPS, year, Zip Codes, Unit ID,
* County FIPS, etc. If we wanted to analyze local-level unemployment data to our
* analysis of county-level crime, then we will likely be using data from BLS
* and data from FBI or other local admin data.

* Note: Working with multiple datasets:
* I do not have frames in Stata 14, but using frames is encouraged. Using
* the temp files workaround is a bit cumbersome (but it works). Using Stata
* frames will help work with those datasets simultaneously to get them ready
* to merge.

**************
*7.2 Appending Datasets
**************

* Let's say we have two datasets with the same variables. We can append these
* files together.
use "moms.dta", clear
list
use "dads.dta", clear
list
* We can append the mom.dta file with append using filename
append using "moms.dta"
list
* Or,
clear
append using "moms.dta" "dads.dta"
list

* What is a clear problem here? After the append, how do we identify which data
* are for dads and for moms. There are two ways. One, we can generate a variable
* in both files and code it. Or, we can use the generate option in the append
clear
append using "moms.dta" "dads.dta", generate(datascreen)
list, sepby(datascreen)
* Since moms.dta is first, the new variable datascreen will set moms.dta 
* datascreen variable = 1, and since dads.dta is second, the datascreen 
* variable = 2.
* You could just generate a variable called parent in both files and set moms
* equal to 1 and dads equal to 0. But, the generate option is nice and concise

* It's a good idea to label the data
label define datascreenl 1 "From moms.dta" 2 "From dads.dta"
label values datascreen datascreenl
list, sepby(datascreen)

* If we use the generate option in append with one file open, the values of
* the generated variable are different
clear
use "moms.dta"
append using "dads.dta", generate(datascreen)
list, sepby(datascreen)
label define datascreenl 0 "From moms.dta" 1 "From dads.dta"
label values datascreen datascreenl
list, sepby(datascreen)

* We can append multiple datafiles together (as long as they have the same
* variables)
dir br*.dta

use "br_clarence.dta", clear
list

clear
append using "br_clarence.dta" "br_isaac" "br_sally", generate(rev)
label define revl 1 "clarence" 2 "isaac" 3 "sally"
label values rev revl
list, sepby(rev)


**************
*7.3 Appending Problems
**************

* We can check the two datasets for potential problems with the precombine
* command. You will need to install this community-user command. We can check
* to see if the components of the datasets are similar to prevent problem: 
* variable types, format, labels, values labels, and number of times the
* variable shows up in the datasets.
search precombine
clear
precombine "moms.dta" "dads.dta", describe(type format varlab vallab ndta) uniquevars
**
*Different variable names
**
* If the same variable intent has two different variable names between the data
* sets, then they will become two different columns when you only want one 
* column of data. 
* For example, when we append moms1 and dads1 which have different variable 
* names for the different variables, the variables do not append correctly.
use "moms1.dta", clear
append using "dads1.dta", generate(datascreen)
list

* It's an easy fix. Just rename the variables to a common variable name and
* append
use "moms1.dta", clear
rename (mage mrace mhs) (age race hs)
save "moms1temp.dta", replace

use "dads1.dta", clear
rename (dage drace dhs) (age race hs)
save "dads1temp.dta", replace

append using "moms1temp.dta" "dads1temp.dta", generate(datascreen)
list


**
*Conflicting variable labels
**
* If we have conflicting variable labels, then the variable labels of the 
* primary dataset will overwrite the appended dataset. The solution is 
* to use a neutral variable label.
* For example, instead of Mom's HS and Dad's HS, just have "high school" as
* the variable label in both datasets

* Solution:
* Use neutral variable label names.

use "momslab.dta", clear
append using "dadslab.dta", generate(datascreen)
describe

use "momslab.dta", clear
label variable hs "High School Degree"
label variable race "Race/Ethnicity"
label variable age "Age"
save "momslab1.dta", replace

use "dadslab.dta", clear
label variable hs "High School Degree"
label variable race "Race/Ethnicity"
label variable age "Age"
save "dadslab1.dta", replace

use "momslab1.dta", clear
append using "dadslab1.dta", generate(datascreen)
describe

save momsdadlab1.dta, replace

**
*Conflicting value labels
**
* Using our previous files, we find that the value labels may also be incorrect
* when appending. The primary file (the open one) will supersede the values
* in the appended file. 

* Note: this will not throw an error and your data will append, but it might
*       be confusing for yourself in the future or for a replicator. It is
*       good practice to use neutral value labels and value label names.

* Let's look at our files again.
* If you will notice that the value label names and the value labels will 
* rename as the primary dataset's value label name and value labels' values.
use momslab, clear
codebook race hs

use dadslab, clear
codebook race hs

use "momsdadlab1.dta", replace
codebook race hs

* You will notice that the value label name in the dads file is hsgrad, 
* while the moms file is grad. Grad supersedes the  value label name hsgrad 
* in the dads file. You will also notice that when you describe the data, a 
* message for the value labels will say eth (which is the same for both), but 
* all the data say Mom White or Mom Black. 

* Solution:
* Use neutral value labels and neutral value label names.


**
*Inconsistent variable coding
**
* Another problem that will not throw an error, but it will cause problems
* are inconsistent variable coding. If we have a binary variable for high
* school degree or note, where one data set is 0-No and 1-Yes and the other
* is 1-No 2-Yes, an error will not be thrown when the datasets are appended.
* However, it will be a problem if you try to use a factor variable, since
* there conflicting and inconsistent coding.

* Solution:
* Check your data, and check the data dictionaries of all the datasets.
* Summarize and tabulate your data by the datasets after appending will
* help prevent this. When you find the issue, just recode the variables
* to be consistent

use "momshs.dta", clear
append using "dads.dta", gen(datascreen)
list
tab hs datascreen

* Just recode the data to be consistent after finding the problem 
use "momshs.dta", clear
recode hs (1=0) (2=1)
* Or
* replace hs=0 if hs == 1
* replace hs=1 if hs == 2
append using "dads.dta", gen(datascreen)
tab hs datascreen

**
*Mixing variable types across datasets
**
* When we try to append data of a different time an error will be thrown. 
* We can use the force option to prevent the error, but as we have seen before
* this can cause numeric string variables with nonnumeric characters to become
* missing. This will cause data lose and additional measurement error.
use "moms.dta", clear
append using "dadstr.dta", generate(datascreen)

* Solution:
*      Resolve the discrepency in variable type before converting. Destring
*      the string variable containing numeric data in string format. Using 
*      force may result in data loss if not properly analyzed beforehand.

**
*When we have a small dataset with clean numerics in string
**
use "dadstr.dta", clear
destring hs, replace
save "dadstrtemp.dta", replace

use "moms.dta", clear
append using "dadstrtemp.dta", gen(datascreen)
list, sepby(datascreen)

**
*When we have a large dataset with messy numerics and characters in string
**
* Let's go back to 6.13 converting strings to numerics.
use "dadstr.dta", clear

* In small datasets, this is easy to check and fix.
* HOWEVER, in large datasets, you will need different techniques.
* I found this on Statalist using regular expressions. As I have said before,
* regular expressions can be a pain, but they are powerful.
* This statement below extracts the numerics from the string.
* https://www.statalist.org/forums/forum/general-stata-discussion/general/967675-removing-non-numeric-characters-from-strings
* regexm() looks for a numerics with "([0-9]+)" from the string hs
* regexs() looks for the nth part of the string.
gen n = real(regexs(1)) if regexm(hs,"([0-9]+)")
list

* An example of how regexm and regexs work from the help file
clear
input str15 number

"(123) 456-7890"
"(800) STATAPC"
end

gen str newnum1 = regexs(1) if regexm(number, "^\(([0-9]+)\) (.*)")
gen str newnum2 = regexs(2) if regexm(number, "^\(([0-9]+)\) (.*)")
gen str newnum = regexs(1) + "-" + regexs(2) if regexm(number, "^\(([0-9]+)\) (.*)")
list number newnum

* The point: regexm can be a lifesaver if you have numerical data stuck in 
*            string format with nonnumeric characters in a large file.

**************
*7.4 Merging: One-to-one 
**************
* Appending is straightforward and relatively easy to check to make sure 
* everything was appended well. Mergering is a bit tricker, since additional
* problems can occur, along with different types of merging.

* Note:
* Before discussing merging. It is KEY to have a identifier variable that is
* common between two datasets if they will merge. Examples include personal id,
* firm id, state FIPS, county FIPS, zipcode, etc.

* You may need multiple variables besides the identifier to properly merge.
* Let's say we want to merge state-level employment from the BLS QCEW with
* state-level GDP from BEA. We will likely need the county 2-digit FIPS code AND
* a time identifier, such as quarter or year. If the second identifier is missing
* we will not be able to properly merge the data.

* Note: 
*      In Stata, there are two datasets when merging. One is called the master
*      dataset and the other is called the using dataset.

* From our moms and dads datasets our KEY variable to merge is family id (famid)
* the moms1 dataset will be the master and the dads1 will be the using dataset
use moms1, clear
list

* There are only 1 observation per family, so we can do a 1-to-1 match. 
merge 1:1 famid using dads1
list

* Notice:
* Our focus should be on _merge. If _merge == 3, then that means all of our
* matches worked. If _merge == 1 or _merge ==2, then we have some non-merged
* observations. We may want this, or we might not expect this. Either way, it
* is a good idea to investigate.

* Notice:
* Ironically enough, having two different variable names works well with merge
* compared to append. We now have two variables for hs, race, and age, but with
* m or d to distinguish moms and dads. You can easily reshape these data into 
* a long format if necessary.

**
*When we don't have perfect matches
**
use "moms2.dta", clear
merge 1:1 famid using "dads2.dta"
* We can see that 

* When we merge, a variable called _merge is created to identify which 
* observations merged and which did not and why (only master, only using).
* We can tabulate the _merge variable that is created
codebook _merge
tab _merge

* Not every family was in both datasets
sort famid
list famid mage mrace dage drace _merge

* We have two matches between the data set, only 1 non-match that was only in
* the using data set (_merge==2), and 2 non-matches that were only in the master
* dataset (_merge==1).

* It is a good idea to investigate why there were no matches between the master
* and using datasets. We may want that or we may not want depending upon the
* goal. We can use a qualifier to look at which variables were only in the 
* master, using, and ones that matched
list famid mage mrace dage drace _merge if _merge==1
list famid mage mrace dage drace _merge if _merge==2
list famid mage mrace dage drace _merge if _merge==3

* Only famid 1 and 4 had observations in both datasets.

* Let's say if we only want matched observations, and we are not concerned with
* unmatched observations, then we can keep only when _merge == 3 and drop the
* non-matched observations.
keep if _merge == 3
list

**
*Potential Problem with 1-to-1 matching: duplicate ids
**
* What is we have duplicate ids with a 1-to-1 matching?
use "momsdup.dta", clear
list
* We have two observations for famid==4
merge 1:1 famid using "dads2.dta"
* It will throw an error, since famid does not unique identify units for 
* matching. You would want to double check that famid is supposed to have 
* two observations before proceeding.

**
*1-to-1 Matching with more than one key variable
**
* In our prior example we had duplicate for famid, and we might expect that
* if we had multiple family members. But, for 1-to-1 matching, we need a unique
* identifier(s) to properly match.
* Let's use kids1 for multiple kids for the same family
use "kids1.dta", clear
sort famid kidid
list
* We now have a family id (famid) and kid id (kidid)
use "kidname.dta", clear
sort famid kidid
list

* Let's merge using two key matching variable
use "kids1.dta", clear
merge 1:1 famid kidid using "kidname.dta"
list

**************
*7.5 Merging One-to-many
**************
* Sometimes we need to match file's observations to multiple observations in
* another data set. Maybe we have CPS data and we want to merge unemployment
* rates at the state-level to individuals units within those states. We have
* one values at the state-level for month m that needs to match multilple 
* individuals in state s.

* When we have multiple to one observation, we cannot use 1-to-1 merge. We 
* need a 1:m merge. 
* We can illustrate this with moms1.dta and kids1.dta. One mom may have 
* multiple kids, so when we merge kids and moms data, we will need a 1:m merge

use "moms1.dta", clear
list
use "kids1.dta", clear
list
* Each kid and mom has a family id (famid) that we will use to match multiple
* kids to moms. Our moms have 1 observation while the kids have m observations.
* Since our moms have 1 observation and there are multiple kids, we need to 
* align our 1:m properly. Since moms is the master the 1 is one the left of 1:m,
* while the using kids has multiple obervations to family it is the m of 1:m.

use "moms1.dta", clear
merge 1:m famid using "kids1.dta"
list

* If we were using kids as the master
use "kids1.dta", clear
merge m:1 famid using "moms1.dta"
list, sepby(famid)

* If we tried to use 1 on the kids data and m on the moms side, then an error
* will be thrown saying that famid does not identify observation in the master
* dataset.
use "kids1.dta", clear
merge 1:m famid using "moms1.dta"
 
* 1:m means one-to-many
* m:1 means many-to-one
* Make sure your data are properly ordered in the merge command.

**
*One-to-many merge with problems
**
* Many times our data are not so clean for a perfect match, so what happens
* when not all observations in both files have the same identifier (ex: famid)?
* Let's use data without all of the same identifiers.
use "moms2.dta", clear
list

use "kids2.dta", clear
list, sepby(famid)

* Merge 1-to-many
use "moms2.dta", clear
merge 1:m famid using "kids2.dta"

* We have 5 matched observations and 4 unmatched observations. 2 observations
* were only in the moms dataset and 2 observations were in the kids dataset.
tab _merge
sort famid kidid
list, sepby(famid)

* When _merge==1 we have missing observations in the kids variables, and when
* _merge==2 we have missing observations in the moms variables.
* Non-matched data
list if _merge == 1 | _merge == 2, sepby(famid)
* Matched data
list if _merge == 3, sepby(famid)

**************
*7.6 Merging multiple datasets
**************
* Sometimes we need to merge more than 2 datasets together. The examples in the
* book have nogenerate in the merge command. I don't recommend this, and after
* you have inspected your first merge and are satisfied with the results use
* the drop command to drop _merge, and then proceed with your second merge.

* Let's say we have three datasets
use "moms2.dta", clear
merge 1:1 famid using "momsbest2.dta"
sort famid
list, sepby(famid)
* Inspect the merge
tab _merge 
* You may want another variable to inspect in the tabulation, which is helpful
* with large datasets where you cannot eyeball every observation.
* For example
tab mage _merge
* Drop the _merge after successful inspection
drop _merge

* Merge the 3rd dataset
merge 1:1 famid using "dads2.dta"
* Inspect the merge
tab _merge
* Drop the 2nd merge for 3rd merge
drop _merge

* Merge the 4th dataset
merge 1:1 famid using "dadsandbest.dta"
* Inspect the merge
sort famid
list famid fr_*, sepby(famid)
* Drop for 4th merge
drop _merge

* Now add a 4th merge but with a 1-to-many
merge 1:m famid using "kidname.dta"
* Inspect the merge
tab _merge
list famid fr_*, sepby(famid)

* Mitchell suggests a user-contribution command called dmtablist. 
* You must have Stata 16 or higher, so I'm unable to demonstrate it.

**************
*7.7 Update mergers
**************
* There is an interesting update option with the merge if for some reason, 
* you wanted to check an older version of your data. It will replace the
* data in your master file with data in your using file. I have never 
* used this set of options, but they may have value in future situations.

use moms5, clear
list

* Here is an updated file with error corrections and previously missing data
use moms5fixes, clear
list

* If we use the update option, then it will find matching data, missing data to
* update, and conflicting data, which are data that match on the key variable,
* but are of different values

use moms5, clear
merge 1:1 famid using moms5fixes, update

* Inspect the merge - 
*   We have 1 observation famid==4 that there are no corresponding observations
*   in our using data
*   We have 2 missing data in our master that are updated with data from using
*   We have 1 conflict data between the master and using datasets: 82 vs 28.
 
sort famid
list

* If we want to update the conflicting data, then we need to the replace 
* option along with the update option
use moms5, clear
merge 1:1 famid using moms5fixes, update replace

* Inspect the merge - rember if it is a large data set then tabulation by
* variables may be more appropriate than list

sort famid
list

**************
*7.8 Merging Additional options
**************
* There are some additional options in merge, which may be of interest that
* we will cover.

**
*keepusing()
**

* The keepusing() option can be helpful when merging two datasets with hundreds 
* of variables. Our data sets here are small, but the CPS, ACS, etc. can have
* hundreds of variables and we may only want a few additional variables from
* a using dataset

* Let's say we only want dads age and dads race from our using dataset
use dads1, clear
list

* We can use the keepusing() option to keep dage drace
use moms1, clear
merge 1:1 famid using dads1, keepusing(dage drace)
list

* We do not keep dhs after the merge since we specify dage and drace with the
* keepusing() option

**
*assert()
**

* Another interesting option is assert(), which could be useful in certain
* situations. If we specify assert(match), Stata will throw an error if 
* all observations are not matched. This may or may not be helpful when
* inspecting the data post-merge. An option of assert(match master) makes sure
* that all merges are matched or from the original dataset.
* More information is on page 247-248.

**
*Other options
**

* I never recommend using noreport or nogenerate options, since these are 
* essential for inspecting your merges. 

* generate option is just basically a rename of _merge

* I don't recommend the keep() option either. You should inspect your data
* and then when you are satisfied, you can use the drop command with a 
* qualifier using _merge: drop if _merge == 1 | _merge == 2

**************
*7.9 Merging Problems
**************
* Merging can be trickier than appending. Appending is fairly straightfoward, 
* but some of the topics are similar

**
*Common variable names
**

* This is a similar problem to append, but we need different variable names
* instead of the same variable names. If we have common or the same variable
* names with merge, then we will lose data. It is important to note that 

* In our example we have similar columns of data, but with different names
* except for mom's age and dad's age which are both named "age".
* For example the race column in moms data is called race, while the race 
* column in dads data is called eth. But, both datasets have age named as age.
use moms3, clear
list
use dads3, clear
list
use moms3, clear
merge 1:1 famid using dads3

* Our merge is successful, but we lost dads age. Note, that are merge appears
* successful and we will not notice the lost data. This easy to notice in a 
* small dataset, but what about datasets with hundreds of variables? We should
* inspect our data systematically beforehand to prevent this problem.

* Solution
*    There is a helpful command called cf (compare files) that can detect 
*    variables that are common/same and different between datasets. Once
*    detected, rename the variable to a name that would make sense e.g: momsage.
use moms3, clear
cf _all using dads3, all verbose

* From the cf command, we want to compare variables and we find that race
* and hs are not in the master file, but age is and there are 4 mismatched
* observations. We can easily enough rename our age variable in the master 
* before performing our merge. Our all option will compare all the variables,
* but if we don't use this option, only mismatched will appear. There is a
* verbose option that will give a detailed listing of each observation that
* differs. Verbose is probably not practical when merging data between large
* datasets.

* Notice: our key variable famid does not appear as a mismatch.

* Remember, In append, when we had different variable names, we would create 
* new and inconsistent columns of data. In merge we want new variable names
* to preserve all of our data.

* Mitchell recommends that you check out a blog on Merges Gone Bad:
* https://blog.stata.com/2011/04/18/merging-data-part-1-merges-gone-bad/
search merges gone bad

**
*Same value label names
**

**
*Conflicts in key variables
**

* This is a similiar but slightly different problem that we saw in append.
* When there are two value labels of the same name, the master value label
* name will overwrite the using value label name. A message will pop up, but
* an error will not be thrown.

* In our example, high school has label dhs and label mhs so they are unique, 
* but race is common between moms4 and dads4, and when merging the master 
* label values will overwrite the using.

use moms4, clear
merge 1:1 famid using dads4
list famid mrace drace mhs dhs

* A message saying "label race already defined")

label values dracel 1 "White" 2 "Black"
* Solutions:
*   1) Precheck all variable names with describe to prevent this (but this may
*   be unreasonable in large datasets), and then label value labels of the 
*   common value labels to a more generic value label.
*   2) An alternative could be to relabel your data after a merge. 
*   3) Mitchell recommends the precombine command which is available in later
*   versions of Stata.

**
*Conflict in key variables
**
* Note: your key variables need to be in the same type numerics or strings.
*       Please check your key variables before merging.

**
*m:m matching
**
* You need to be careful when doing m:m matching, and I don't think Mitchell
* even talks about this. It is preferable to have your main dataset as your
* unique observations (your 1), and your using having multiple observation 
* (your m). There could be situations where you might need it, but it shouldn't
* be your default go to for merge

use moms1, clear
append using dads1
sort famid
list

* An example of a problem with m:m merging.
* We now have multiple famid ids: one for moms, one for dads. And now if we
* want to merge kids data, we try a m:m matching since we have multiple 
* parents and multiple kids

merge m:m famid using kids1
list

* We need to be careful, and observe our data for problems.
* We have a duplicative kidid since famid==1 only has one kid
* We have a duplicative mom in famid==4
* This is likely very problematic. 

* Solution:
*    A better approach would be to merge moms and dads data, and then merge 
*      the kids data with a 1:m.
*    A joinby might be preferable here, which will be discussed next

**************
* 7.10 Joining datasets
**************
* Joinby command is similar to the merge command but there are some differences.

* There are different types of joinby that can be changed by the unmatched()
* option. 
* There is inner joinby where unmatched() is left off. This is only the
* matched observations. 
* There is a left joinby where unmatched(master) is added as an option, and we
* keep all master observation matched or unmatched and drop all unmatched 
* using observations.
* There is a right joinby where unmatched(using) is added as an option, and we
* keep all using observations matched or unmatched and drop all unmatched 
* master observation.

* Joinby command only keeps matched observations by default, but this can be
* very problematic. I suggest using the unmatched(master) option as it is a
* left join. You should probably keep your observations in at least one dataset.

* I personally recommend that you use merge instead of joinby, since you have
* more inspection diagnostics to make sure your data merged properly. But there
* my be situtations where a left-join is a better option instead of a m:m merge.
* This usually deals with multiple observations for an id variable such as
* moms and dads and multiple kids.

* We have multiple kids for each family ranging from 1 to 3.
use kidname, clear
sort famid kname
list, sepby(famid)

* We have two parents in each family
use parname, clear
sort famid
list

* We'll look at an inner join first
joinby famid using kidname
sort famid kname pname
list, sepby(famid kidid)

* Notice we have a family id, but also a parent id in the mom variable (0,1)
* We can have a left-join, but it will be the same as an inner join.
* This might be preferable, since not all parents may have kids and we would
* want to keep their data.
* We'll look at a left-join
use parname, clear
joinby famid using kidname, unmatched(master)
sort famid kname pname
list, sepby(famid kidid)

**************
* 7.11 Crossing datasets
**************
* If you are interested in cross data, it can be found on pages 255-257.
* The cross command matches each observation in the master dataset 
* to the using dataset. 

* In our moms and dads data set, we have 4 moms and 4 dads. The cross command
* will match every possible combination, so we have a 4x4 outcome. This might
* be of interest, and have some usefulness with combination and permutations, 
* but I have never personally used this.

use moms1, clear
cross using dads1
sort famid
list, sepby(famid)
