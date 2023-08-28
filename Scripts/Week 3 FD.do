*Week 3 and 4: Pooled Cross-Sections and Panel Data
*Samuel Rowe Adapted from Wooldridge
*August 2, 2023

clear
set more off

cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"

********************************************************************************
*Wooldridge
********************************************************************************

*************************
*Fertility over time
*************************
use "fertil1.dta", clear
*No Time Trends
reg kids educ c.age##c.age i.black i.east i.northcen i.west i.farm i.othrural ///
         i.town i.smcity 

*Time Trends Time Fixed Effects
reg kids educ c.age##c.age i.black i.east i.northcen i.west i.farm i.othrural ///
         i.town i.smcity i.y74 i.y76 i.y78 i.y80 i.y82 i.y84
		 
**************************
*Changes in the Returns to Education and the Sex Wage Gap
**************************
use "cps78_85.dta", clear
reg lwage i.y85##c.edu c.exper##c.exper i.union i.female##i.y85

*Chow Test
test 1.y85 0.y85 1.y85#edu 1.y85#1.female
*Test slopes
test 1.y85#edu 1.y85#1.female
*Test intercepts
test 1.y85 0.y85
 
*****************
*Sleep vs Working
*****************
*Good example of a poorly set up panel data
use "slp75_81.dta", clear

*Reshape
gen id=_n
gen age81=age75+6
reshape long age educ gdhlth marr slpnap totwrk yngkid, i(id) j(year)
replace year=year+1900

*Gen time binaries
gen d75 = .
replace d75=0 if year==1981
replace d75=1 if year==1975

gen d81=.
replace d81=0 if year==1975
replace d81=1 if year==1981

*Check
tab d81 d75

*Now we can work with the panel
*Let xtset know that there is a 6 year gap in the data
*If not, it will try to take a 1 year change and 1976 does not exist
xtset id year, delta(6)

*slpnap - total minutes of sleep per week
*totwrk - total minutes of work per week
*educ - total years of education
*marr - married dummy variable
*yngkid - presence of a young child dummy variable
*gdhlth - "good health" dummy variable

*Pooled OLS
reg slpnap i.d81 totwrk educ marr yngkid gdhlth 
*FD Model
reg d.slpnap d.totwrk d.educ d.marr d.yngkid d.gdhlth
*FE Model
xtreg slpnap i.d81 totwrk educ marr yngkid gdhlth, fe
*Similar except time dummy and base intercepts
*look at the difference between educ in Pooled and FE models
*There is likely a confounder between ability sleep and education

*Let's look at elasticities
gen lnslpnap=ln(slpnap)
gen lntotwrk=ln(totwrk)
gen lneduc=ln(educ)

*FD Model
reg d.lnslpnap d.lntotwrk d.lneduc d.marr d.yngkid d.gdhlth

**********************************
*Enterprise Zones and Unemployment
**********************************
use "ezunem.dta", clear

*Pooled OLS
reg luclms i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 i.d88 cez

*Set the Panel Data
xtset city year

*First Difference
reg d.luclms i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 i.d88 d.ez
predict r
gen lag_r = l.r

*Test for Heteroskedasticity
estat imtest, white

*Test for autocorrelation
reg r lag_r d83 d84 d85 d86 d87 d88 cez
xtserial luclms d83 d84 d85 d86 d87 d88 cez

*Robust for serial correlation within unit of analysis clusters
reg d.luclms i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 i.d88 d.cez, robust cluster(city)



********************************
*County Crimes in North Carolina
********************************
use "crime4.dta", clear
*Pooled OLS
reg lcrmrte i.d82 i.d83 i.d84 i.d85 i.d86 i.d87 lprbarr lprbconv lprbpris lavgsen lpolpc

*First Difference
xtset county year
*With xtset, we can use the d. for our explanatory variables
*We don't include 
*With OLS Standard Errors
reg d.lcrmrte i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc
*Test for autocorrelation with one lag AR(1)
predict r, residual
gen lag_r =l.r
reg r lag_r i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc

*Another way to test for AR(1)
reg d.lcrmrte i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc

xtserial lcrmrte d83 d84 d85 d86 d87 lprbarr lprbconv lprbpris ///
              lavgsen lpolpc, output
			 
