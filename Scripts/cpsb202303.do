
/*------------------------------------------------
  by Carla Tokman
  Please report errors to data@nber.rog
  THIS IS THE SAME AS cpsb202001.do, except for some additional notes
  reflecting some change of variables that are done in the raw file, 
  that are not modified in the uploaded version to keep them consistent
  with previous months.
  NOTE:  This program is distributed under the GNU GPL. 
  See end of this file and http://www.gnu.org/licenses/ for details.

----------------------------------------------- */

/* The following line should contain
   the complete path and name of the raw data file.
   On a PC, use backslashes in paths as in C:\  */   



/*------------------------------------------------

  All items, except those with one character, also can have values
  of -1, -2, or -3 even if the values are not in the documentation
  The meaning is
       -1 .Blank or not in universe
       -2 .Don't know
       -3 .Refused

  The following changes in variable names have been made, if necessary:
      '$' to 'd';            '-' to '_';              '%' to 'p';
      ($ = unedited data;     - = edited data;         % = allocated data)

  Decimal places have been made explict in the dictionary file.  
  Stata resolves a missing value of -1 / # of decimal places as a missing value.  
 -----------------------------------------------*/

** These note statements incorporate variable universes into the Stata data file.
*note: by Jean Roth, jroth@nber.org Fri May  8 12:28:03 EDT 2015
note hrmonth: U ALL HHLD's IN SAMPLE
note hryear4: U ALL HHLDs IN SAMPLE
note hurespli: U ALL HHLDs IN SAMPLE
note hufinal: OUTCOME CODES BETWEEN 001 AND 020 ARE FOR CATI. 
note hufinal: ALL OTHER OUTCOME CODES ARE FOR CAPI. 
*note huspnish: U ALL HHLDs IN SAMPLE
note hetenure: U HRINTSTA = 1 OR HUTYPB = 1-3
note hetenure: May be missing on the Basic CPS microdata files. This will be updated on later releases of the same month-s data.
note hehousut: U ALL HHLDs IN SAMPLE
note hetelhhd: U HRINTSTA = 1
note hetelavl: U HETELHHD = 2
note hephoneo: HETELHHD = 1 OR HETELAVL = 1
note hefaminc: COMBINED INCOME OF ALL FAMILY MEMBERS  DURING THE LAST 12 MONTHS.  INCLUDES MONEYFROM JOBS, NET INCOME FROM BUSINESS, FARM OR RENT, PENSIONS, DIVIDENDS, INTEREST, SOCIAL SECURITY PAYMENTS AND ANY OTHER MONEY INCOME RECEIVED BY FAMILY MEMBERS  WHO ARE 15 YEARS OF AGE OR OLDER.
note hefaminc: Edited beginning January 2010
note hefaminc: Caution should be used when using this variable since it has an allocation rate of approximately 20 percent.
note hwhhwgt: U HRINTSTA = 1 
note hwhhwgt: 4 implied dcimal places used for tallying household caracteristics
note hrintsta: U ALL HHLDs IN SAMPLE  
note hrnumhou: U ALL HHLDs IN SAMPLE
note hrhtype: U ALL HHLDs IN SAMPLE
note hrmis: U ALL HHLDs IN SAMPLE
note huinttyp: U ALL HHLDs IN SAMPLE
note huprscnt: U ALL HHLDs IN SAMPLE
note hrlonglk: U ALL HHLDs IN SAMPLE
note hrhhid2: U ALL HHLDs IN SAMPLE
note hrhhid2: Part 1 of this number is found in columns 1-15 of the record. Concatenate this item with Part 1 for matching.
note hrhhid2:The component parts of this number are as follows:
note hrhhid2: 71-72	Numeric component of the sample number (HRSAMPLE)
note hrhhid2: 73-74	Serial suffix-converted to numerics (HRSERSUF)
note hrhhid2: 75		Household Number (HUHHNUM)
note hwhhwtln: HRINTSTA = 1

