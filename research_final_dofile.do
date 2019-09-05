
***Keep necessary variables***
keep GB2 GBC5 GBC26 GBC27 GB33 GBC12a GBC12b GBC12c GBC12d z7a z1 z5 GB7a GB7b GB7c GB7e GB7f GB7h GB7g ccode resno z13
 
***DV: Trust in institutions***
tab GB7a
tab GB7b
tab GB7c
tab GB7e
tab GB7f
tab GB7h
tab GB7g
***Drop non-sensical values of Likert-scale***
gen prez = GB7a if GB7a >=1 & GB7a<=4
tab prez
gen pm = GB7b if GB7b >=1 & GB7b<=4
tab pm
gen natlgov = GB7c if GB7c >=1 & GB7c<=4
tab natlgov
gen par = GB7e if GB7e >=1 & GB7e<=4
tab par
gen localgovt = GB7f if GB7f >=1 & GB7f<=4
tab localgovt
gen civil = GB7h if GB7h >=1 & GB7h<=4
tab civil
gen pol = GB7g if GB7g >=1 & GB7g<=4
tab pol

***Reverse the direction in such a way that higher value means higher positive attitude***
revrs prez
tab revprez 
revrs pm
tab revpm 
revrs natlgov
tab revnatlgov 
revrs par
tab revpar 
revrs localgovt
tab revlocalgovt 
revrs civil
tab revcivil
revrs pol
tab revpol 


***Recode from 0 to 1 for convenience***
replace prez=((revprez-1)/3) 
tab prez 
replace pm=((revpm-1)/3) 
tab pm 
replace natlgov=((revnatlgov-1)/3) 
tab natlgov 
replace par=((revpar-1)/3) 
tab par
replace localgovt=((revlocalgovt-1)/3) 
tab localgovt
replace civil=((revcivil-1)/3) 
tab civil 
replace pol=((revpol-1)/3) 
tab pol

***Additive Scale: DV***
egen TrustInstitutions = rowmean(prez pm natlgov par localgovt civil pol)
tab TrustInstitutions


***Independent Variables***

***Perception about economic condition of oneself***
tab GBC5
gen EconSelf = GBC5 if GBC5>=1 & GBC5<=5
tab EconSelf
revrs EconSelf 
tab revEconSelf 

***Recode 0 to 1***
replace EconSelf=((revEconSelf-1)/4) 
tab EconSelf 
***Higher values are higher positive attitudes***

***Perception about economic condition of country***
tab GB2
gen EconCountry = GB2 if GB2>=1 & GB2<=5
tab EconCountry
revrs EconCountry
tab revEconCountry 

***Recode 0 to 1***
replace EconCountry=((revEconCountry-1)/4) 
tab EconCountry 

*** Controls***

***Satisfaction with democracy***
tab GBC26
gen Democracy = GBC26 if GBC26>=1 & GBC26<=4
tab Democracy
revrs Democracy
tab revDemocracy
***Recode 0 to 1***
replace Democracy=((revDemocracy-1)/3) 
tab Democracy 

***Satisfaction with current government during the survey***
tab GBC27
gen GovtSatis = GBC27 if GBC27>=1 & GBC27<=4
tab GovtSatis
revrs GovtSatis
tab revGovtSatis
***Recode 0 to 1***
replace GovtSatis=((revGovtSatis-1)/3) 
tab GovtSatis 

***Personally witnessed act of corruption***
tab GB33
gen Witness_corruption = GB33 if GB33 >=1 & GB33 <=2
tab Witness_corruption 

***Create dichotomous variable, Yes=1, No=2/ Make Yes=1 and No=0***
recode Witness_corruption (2=0) (1=1)
tab Witness_corruption

***Difficulty in getting public service***
tab GBC12a 
gen publicservice1= GBC12a if GBC12a>=1 & GBC12a <=4
tab publicservice1
***Recode 0 to 1***
replace publicservice1=((publicservice1-1)/3) 
tab publicservice1

tab GBC12b 
gen publicservice2= GBC12b if GBC12b>=1 & GBC12b <=4
tab publicservice2
***Recode 0 to 1***
replace publicservice2=((publicservice2-1)/3) 
tab publicservice2

tab GBC12c 
gen publicservice3= GBC12c if GBC12c>=1 & GBC12c <=4
tab publicservice3
***Recode 0 to 1***
replace publicservice3=((publicservice3-1)/3) 
tab publicservice3

tab GBC12d 
gen publicservice4= GBC12d if GBC12d>=1 & GBC12d <=4
tab publicservice4
***Recode 0 to 1***
replace publicservice4=((publicservice4-1)/3) 
tab publicservice4

***Higher value means positive attitude, so no need to reverse here***
egen publicservice= rowmean(publicservice1 publicservice2 publicservice3 publicservice4)
tab publicservice 