*Test for heteroskedasticity
rvfplot,yline(0)
estat imtest, white
estat hettest
*Test for serial correlation
*With Robust Standard Errors 
*and cluster by county (deal with error correlations within counties)
reg d.lcrmrte i.d83 i.d84 i.d85 i.d86 i.d87 d.lprbarr d.lprbconv d.lprbpris ///
              d.lavgsen d.lpolpc, robust cluster(county)
			  
********************************************************************************
*Mitchell
********************************************************************************

*Honestly, this chapter has a bunch of useful information, but the most 
*important parts are label define and its two options of add and modify, along
*with label values. Everything else is interesting, but not essential. Section
*5.8 on formatting is also fairly important for down the road.
cd "/Users/Sam/Desktop/Econ 645/Data/Mitchell"

************
*5.2 Describing datasets
************
*Let's get some data on the survey of graduate students
use "survey7.dta", clear

*We have seen the describe command before, but it is a very useful command 
*to being working with data. It provides the varible name, storage type, 
*display format, value label, and variable lable
describe

*We also have a short option, but it just contain general information
describe, short

*We can subset the variables we want to describe if we want
describe id gender race

*Finally, the command codebook provides a deep dive into your dataset. This is
*very useful for looking at the value labels. We only see the value label name 
*in the describe command, but the codebook command provides more information, 
*such as type of variable, label name, range of values, unique values, 
*missing, value labels, missing value labels (if any)
codebook

*We can go by variables 
codebook race

*We can go by variables and notes
codebook havechild, notes

*We can look at the variable and missing value labels with the option mv.
*I recommend that you don't label the missing values unless it is absolutely
*necessary. Different types of missing values besides "." cause problems down
*the road, especially with the marginsplot command.
codebook ksex, mv

*If you are interested in the different languages labels it is on page 112

*The lookfor command will return all variables with the search word. This is a
*bit redundent, since this is available in the variable window. But, it provides
*more space to look.
lookfor birth

*We can also search for the notes by the search word
notes search birth

*We can see the formats of the variables as well
list income bday
describe income bday
*We can see that the format for income is %11.1fc and the format for bday is %td

************
*5.3 Labeling variables
************
*Labeling the variables is a very helpful shortcut to describe what the variable
*contain without having to go back to the data dicionary. Sometimes we want
*a short and concise label if we are exporting labels to regression tables, or
*sometimes we want longer variable labels to give us context of the variable.

*Let's get some data on graduate students
use "survey1.dta", clear
*and describe
describe 

*We have no variable labels, so we will need to provide some so future users
*have an understand what the data are.
label variable id "Identification variable"
label variable gender "Gender of the student"
label variable race "Race of the student"
label variable havechild "Given birth to a child"
label variable ksex "Sex of child"
label variable bday "Birthday of student"
label variable income "Income of student"
label variable kbdays "Birthday of child"
label variable kidname "Name of child"
describe

*We can simply change the variable label with running the command again with
*the new variable label.
label variable id "Unique identification variable"
describe

save survey2, replace

************
*5.4 Labeling values
************
*Labeling values is a very practice way of analyzing data without having to 
*go back to the data dictionary.

*Labeling values is a bit different than labeling variables, since we need to
*modify or replace after a label has been defined.

use survey2, clear

*Let's look at our codebook
codebook 

*We have our variable labels from 5.3, but now we need to label the values so
*replicators can know what the data are without having to reference the data
*dictionary for every variable

*First we need to define a label with label define
label define racelabel 1 "White" 2 "Asian" 3 "Hispanic" 4 "Black"

*Next we need to label the values of the variable with label values
label values race racelabel

*Let's look at our codebook again
codebook race

*We are still missing a value label for 5, which is Other, so we need to modify
*our defined label race1. If we do not modify our label, we will get an error
*if we try to label values again.  We can use the add option in label define.
label define racelabel 5 "Other", add

*If we want to modify an existing label, we can use the modify option in label
*define
label define racelabel 4 "African American", modify

*Let's look at our codebook again
codebook race

*Labeling missing is something that I don't recommend, but we'll show an
*example here
label define mfkid 1 "Male" 2 "Female" .u "Unknown" .n "NA"
label values ksex mfkid
codebook ksex