note hubusl1: FOR HUBUS = 1
note hubusl2: See  BUSL1	
note hubusl3:See  BUSL1	
note hubusl4: See  BUSL1	
note gereg:  U ALL HHLD's IN SAMPLE
note gediv: U ALL HHLD's IN SAMPLE
note gestfips: U ALL HHLD's IN SAMPLE
note gtcbsa: U ALL HHLD's IN SAMPLE
note gtco: U ALL HHLD's IN SAMPLE
note gtco: THIS CODE MUST BE USED IN COMBINATION WITH A STATE CODE (GESTFIPS or GESTCEN) IN ORDER TO UNIQUELY IDENTIFY A COUNTY. ALSO, MOST COUNTIES ARE NOT IDENTIFIED (SEE GEOGRAPHIC ATTACHMENT).
note gtcbsast: U ALL HHLD's IN SAMPLE
note gtmetsta: U ALL HHLD's IN SAMPLE
note gtindvpc: U ALL HHLD's IN SAMPLE
note gtindvpc: WHENEVER POSSIBLE THIS CODE	IDENTIFIES SPECIFIC PRINCIPAL CITIES IN A METROPOLITAN AREA THAT HAS MULTIPLE PRINCIPAL CITIES.  THIS CODE MUST BE USED IN COMBINATION WITH THE CBSA FIPS CODE (GTCBSA) IN ORDER TO UNIQUELY IDENTIFY A SPECIFIC CITY.
note gtindvpc: see geographic documentation
note gtcbsasz: U ALL HHLD's IN SAMPLE
note gtcsa: U ALL HHLD's IN SAMPLE
note perrp:  U PRPERTYP = 1, 2, OR 3
*note peparent: U PRPERTYP = 1, 2, OR 3
note prtage: PRPERTYP = 1, 2, 0R 3
note prtfage: U PRPERTYP = 1, 2, 0R 3
note pemaritl: U PRTAGE >= 15
note pespouse:   U PEMARITL = 1
note pesex: U PRPERTYP = 1, 2, 0R 3
note peafever:U PRTAGE >=17
note peafnow: U PRPERTYP = 2 or 3
note peeduca: U PRPERTYP = 2 or 3
note ptdtrace: U PRPERTYP = 1, 2, 0R 3			
note prdthsp: U PEHSPNON = 1			


note prfamnum: U PRPERTYP = 1, 2, 0R 3
note prfamrel: U PRPERTYP = 1, 2, 0R 3
note prfamtyp: U PRPERTYP = 1, 2, 0R 3
note pehspnon: U PRPERTYP = 1, 2, 0R 3
note prmarsta: U PRPERTYP = 2, 0R 3
note prpertyp: U ALL HOUSEHOLD MEMBERS

note penatvty: U PRPERTYP = 1, 2, 0R 3
note pemntvty: U PRPERTYP = 1, 2, 0R 3
note pefntvty: U PRPERTYP = 1, 2, 0R 3
note prcitshp: U PRPERTYP = 1, 2, 0R 3
note prcitflg: U PRPERTYP = 1, 2, 0R 3
note prcitflg: Placed in this position because naming convention is different from all other allocation flags.

note prinusyr: PRCITSHP = 2, 3, 4, OR 5
note puslfprx: information collected by self or proxy responce
note pemlr: U PRPERTYP = 2

note peret1: U PEMLR = 5 AND (PURETOT = 1 OR 	(PUWK = 3 AND PRTAGE >= 50) OR (PUABS = 3 AND PRTAGE >= 50) OR (PULAY = 3 AND PRTAGE >= 50)) 


note peabsrsn: U PEMLR = 2
note peabspdo:  U PEABSRSN = 4-12, 14
note pemjot:  U PEMLR = 1, 2
note pemjnum: U PEMJOT = 1
note pehrusl1: U PEMJOT = 1 OR 2 AND PEMLR = 1 OR 2 
note pehrusl2: U PEMJOT = 1 AND PEMLR = 1 OR 2 
note pehrftpt: U PEHRUSL1 = -4 OR PEHRUSL2 = -4
note pehruslt: U PEMLR = 1 OR 2                              
note pehrwant: U PEMLR = 1 AND (PEHRUSLT = 0-34 PEHRFTPT = 2)
note pehrrsn1: U PEHRWANT = 1 (PEMLR = 1 AND PEHRUSLT < 35)
note pehrrsn2: U PEHRWANT = 2 (PEMLR = 1 AND PEHRUSLT < 35)                        
note pehrrsn3: U PEHRACTT = 1-34 AND PUHRCK7 NE 1, 2 (PEMLR = 1 AND PEHRUSLT = 35+)

note pehract1: U PEMLR = 1 
note pehract2: U PEMLR = 1 AND PEMJOT = 1
note pehractt: U PEMLR = 1
note pehravl: U PEHRACTT = 1-34 (PEMLR = 1 AND PEHRUSLT < 35 AND PEHRRSN1 = 1, 2, 3)

