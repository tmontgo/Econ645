*Week 7: 
*Chapter 16: Simultaneous Equation Models
*Chapter 9: Changing the shape of your data
*Econ 645
*Samuel Rowe Adapted from Wooldridge and Mitchell
*August 27, 2023

clear
set more off

********************************************************************************
*Wooldridge
********************************************************************************
*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

******
*Labor Supply of Married, Working Women
******
*Let's look at the data for married working women
use mroz.dta, clear

*Our labor supply equation
*hours=a1*ln(wage) + b10 + b11*educ + b12*age + b13*kidslt6 + b14*nwifeinc + u1

*Our labor demand equation in term of wages as a function of productivity
*ln(wage)=a2*hours + b20 + b21*educ+ b22*exper + b23*exper-squared + u2

*To estimate our labor supply we use educ, age, kidslt6, nwifeinc, exper, 
*and exper-squared
ivregress 2sls hours (lwage=exper expersq) educ age kidslt6 nwifeinc, robust

*Test exper and expersq as instruments
reg lwage exper expersq educ age kidslt6 nwifeinc, robust
test exper expersq

*Note: Our instrument is rather weak.
*      What is a possible problem with this first-stage?

*Interpretation:
*Our results show that the labor supply curve slopes upward.
*Our results can be interpreted through linear-log elasticity

*  delta-hours ~ 1640/100*(%delta-wages)
*100*(delta-hours/hours) ~ (1,640/hours)(%delta-wages)
*Or %delta-hours ~ (1,640/hours)(%delta-wages)

*The elasticity is not constant since it is a linear-log model instead of log-log
*model
*Using average hours worked of 1,303
*Our estimated elasticity = (1,640/hours)(%delta-wages) or 1,640/1,303=1.26
display 1640/1303
*Our estimated elasticity around mean hours is 1.26%, which means a 1% increase
*in wages around mean hours increases hours by 1.26%. This mean wage elasticity
*of supply is elastic (>1) around mean hours.

*It's not constant elasticity
*When hours are higher, full time 40 hours every week, a 1% increase in wages
*increase the supply of hours around 0.79%
display 1640/(40*52)
*Our wage elasticity of supply is inelastic since (<1)

*At lower hours, our estimated wage elasticity of supply is more elastic
*When hours are equal to 800, then our wage elasticity of supply is almost 2
display 1640/800
*A 1% increase in wages increases hours by 2.05%

**********
*Inflation and Openness
**********
use openness.dta, clear

*Romer (1993) proposes that more open countries should have lower inflation
*rates. Romer (1993) tries to explain inflation rates in terms of a country's
*average share of imports in gross domestic (or national) product since 1973.
*Average share of imports in GDP is his measure of opennes.

*inf=b10 + a1*open + b11*ln(pcinc) + u1
*open = b20 + a2*inf + b21*ln(pcinc) + b22*ln(land) + u2

*Where 
*open is the average share of imports in terms of GDP
*pcinc is the 1980 per capita income
*land is land area of a country in square miles

*We can look at the reduced form equation to see the instruments impact on
*openness
reg open lland lpcinc, robust
*Let's test the instrument and use an F-test
test lland
*We want to see if a country's openness impacts a country's inflation rate 
*using natural log of square miles as an instrument
ivregress 2sls inf (open=lland) lpcinc, robust

*Interpretation
*For every percentage point increase in average share of imports of GDP,
*inflation decreases by 0.337 percentage points

****************
*Exercises
****************
*Pull CPS data and recreate MROZ.dta with CPS data, expect use all individuals
*not just working women

*Estimate linear-log and test elasticity at different hours.
*Estimate constant elasticity with a log-log model.

********************************************************************************
*Mitchell
********************************************************************************
**********
*Chapter 9: Changing the shape of your data
**********

*Set Working Directory
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

