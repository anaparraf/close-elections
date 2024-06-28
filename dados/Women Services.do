***getting an "observation" for every municipality, not just the ones that have services"
use "E:\RawData\Muni_Info\munimaster.dta", clear
drop statemuni
gen statemuni=stateabr+munnome 
keep statemuni municode munnome
sort statemuni
tempfile statemuni
save `statemuni', replace

***getting an "observation" for every municipality, not just the ones that have services"
use "E:\RawData\Muni_Info\munimaster.dta", clear
keep municode 
foreach x of numlist 1998(1)2011 {
gen o`x'=0
}
reshape long o, i(municode) j(year)
drop o
tostring municode year, replace
gen muniyear=municode+year
destring muniyear, replace
drop municode year
sort muniyear
tempfile allmuniyears
save `allmuniyears', replace



****tidying up our data from the internet
clear
insheet using "E:\RawData\womens_services\Delegacias-dates from internet.csv" 

keep municipalcode year sourcelink sourcelinkalt stateabr municpio yearalt nomedaentidade endereo cep telefone fax email site
gen municode=regexr(municipalcode,"[.\}\)\*a-zA-Z]+","")
replace municode="" if municode=="://www.ijsn.es.gov.br/attachments/222_ViolenciacontraMulher.pdf"
replace municode="" if municode=="://www.pc.mg.gov.br/internas/legislacao/iLegislacao.php"
replace municode="" if municode=="://www.cultura.ma.gov.br/portal/sede/arquivos/DO-02-08-2004.pdf"
replace municode="" if municode=="/"
destring municode, replace
drop if sourcelink=="rogerio's list"
drop municipalcode
drop if municode==.

***Some have contradictory years as to when they were founded
destring yearalt, ignore("regiao-1&Itemid=107") replace
expand 2 if year!=. & yearalt<year, gen(altsource)
replace year=yearalt if year!=. & yearalt<year & altsource==1
replace sourcelink=sourcelinkalt if year!=. & yearalt<year
drop yearalt

***Some have more than one deam founded in a year
duplicates tag municode year, gen(NumberOfDeams)
sort year
duplicates drop municode year, force 
replace NumberOfDeams=NumberOfDeams+1

tostring municode, replace
gen hey=substr(municode,1,6)
drop municode
rename hey municode
destring municode, replace
sort municode

save "E:\RawData\womens_services\DeamsInternet.dta", replace 

***Tidying up our info from Secretaria da Mulher list
clear
insheet using "E:\RawData\womens_services\Inaugura��es from Rogerio.csv", names
replace anodeinaugurao="2011" if anodeinaugurao=="Segunda-feira, 19 de Setembro de 2011 "
replace anodeinaugurao="2010" if anodeinaugurao=="25/10/2010"
destring anodeinaugurao, replace
drop if anodeinaugurao==.
gen sourcelink="Rogerio's List"
gen altsource=2 //for later when we merge so we know where its from
rename v5 clarification
drop v*
replace municpio="Rio de Janeiro" if clarification=="in Rio"
drop clarification
replace municpio="Bras�lia" if uf=="DF"
replace municpio="S�o Paulo" if municpio=="S�O PAULO"
replace municpio="Guarulhos" if municpio=="Guarlhos"
replace municpio="Tr�s Lagoas" if municpio=="Tr�s Lagoas - MS"
replace municpio="Paragominas" if municpio=="Paragominas - PA"
replace municpio="Mogi Gua�u" if municpio=="Mogi-Gua�u"
replace municpio="Moji Mirim" if municpio=="Mogi-Mirim"
replace municpio="Recife" if municpio=="RECIFE"
replace municpio="Ji-Paran�" if municpio=="Ji-Paran� - RO"
replace municpio="Florian�polis" if municpio=="FLORIAN�POLIS"
replace municpio="Piraciaba" if municpio=="PIRACICABA"
replace municpio="Aparecida de Goi�nia" if municpio=="Aparecida de Goi�nia - GO"
replace municpio="Lucas do Rio Verde" if municpio=="Lucas do Rio VE"
replace municpio="Maracana�" if municpio=="Maracanau"
replace municpio="Pinheiro" if municpio=="Pinheiros"
replace municpio="S�o Jo�o do Soter" if municpio=="S�o Jo�o do S�ter"
replace municpio="S�o Lu�s" if municpio=="S�o Luis"
replace municpio="Rio das Ostras" if municpio=="Rio das Ostra"
replace municpio="Aracaju" if municpio=="Aracaj�"
replace municpio="Mongagu�" if municpio=="Monguagu�"
replace municpio="Piracicaba" if municpio=="Piraciaba"
replace municpio="Salvador" if municpio=="Loreta Valadares"
gen statemuni=uf+municpio
replace statemuni="RRS�o Luiz" if statemuni=="RRS�o Lu�s do Anau�"
replace statemuni="ESCachoeiro de Itapemirim" if statemuni=="ESCachoeiro do Itapemirim"
replace statemuni="ESCachoeiro de Itapemirim" if statemuni=="MGCachoeiro de Itapamerim"
replace municpio="S�o Luiz" if statemuni=="RRS�o Lu�s do Anau�"
sort statemuni
merge m:1 statemuni using `statemuni'
drop if _merge==2
drop _merge