note pelayavl: U PEMLR = 3

note pelaylk: U PELAYAVL= 1, 2
note pelaydur:  U PELAYLK = 1, 2
note pelayfto:  PELAYDUR = 0-120


note pelkm1: U PEMLR = 4

note pelkavl: U PELKM1 = 1 - 13

note pelkll1o:U PELKAVL = 1-2
note pelkll2o: U PELKLL1O = 1 OR 3
note pelklwo: U PELKLL1O = 1 - 4
note pelkdur: U PELKLWO = 1 - 3
note pelkfto:  U PELKDUR = 0-120
note pedwwnto:U PUDWCK1 = 3, 4, -1
note pedwrsn: U PUDWCK4 = 4, -1
note pedwlko: U (PUDWCK4 = 1-3) or (PEDWRSN = 1-11)
note pedwwk: U PEDWLKO = 1
note pedw4wk: U PEDWWK = 1
note pedwlkwk: U PEDW4WK = 2
note pedwavl: U (PEDWWK = 2) or (PEDWLKWK = 1)
note pedwavr: U PEDWAVL = 2


note pejhwko: U HRMIS = 4 or 8 AND PEMLR = 5, 6, AND 7

note pejhrsn: U PEJHWKO = 1
note pejhwant: U (PEJHWKO = 2) or (PEJHRSN = 1-8)
 

note prabsrea: U PEMLR = 2
note prcivlf: U PEMLR = 1-7
note prdisc: U PRJOBSEA = 1-4
note premphrs: U PEMLR = 1-7
note prempnot: U PEMLR = 1-7
note prexplf: U PEMLR = 1-4 AND PELKLWO ne 3
note prftlf: U PEMLR = 1-4
note prhrusl: U PEMLR = 1-2
note prjobsea: U PRWNTJOB = 1
note prpthrs: U PEMLR = 1 AND PEHRACTT = 1-34
note prptrea:  U PEMLR = 1 AND (PEHRUSLT = 0-34 OR PEHRACTT = 1-34)
note prunedur: U PEMLR = 3-4
note pruntype: U PEMLR = 3-4
note prwksch: U PEMLR = 1 - 7
note prwkstat:  U PEMLR = 1 - 7
note prwntjob: U PEMLR = 5-7

note peio1cow: U (PEMLR = 1-3) OR (PEMLR = 4 AND PELKLWO = 1-2) OR (PEMLR = 5 AND (PENLFJH = 1 OR PEJHWKO = 1))OR (PEMLR = 6 AND PENLFJH = 1) OR(PEMLR = 7 AND (PENLFJH = 1 OR PEJHWKO = 1))

note peio2cow: PRIOELG = 1 and PEMJOT = 1 AND HRMIS = 4,8
note prioelg: PEMLR = 1-3, 	OR (PEMLR = 4 AND PELKLWO = 1 OR 2)	OR (PEMLR = 5 AND 	(PEJHWKO = 1 OR PENLFJH=1),	OR (PEMLR = 6 AND PENLFJH = 1),	OR PEMLR = 7 AND PEJHWKO = 1)
note pragna: U PRIOELG = 1 
note prcow1:  U PRIOELG = 1
note prcow2: PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note prcowpg: U PEIO1COW = 1 - 5
note prdtcow1: U PRIOELG = 1
note prdtcow2: PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note prdtind1: U PRIOELG = 1
note prdtind2: U PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note prdtocc1: U PRIOELG = 1
note prdtocc2: U PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note premp: U PEMLR = 1 OR 2 AND PTIO1OCD ne 403-407, 473-484
note prmjind1: U PRDTIND1 = 1-51
note prmjind2: U PRDTIND1 = 1-51	
note prmjocc1: U PRDTOCC1 = 1-23
note prmjocc2: U PRDTOCC1 = 1-23
note prmjocgr: U PRMJOCC = 1-11
note prnagpws: U PRCOW1 = 1 AND PEIO1ICD ne 0170 - 0890
note prnagws: U PEMLR = 1-4 	AND PRCOW = 1-4 	AND PEIO1ICD ne 0170-0290
note prsjms: U PEMLR = 1 OR 2
note prerelg: U PEMLR = 1-2 AND HRMIS = 4 OR 8
note peernuot: U PRERELG = 1
note peernper: U PRERELG = 1
note peernrt: U PEERNPER = 2-7
note peernhry: U PRERELG = 1