label define havechildlabel 0 "Don't have a child" 1 "Have a child" .u "Unknown" .n "NA"
label values havechild havechildlabel
codebook havechild

*We can look at our label list to see what we have define so far
label list

*The numlabel command is an interesting command. It takes the guess work out of
*knowing the numeric value of the category by appending the numeric value with
*the label value
numlabel racelabel, add
label list racelabel
tabulate race

*And, if we don't like it or don't need it any more, we can remove the numeric
*values
numlabel racelabel, remove
tabulate race

*We can add additional characters with numlabel as well, such as "#=" or "#) "
*with the mask option
numlabel racelabel, add mask("#) ")
tabulate race
*We can remove the mask with remove plus the mask option
numlabel racelabel, remove mask("#) ")
tabulate race

save survey3, replace

************
*5.5 Labeling utilities
************
*Stata has label utilities to manage the labels defined. The first one is
*label dir to see the labels names available in a quick and more concise way 
*than using the codebook command

*For me, I think that label list will be your most useful command here.

*Quick check of your label directory
label dir
*Label list gives a more comprehensive view of your labels that includes the
*value labels associated with the value label name
label list

*Label save command will save your labels into a do file for future use.
*Our do file name is stated after the using statement.
label save havechildlabel racelabel using surveylabs
type surveylabs.do

*Labelbook is command that provides information similar to codebook but only 
*for the labels that are defined
labelbook
labelbook racelabel

*The labelbook problem option provides information to alert the users of 
*any problems
labelbook, problem

*We can have a more detailed look with the detail and problem options
labelbook racelabel, problem detail

************
*5.6 Labeling variables and values in different languages
************
*We will not be covering this, but if you are interested, please review 
*pages 127-132

************
*5.7 Using Notes
************
*Notes can be helpful for future users or for replicators. 
*If you use the note command without specifying the variable, then it is a 
*general note that will show up under the _dta note.  If you add a variable 
*in front of the note command, like note var1:, then you will add a note to
*the variable

*Let's add some general notes
note: This was based on the dataset called survey1.txt
*Adding TS to the end adds a timestamp, which is a nice feature
note: The missing values for havechild and childage were coded using -1 and ///
      -2 but were converted to .n and .u TS
	  
*Let's call our notes with the notes command
notes

*Let's add some notes to our variables and check
note race: The other category includes people who specified multiple races
note race: This is another note
note race: This is a third note
notes
*Or we can just call a particular variable for notes
notes race

*Let say we added an unhelpful note, then we can drop it with notes drop and
*we want to drop the second note.
notes drop race in 2
notes race

*Notice that we have a gap in the sequence of numbering. We can fix that with
*the notes renumber command
notes renumber race
notes race

*We can also search notes with the notes search "string" command
notes search .u

************
*5.8 Formatting the display of variables
************
* Formatting data will be more common than you expect. It can be a pain when
* dealing with numbers in the millions or billions and you lack commas.

**
*Format numerics
**

* Let's get our survey data
use survey5, clear

* Let's list the first 5 observations for id and income
list id income in 1/5

*Let's look at the format of income.
describe income
* The format is %9.0g. We always have % in front of our format and g is a general 
* way of displaying incomes using a width of nine digits and decides for us the 
* best way to display the values. g means general here.

*%w.dg means general - find the best way to show the decimals
*Note: %#.#g will change the format to exponent if necessary
* %w.df means fixed - w is the width, d is the decimals, and f means fixed
* %w.dfc means fixed with commas - w is the width, d is the decimals, f means 
*                                 fixed, and c means comma
* %w.dgc means general with commas - w is the width, decimals will be decided,
*                                   g means general, and c means comma
* The manual is helpful for formatting: https://www.stata.com/manuals/dformat.pdf
*
* Examples fromat v1 %10.0g - Width of 10 digits and decimals will be decided
* Examples format v2 %4.1f - Show 3 digits in v3 and 1 decimal
* Examples format v3 %6.1fc - Show 4 digits plus the comma plus 1 digit