replace tipode="CRAM" if tipode=="1.����� Centros Especializados de Atendimento � Mulher em situa��o de Viol�ncia"
replace tipode="NDefensorias" if tipode=="17.�� N�cleos/Defens�rias Especializados de Atendimento � Mulher"
replace tipode="Varas" if tipode=="37.�� Varas Adaptadas de Viol�ncia Dom�stica e Familiar"
replace tipode="Deams" if tipode=="6.����� DEAM - Delegacias Especializadas de Atendimento � Mulher"
replace tipode="PromoN" if tipode=="27.�� Promotorias Especializadas/N�cleos de G�nero do MP"
replace tipode="SAbrigos" if tipode=="28.�� Servi�os de Abrigamento"
replace tipode="Juizados" if tipode=="24 Juizados de Viol�ncia Dom�stica e Familiar contra a Mulher"



***Making muni-year observations for each type of service
levelsof tipodeservio, local(levels)
foreach l of local levels {
preserve
keep if tipodeservio=="`l'"
drop tipodeservio
duplicates tag municode anodeinaugurao, gen(NumberOf`l')
duplicates drop municode anodeinaugurao NumberOf`l', force
replace NumberOf`l'=NumberOf`l'+1
tostring municode anodeinaugurao, replace
gen muninaug=municode+anodeinaugurao
destring muninaug municode anodeinaugurao, replace 
foreach x of numlist 1998(1)2011 {
gen o`x'=0
replace o`x'=NumberOf`l' if anodeinaugurao<=`x'
}
reshape long o, i(muninaug) j(year)
tostring municode year, replace
gen muniyear=municode+year
destring muniyear municode year, replace 
bys muniyear: egen Total`l'=sum(o)
drop o NumberOf`l'
rename Total`l' NumberOf`l'
duplicates drop NumberOf`l' muniyear, force
gen Exist`l'=(NumberOf`l'>0)
keep muniyear NumberOf`l' Exist`l'
label var NumberOf`l' "Number of `l' that exist (Secretaria da Mulher)"
label var Exist`l' "`l' exist (Secretaria da Mulher)"
sort muniyear

merge muniyear using `allmuniyears'
assert _merge~=1
drop _merge
replace NumberOf`l'=0 if NumberOf`l'==.
replace Exist`l'=0 if Exist`l'==.
sort muniyear
tempfile SecDaMulherYr`l'
save "`SecDaMulherYr`l''", replace
restore
}



****Getting Deam existance in each year from the internet source
use "E:\RawData\womens_services\DeamsInternet.dta", clear 
replace year=2004 if year==24
replace year=2003 if year==23
replace year=2005 if year==25
replace year=1999 if year==99
replace year=1986 if year==986
replace year=1987 if year==87
drop if year==.
rename year anodeinaugurao
keep municode anodeinaugurao
duplicates tag municode anodeinaugurao, gen(NumberOfInternetDeams)
duplicates drop municode anodeinaugurao NumberOfInternetDeams, force
replace NumberOfInternetDeams=NumberOfInternetDeams+1
tostring municode anodeinaugurao, replace
gen muninaug=municode+anodeinaugurao
destring muninaug municode anodeinaugurao, replace 
foreach x of numlist 1998(1)2011 {
gen o`x'=0
replace o`x'=NumberOfInternetDeams if anodeinaugurao<=`x'
}
reshape long o, i(muninaug) j(year)
tostring municode year, replace
gen muniyear=municode+year
destring muniyear municode year, replace 
bys muniyear: egen TotalInternetDeams=sum(o)
drop o NumberOfInternetDeams
rename TotalInternetDeams NumberOfInternetDeams
duplicates drop NumberOfInternetDeams muniyear, force
gen ExistInternetDeams=(NumberOfInternetDeams>0)
keep muniyear NumberOfInternetDeams ExistInternetDeams
label var NumberOfInternetDeams "Number of DEAMs that exist (Internet)"
label var ExistInternetDeams "A DEAM exists (Internet)"
sort muniyear
merge muniyear using `SecDaMulherYrDeams'
assert _merge~=1
drop _merge
replace NumberOfInternetDeams=0 if NumberOfInternetDeams==.
replace ExistInternetDeams=0 if ExistInternetDeams==.
gen ExistSecInt=(ExistInternetDeams>0 | ExistDeams >0)
label var ExistSecInt "Secretaria da Mulher or Internet Sources indicates DEAM Exists"
foreach l in CRAM NDefensorias Varas Deams PromoN SAbrigos Juizados{
sort muniyear
merge muniyear using "`SecDaMulherYr`l''"
drop _merge 
}

label var NumberOfNDefensorias "Number of Nucleos Defensorias that exist (Secretaria da Mulher)"
label var ExistNDefensorias "Nucleos Defensorias exist (Secretaria da Mulher)"
label var NumberOfPromoN "Number of Promotorias Nucleos that exist (Secretaria da Mulher)"
label var ExistPromoN "Promotorias Nucleos exist (Secretaria da Mulher)"
label var NumberOfSAbrigos "Number of Servicos Abrigos that exist (Secretaria da Mulher)"
label var ExistSAbrigos "Servicos Abrigos exist (Secretaria da Mulher)"


sort muniyear
save $NewDataIntermediate\womenservices.dta, replace