note pternh2: U PEERNRT = 1
note pternh1o: U PEERNPER = 1
note pternhly: U PEERNPER = 1 OR PEERNRT = 1

note peernhro: U PEERNH1O = ENTRY
note pternwa: U PRERELG = 1

note ptern: UPEERNUOT = 1 AND PEERNPER = 1 


note peernwkp: U PEERNPER = 6 
note peernlab: U (PEIO1COW = 1-5 AND PEMLR = 1-2  AND HRMIS = 4, 8)

note peerncov: U (PEIO1COW = 1-5 AND PEMLR = 1-2 AND HRMIS = 4, 8)
note penlfjh:  U HRMIS = 4 OR 8 AND PEMLR = 3-7
note penlfret: U PRTAGE = 50+ AND PEMLR = 3-7
note penlfact: U (PRTAGE = 14-49) or (PENLFRET = 2)

note peschenr: U PRPERTYP = 2 and PRTAGE = 16-54
note peschft: U PESCHLVL = 1, 2
note peschlvl: U PESCHENR = 1
note prnlfsch: U PENLFACT = -1 OR 1-6 AND PRTAGE = 16-24
note pwfmwgt: U PRPERTYP = 1-3
note pwlgwgt: U PRPERTYP = 2
note pworwgt: U PRPERTYP = 2
note pwsswgt: U PRPERTYP = 1-3
note pwvetwgt: U PRPERTYP = 2
note prchld: U PRFAMREL = 1 or 2
note prnmchld: U PRFAMREL = 1 or 2

note prwernal: U PRERELG = 1
note prhernal: U PRERNHRY = 1

note pedipged: U PEEDUCA = 39
note pehgcomp: U PEDIPGED = 2
note pecyc: U PEEDUCA =40-42

note pwcmpwgt: U PRPERTYP = 2 AND PRTAGE = 16+
note peio1icd: U (PEMLR = 1-3) 	OR (PEMLR = 4 AND PELKLWO = 1-2) 	OR (PEMLR = 5 AND (PENLFJH = 1 OR 	PEJHWKO = 1))	OR (PEMLR = 6 AND PENLFJH = 1) 	OR (PEMLR = 7 AND PEJHWKO=1)
note ptio1ocd: U (PEMLR = 1-3) 	OR  (PEMLR = 4 AND PELKLWO = 1-2)	OR (PEMLR = 5 AND (PENLFJH = 1 OR	PEJHWKO = 1)) 	OR (PEMLR = 6 AND PENLFJH = 1) 	OR (PEMLR = 7 AND PEJHWKO = 1)
note peio2icd: U PEMJOT = 1 AND HRMIS = 4 OR 8 
note ptio2ocd: U PEMJOT = 1 AND HRMIS = 4 OR 8
note primind1: U PRIOELG = 1
note primind2: U PRIOELG = 1 AND PEMJOT = 1 AND HRMIS = 4 OR 8
note peafwhn1: U PEAFEVER = 1
note peafwhn2: U PEAFEVER = 1
note peafwhn3: U PEAFEVER = 1
note peafwhn4: U PEAFEVER = 1

note pepar2: U ALL
note pepar1: U ALL
note pepar2typ: U ALL
note pepar1typ: U ALL
note pecohab: U ALL

note pedisear: U PRPERTYP = 2
note pediseye: U PRPERTYP = 2
note pedisrem: U PRPERTYP = 2
note pedisphy: U PRPERTYP = 2
note pedisdrs: U PRPERTYP = 2
note pedisout: U PRPERTYP = 2
note prdisflg: PEDISEAR OR PEDISEYE OR PEDISREM, PEDISPHY OR PEDISDRS OR PEDISOUT = 1


note prdasian: U PTDTRACE = 4
note pepdemp1:  U HRMIS = 3 or 4 and  PEIO1COW = 6 or 7
note ptnmemp1: U  PEPDEMP1 = 1
note pepdemp2: U HRMIS = 3 or 4 and  PEIO1COW = 6 or 7
note ptnmemp2: U PEPDEMP1 = 1
note pecert1: U PROPERTYP = 2
note pecert2: U PECERT1 = 1
note pecert3: U PECERT2 = 1

note ptio1ocd: changed from peio1ocd in march 2020
note ptio2ocd: changed from peio2ocd in march 2020
note pternhly: changed from prernhly in march 2020
note pternwa: changed from prernwa in march 2020
note ptern2: changed from puern2 in march 2020
note pternh1c: changed from puernh1c in march 2020