*******
*Intro
*******
*From my experience, I feel that understanding and mastering the reshape command
*is invaluable. This is especially true when working with panel data. Panel data
*should not be used in a wide format. Panel data should be in a long format
*where you can use the xtset unit time command. After the xtset is established
*you can easily add lags or differences with the l.var or d.var

*It is also helpful in terms of mergering datasets. A lot of time if I'm 
*mergering BLS data, such as state unemployment, or inflation rates, I need
*to reshape the BLS data from wide to long to I can merge m:1

*I typically work in long formats, but reshaping to wide formats does have its
*benefits. I find wide formats are helpful for people who work in excel, 
*especially when years are across columns

*******
*9.2: Wide and long datasets
*******
*We have two types of datasets: wide and long
**
*Wide Format
**
*Our wide datasets typically include years or variables types spread out across
*the columns. 
use cardio_wide, clear
describe

*We have 12 variables idcode, age, and our 5 different blood pressure and pulse
*trials.
*We see that are 5 different incidents/trials of blood pressure and 
*pulse are spread out across 5 different variables bp1-bp5 and pl1-pl5
list

*With a wide format each row is an observation and all of our different trials
*are located on a single row

**
*Long Format
**
*We'll look at an example of the same dataset but in long format
use cardio_long, clear
describe

*We only have 5 variables idcode, age, trial, blood pressure, and pulse.
list
*We also see that each individual has 5 observations. One for each trial that
*is sorted from 1 to 5. 
*Notice: 
* We have a cross-sectional unit variable with idcode and 
* We also have a time component with trial.
*Our dataset is basically a panel data set. We observe the same person over
*5 trials.

*What kind of format should we use? 
*It depends.
*Wide Format 
*Mitchell makes a good point of looking at correlations among the 
*blood pressure trials. 
use cardio_wide, clear
correlate bp1 bp2 bp3 bp4 bp5

*Mitchell also mentions that multivariate analysis with multiple trials
*is a bit easier with factor variables. If we wanted to see all of the 
*different regressions for each trial, then
mvreg bp*=age

*Long Format:
*If we want correlations between blood pressure and pulse, a long format is 
*preferable
use cardio_long, clear
correlate bp pl
*Or
bysort trial: correlate bp pl

*It is also more appropriate for panel data and the xt commands, such as
*xtset, xtreg, etc. I also prefer this for regular regressions where we
*can use factor variables i.var for different time periods.
xtset id trial
xtreg bp age
xtline bp, overlay

*It is also easier to recode in long format
recode pl (min/89=0) (90/max=1), generate (plhi)
*Doing this in wide format is more of a pain
*You can see this on page 293 in Mitchell. 

*If you wanted to mean of each 5 trials, it just as easy with egen in 
*long format.
bysort id: egen pl_avg=mean(pl)
bysort id: egen bp_avg=mean(bp)

*For wide-format you can use rowmean with the wildcard
use cardio_wide, clear
*We don't need the bysort group, but we need to be careful which columns to 
*include
egen pl_avg = rowmean(pl*)
egen bp_avg = rowmean(bp*)

*It easier to explicitly difference trails with wide-format, but requires
*more typing
generate pldiff2 = pl2-pl1
generate pldiff3 = pl3-pl2
generate pldiff4 = pl4-pl3
generate pldiff5 = pl5-pl4

*But I prefer using subscripting/indexing within groups or using xtset with 
*panel data since we have a lot of flexibilities.
use cardio_long, clear
sort id trial
*We can use indexing 
by id: generate pldiff = pl-pl[_n-1]
*We can difference from the first trial
by id: generate pldiff_1trial = pl-pl[1]

*We can use xtset as well with l.var
xtset id trial
*One lag
gen pldiff_other = pl-l.pl
*We can use two lags
gen pldiff2_other = l2.pl-l1.pl
*We can use three lags
gen pldiff3_other = l3.pl-l2.pl