* Let's get more control over the income format and use the %w.df format. We want
* a total of 12 digits with 2 decimals places, which means we have 10 digits on
* the left side of the .
format income %12.2f
list income in 1/5
*Notice that we now can see observation #3's decimal places

* If we don't care to see the decimal place (even though it is still there).
format income %7.0f
list income in 1/5

* We we want to see one decimal place
format income %9.1f
list income in 1/5

* Now let's add commas, but we need to add two additional digit widths for the
* commas and we'll add two decimal places
format income %12.2fc
list income in 1/5

**
*Format Strings
**
* Let's turn to formating 
describe kidname
* The format is %10s, which is a (s)tring of 10 characters wide that is right-
* justified
list kidname

* If we wanted to left-justify the string, we can add a '-' in between % and #s.
format kidname %-10s
list kidname

**
*Format dates
**
* Dates in Stata are a bit of a pain, so learning how to format the dates will
* be helpful in the future.
list bdays kbdays

* Our birthdays are in a MM/DD/YYYY format currently
* lets generate a new variable with the date function
* The date function will convert a string that is in a date format into a
* Stata date, but it still needs to be formatted. The option "MDY" tells Stata
* that the string is in the Month-Day-Year format and needs to be converted.
generate bday = date(bdays, "MDY")
generate kbday = date(kbdays, "MDY")
* Let's list the days.
list bdays bday kbdays kbday
* The Stata dates are actually stored as the number of days from Jan 1, 1960
* which is convenient for the computer storing and performing date computations,
* but is difficult for us to read.

* Let's use the %td format - for example 01Jan2000
format bday %td 
format kbday %td
list bdays bday kbdays kbday

* Let's use the %tdNN/DD/YY format...NN is used for 01-12 and nn is for 1-12
*                                    Mon is Jan and Month is January
format bday %tdNN/DD/YY
list bdays bday kbdays kbday
format bday %tdMonth/DD/YY 
list bdays bday kbdays kbday

* We can use a standard Month DD, YYYY with the format %tdMonth_DD,CCYY
* Where Month is the full name of the month, DD is our days in digits, and 
* CC is Century, such as 19- and 20- and YY is 2-digit year, such as -88, -97
format bday %tdMonth_DD,CCYY
list bdays bday kbdays kbday

* Let's use a standard format, but don't use YYYY - it just repeats the 2-digit
* year twice
format bday %tdNN/DD/YYYY
list bdays bday kbdays kbday
* Use %tdNN/DD/CCYY
format bday %tdNN/DD/CCYY
list bdays bday kbdays kbday

label variable bday "Date of birth of student"
label variable kbdays "Date of birth of child"
drop bdays kbdays
* bday and bdays are redundent and we'll only keep one
drop bdays kbdays

save survey6, replace

************
*5.9 Changing the order of variables in a dataset
************
* I personally find reordering the order of variables to be useful. This is 
* especially true when working with panel data. I like to order the panel data
* to have the cross-sectional unit first, such as personal id, firm id, etc.
* first and then have the time period second, so we have our N and T next 
* to one another.

* Let's pull our survey of graduate students
use survey6, clear

* Describe our dataset
describe

* We might want to group our variables with similar types of variables. This
* can be helpful when you have a large dataset with hundreds of variables, such
* as the CPS.
order id gender race bday income havechild
describe
* The variables that we leave off will remain in the same order as before after
* the new variables are moved to the left.

* With the before option, we can move variable(s) before a defined variable
* Let's move kidname before ksex
order kidname, before(ksex)
describe

* We can move newly created variables with the before and after options with 
* the generate command
generate STUDENTVARS = ., before(gender)
generate KIDSVARS = ., after(havechild)
describe

******************
*Practice*
******************
* Let's bring in the CPS

* Generate a new variable from pemlr called employed where employed = 1 if 
* the individual is employed (present or absent) and employed = 0 if the 
* individual is unemployed. The value should be missing if the individual
* is not in the labor force

* Label the variable "Currently employed"

* Label the values for 0 "Not employed" 1 "Employed" . "Not in the Labor Force"

* Move the variable after pemlr

* Generate a date that appends hrmonth (month of interview), the string "12", 
* and the hryear4 (year of interview). We use 12 because the week of the 12th
* is the reference period 

* Now format the date so it is like 06/12/2023