***Age(Recode 95 for 95 years or age above that)/age from 16-95/***
tab z1
replace z1=95 if z1 >=95 
tab z1
gen age=z1
tab age 

***Also generate age squared***


***Gender/Here male=1 and female=2/ let us recode in such a way that male=0 and female=1***
tab z5
tab z5, nolabel
gen gender=.
recode gender .=0 if z5 == 1
recode gender .=1 if z5 == 2
tab gender


***Eduation(Merged noeducation/no-literate and 'can read and write but no formal education')***
tab z7a
replace z7a=0 if z7a==0|z7a==20
tab z7a
tab z7a, nolabel
gen education=z7a if z7a>=0 & z7a<=17 
tab education
***17 is the professional degree/16 is post-graduation--MA, MSc, MCom***


***Locality: 1 village, 2 town 3 city 4 bigcity***
tab z13
gen locality=z13 if z13>=1 & z13<=4
tab locality 
***Recode from 0 to 1***
replace locality=((locality-1)/3) 
tab locality 



***Final regression***
***Let us drop government satisfaction as Nepal does not have its data***

***Heteroskedasticity test***
quietly reg TrustInstitutions EconSelf EconCountry Democracy GovtSatis Witness_corruption publicservice age education gender locality
estat hettest 
***There is problem of heteroskedasticity as p vaue less than 0.05 and hence, significant/so can reject null/null assumes homoskedasticity***
reg TrustInstitutions EconSelf EconCountry Democracy GovtSatis Witness_corruption publicservice age education gender locality, robust 

***Multicollinearity test*** 
quietly reg TrustInstitutions EconSelf EconCountry Democracy GovtSatis Witness_corruption publicservice age education gender locality 
estat vif
***No problem of multicollinearity as VIF is less than 5 for each IV***

***Check if the model is correctly specified***
quietly reg TrustInstitutions EconSelf EconCountry Democracy GovtSatis Witness_corruption publicservice age education gender locality 
linktest 



***Equation 1: only countries dummies/Bangladesh omitted category***
reg TrustInstitutions i.ccode 
outreg2 using SouthAsia.doc, replace dec(3) 

***Equation 2: Economic situation included***
reg TrustInstitutions i.ccode EconSelf EconCountry 
outreg2 using SouthAsia.doc, append dec(3) 

***Equation 3: Interaction with govt. included****
reg TrustInstitutions i.ccode EconSelf EconCountry Democracy Witness_corruption publicservice 
outreg2 using SouthAsia.doc, append dec(3) 

***Equation 4: Demographics included***
reg TrustInstitutions i.ccode EconSelf EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender locality 
outreg2 using SouthAsia.doc, append dec(3) 






***Rough***
***Regression, interaction and marginsplot***
***Two models***
***First Model***
reg TrustInstitutions EconSelf EconCountry Democracy GovtSatis Witness_corruption publicservice c.age##c.age education gender 
outreg2 using regressionresultsfinal.doc, replace dec(3) 

***Second Model***
***Interaction***
reg TrustInstitutions c.EconSelf##c.EconCountry Democracy GovtSatis Witness_corruption publicservice c.age##c.age education gender
margins, at(EconSelf=(0 (.25) 1) EconCountry=(0 (.25) 1))
marginsplot
outreg2 using regressioninteractionfinal.doc, replace dec(3)

***Create dummies***
***Note: Nepal does not have data on government satisfaction, so it created dummies for four countries only/Bangladesh is the omitted category***
reg TrustInstitutions i.ccode EconSelf EconCountry Democracy GovtSatis Witness_corruption publicservice c.age##c.age education gender 
outreg2 using regressiondummiesWOnepal.doc, replace dec(3)

***Govt satisfaction dropped/creating dummies including Nepal***
reg TrustInstitutions i.ccode EconSelf EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender 
outreg2 using regressiondummiesWnepal.doc, replace dec(3)

***Trust in institutions for just the countries/Bangladesh ommitted category***
reg TrustInstitutions i.ccode 

***Extras***
***Equation 5: Interaction: Let's exclude this***
reg TrustInstitutions c.EconSelf##c.EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender 
outreg2 using interaction.doc, replace dec(3) 

***Equation 6: Individual country/IVs' effect on DV 
reg TrustInstitutions EconSelf EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender  if ccode==1
outreg2 using individualcountry.doc, replace dec(3) 
reg TrustInstitutions EconSelf EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender  if ccode==2
outreg2 using individualcountry.doc, append dec(3)
reg TrustInstitutions EconSelf EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender  if ccode==4
outreg2 using individualcountry.doc, append dec(3)
reg TrustInstitutions EconSelf EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender if ccode==5
outreg2 using individualcountry.doc, append dec(3)
reg TrustInstitutions EconSelf EconCountry Democracy Witness_corruption publicservice c.age##c.age education gender  if ccode==6
outreg2 using individualcountry.doc, append dec(3)