*Wide format can become unwieldy quickly and Stata does have a variable limit 
*size, while your observation limit is typically your memory.
*In short, it is better in the long-run to learn to work with Stata in 
*long-format.

*However, Mitchell does bring up a good point that in our panel data, we may
*need multiple weights wt1-wtk. You can see this in the ACS PUMS with 250 or so
*replicate weights. We do not want to reshape our data by weights, we need to
*keep the data in a cross-sectional unit i and time period t format.

*In short, I agree with Mitchell that you should learn to work with your data
*in a long-format data structure.

**********
*9.3 Reshaping Long to Wide
**********
*There may be scenarios where we need to reshape our long-format data into
*a wide format. For example, it might be easier to match and merge our data
*If our using data set is in wide format and our master data set is in wide
*format

*Let's look at an example
use cardio_long, clear
describe 
list

*Our reshape command requires 
*reshape
*What direction: wide or long
*Variables to reshape (bp and pl)
*Variables define an observation i(id)
*Variables that defines the repeated observations for each person or
*time variable j(trial) for reshaping long to wide
*Trial values will become the suffix values for our reshape values
reshape wide bp pl, i(id) j(trial)
describe
list
*Notice we excluded age. It is constant within the cross-sectional unit.
*It does not define the cross-sectional unit or the*time dimension unit. 
*We do not want to separate it into repeated observations either.

*Without doing any additional work, we can reshape it back to long with 
*simply reshape long.
reshape long
describe

*************
*9.4 Reshaping Long to Wide: Problems
*************
*Problem 1: a constant value within a cross-sectional unit is not constant
use cardio_long2, clear
list in 1/10
*We see that cross-sectional unit 1 has a data entry problem with age in the
*3rd trial. If we reshape, we will get an error
reshape wide bp pl, i(id) j(trial)

*Use the reshape error command to help with the problem
reshape error
*It tells us that our constant variable is not constant within cross-sectional 
*units

*Problem 2: excluding a non-constant that we need to reshape.
*If we excluded pl from our reshape, we will get a similar error
reshape wide bp, i(id) j(trial)
reshape error

**************
*9.5 Reshaping Wide to Long
**************
*In my personal opinion, this reshaping wide to long is a more common occurance.
*It is important to get data into a long-format so we can conduct panel analysis.
*I had to do this for a few of the Wooldridge datasets that were panel data, but
*in wide format.

use cardio_wide, clear
describe
list

*Let's reshape wide to long with
*Our reshape values that are not constant: bp and pl
*Our cross-sectional unit to reshape upon or our list of variables that 
* uniquely identify a cross-sectional unit. For example, we may need a 
* State FIPS code and a County FIPS code to unique identify a county 
* cross-sectional unit (of course we can merge the 2-digit State FIPS code 
* and the 3-digit County FIPS code to create a 5-digit FIPS code in one variable).
*Our time unit, where with reshape long, we need to create a new variable that
* takes on the values of the suffixes of bp and pl (For example trialnum).
*Our constant values within cross-sectional units do not need to be identified.
reshape long bp pl, i(id) j(trialnum)
describe
list in 1/10

*To reshape it back to wide, we just simply state
reshape wide
describe
list

************
*9.6 Reshaping wide to long problems
************
*Problem 1: Failing to list all of the varying variables to be reshaped

*This is a dangerous kind of problem, since it doesn't throw an error.
*This requires the user to inspect the data after reshaping to make sure
*everything worked properly.
use cardio_wide, clear
reshape long bp, i(id) j(trialnum)

*The remedy is easy: don't forget all of your variables to be reshaped
use cardio_wide, clear
reshape long bp pl, i(id) j(trialnum)

*Problem 2: Be careful when the time-varying value is embedded within the
*           variable name and not at the end.