do cpsb202303_labels
do cpsb202303_labels_geo
do cpsb202303_labels_indocc

* These are the labels indocc but are not running 
label values peio1cow peio1cow
label values peio2cow peio1cow
label values puio2mfg puio1mfg
label values puio1mfg puio1mfg
label values puiock1  puiock1l
label values puiock2  puiock2l
label values puiock3  puiock3l
label values prioelg  prioelg
label values pragna   pragna
label values prcow1   prcow1l
label values prcow2   prcow1l
label values prcowpg  prcowpg
label values prdtcow1 prdtcowa
label values prdtcow2 prdtcowa
label values prdtind1 prdtinda
label values prdtind2 prdtinda
label values prdtocc1 prdtocca
label values prdtocc2 prdtocca
label values prmjind1 prmjinda
label values prmjind2 prmjinda
label values prmjocc1 prmjocca
label values prmjocc2 prmjocca
label values prmjocgr prmjocgr

label values primind2 priminda
label values primind1 priminda
label values peio1icd peio1icd
label values peio2icd peio1icd
label values ptio2ocd ptio1ocd
label values ptio1ocd ptio1ocd



/* The Following  have no notes: No Universe or labels: 
Mostly Flags with the exception of PERP, PADDING
'PERRP', 'PADDING', 'PXPDEMP1', 'HXHOUSUT', 'HXTELHHD', 
'HXTELAVL', 'HXPHONEO', 'PXINUSYR', 'PXRRP', 'PXPARENT', 'PXAGE', 'PXMARITL', 
'PXSPOUSE', 'PXSEX', 'PXAFWHN1', 'PXAFNOW', 'PXEDUCA', 'PXRACE1', 'PXNATVTY',
'PXMNTVTY', 'PXFNTVTY', 'PXNMEMP1', 'PXHSPNON', 'PXMLR', 'PXRET1', 'PXABSRSN', 
'PXABSPDO', 'PXMJOT', 'PXMJNUM', 'PXHRUSL1', 'PXHRUSL2', 'PXHRFTPT', 'PXHRUSLT',
'PXHRWANT', 'PXHRRSN1', 'PXHRRSN2', 'PXHRACT1', 'PXHRACT2', 'PXHRACTT', 'PXHRRSN3',
'PXHRAVL', 'PXLAYAVL', 'PXLAYLK', 'PXLAYDUR', 'PXLAYFTO', 'PXLKM1', 'PXLKAVL', 
'PXLKLL1O', 'PXLKLL2O', 'PXLKLWO', 'PXLKDUR', 'PXLKFTO', 'PXDWWNTO', 'PXDWRSN', 
'PXDWLKO', 'PXDWWK', 'PXDW4WK', 'PXDWLKWK', 'PXDWAVL', 'PXDWAVR', 'PXJHWKO', 
'PXJHRSN', 'PXJHWANT', 'PXIO1COW', 'PXIO1ICD', 'PXIO1OCD', 'PXIO2COW', 
'PXIO2ICD', 'PXIO2OCD', 'PXERNUOT', 'PXERNPER', 'PXERNH1O', 'PXERNHRO', 
'PXERN', 'PXPDEMP2', 'PXNMEMP2', 'PXERNWKP', 'PXERNRT', 'PXERNHRY', 
'PXERNH2', 'PXERNLAB', 'PXERNCOV', 'PXNLFJH', 'PXNLFRET', 'PXNLFACT', 
'PXSCHENR', 'PXSCHFT', 'PXSCHLVL', 'PXDIPGED', 'PXHGCOMP', 'PXCYC', 'PXAFEVER', 
'PXPAR2', 'PXPAR1', 'PXPAR2TYP', 'PXPAR1TYP', 'PXCOHAB', 'PXDISEAR', 'PXDISEYE', 'PXDISREM', 
'PXDISPHY', 'PXDISDRS', 'PXDISOUT', 'HXFAMINC', 'PXCERT1', 'PXCERT2', 'PXCERT3'*/
/*
Copyright 2015 shared by the National Bureau of Economic Research and Jean Roth

National Bureau of Economic Research.
1050 Massachusetts Avenue
Cambridge, MA 02138
jroth@nber.org

This program and all programs referenced in it are free software. You
can redistribute the program or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
USA.
*/