*Typically you will find that the varying variable will have var1, var2, ..., vark
*and you simply specify reshape long var, i(id) j(time). But, if the varying
*value is embedded like t1bp,...,t5bp and t1pl,...,t5pl, then we cannot simply
*use reshape long tbp tpl, i(id) j(trialnum), since Stata looks for the varying
*value at the end
use cardio_wide2, clear
describe
reshape long tpl tpb, i(id) j(trialnum)
reshape error

*We need the operator @ to indicate to Stata that our varying-values are in
*that part of the variable names
reshape long t@pl t@bp, i(id) j(trialnum)
describe
list in 1/10

*Problem 3: Be specific with which variables to reshape and don't mistakenly
*           constant variables that have the same prefix as the varying variables
use cardio_wide3, clear
clist bp* pl*, noobs

*Our bp2005 and pl2005 are constant variables within our cross-section, but
*have the same prefix as our value-varying variables
reshape long bp pl, i(id) j(trialnum)
describe
list in 1/12, sepby(id)

*We did not intend to reshape bp2005 and pl2005. 

*To rememdy, we need to specify the values within j() with j(trialnum 1-5) to
*indicate that we only want to reshape suffixes with 1-5
use cardio_wide3, clear
reshape long bp pl, i(id) j(trialnum 1-5)
describe
list in 1/10, sepby(id)

*Problem 4: No id varible to identify the cross-sectional unit
*If each wide-format observation is a unique cross-sectional unit, then we can 
*use _n to generate a unique id variable
use cardio_wide3, clear
describe
gen idcode = _n
describe
reshape long bp pl, i(id idcode) j(trialnum 1-5)
describe
list in 1/10, sepby(id)

***************
*9.7 Multilevel datasets
***************
*Mitchell discusses when we have multiple levels of data, such as 
*cross-sectional unit i and time dimension t, where data is level 1 data
*are constant across time within unit, but vary across cross-sectional units
*and level 2 data are time-varying data that vary within a cross-sectional units

*Sometimes we have multiple levels, such as school district, school, classroom,
*and student. 

*If you are interested, please review pages 311-314
***************
*9.8 Collapsing datasets
***************
*The collapse command can be useful finding statistics at aggregate levels 
*for different groups.  You don't have to use egen but you can if you would like.
*After using the egen command, such as egen sumvar = sum(var), 
*or egen avgvar = mean(var) the collapse command can be useful.
*Let's say we want to aggregate mean wages by state in the CPS, we can use the
*egen mean command to find average wages in the state for month m in year y.
*We can then keep state month year and avgvar for all 50 states for each
*month and year of interest.

*We need to be careful with the collapse command, since your original data
*are lost from memory unless you use a tempfile or a data frame.

use cardio_long, clear
list, sepby(id)

*Let's say we want to find mean blood pressure and pluse for each cross-sectional
*unit, then we can use the egen command or the collapse commands
sort id
by id: egen meanbp = mean(bp)
by id: egen meanpl = mean(pl)
by id: egen maxbp = max(bp)
by id: egen maxpl = max(bp)
by id: egen minbp = min(bp)
by id: egen minpl = min(bp)
by id: egen medbp = pctile(bp), p(50)
by id: egen medpl = pctile(pl), p(50)

collapse meanbp meanpl maxbp maxpl minbp minpl medbp medpl, by(id)

*Or you can just use the collapse command
use cardio_long, clear

collapse (mean) meanbp=bp meanpl=pl (max) maxbp=bp maxpl=pl ///
         (min) minbp=bp minpl=pl (p50) medbp=bp medpl=pl, by(id)
*Notice that our data are rounded to the nearest 1, unlike our egen commands
*We can format our data to reflect that decimal point to two places instead
*of rounding up by default
use cardio_long, clear
format bp* pl* %5.2f
collapse (mean) meanbp=bp meanpl=pl (max) maxbp=bp maxpl=pl ///
         (min) minbp=bp minpl=pl (p50) medbp=bp medpl=pl, by(id)

***************
*Exercises
***************
*Pull BLS monthly inflation data, reshape it into long, and merge with CPS

