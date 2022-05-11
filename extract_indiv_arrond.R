#### Extract Individuals #######

## Packages ##
library(readr)
library(forcats)
library(data.table)

setwd("/Users/claudegrasland1/git/Benin")
# Load dataset
myFile<-"rp2013/INSAE_RGPH4_2013.dat"
t1<-Sys.time()
fic <- read_lines(myFile,skip=0,n_max = 20000000)

# Divide dataset by record type
rec<-substr(fic,1,1)
#fic1<-fic[rec==1]
fic2<-fic[rec==2]
#fic3<-fic[rec==3]
#fic4<-fic[rec==4]
#fic5<-fic[rec==5]


# Geocodes
codage<-read.table("rp2013/code_loc.csv",sep=";",header=T, encoding = "UTF-8",colClasses = "character")
codes<-codage$CODE
names(codes)<-codage$NAME
codes



## Empty file
length(fic2)
test<-data.frame(code=1:length(fic2),rec=fic2)

test$typemen<-substr(test$rec,14,14)
table(test$typemen)

test$dep<-substr(test$rec,2,3)
test$dep_name<-as.factor(test$dep)
levels(test$dep_name) <-c("ALIBORI",
                          "ATACORA",
                          "ATLANTIQUE",
                          "BORGOU",
                          "COLLINES",
                          "COUFFO",
                          "DONGA",
                          "LITTORAL",
                          "MONO",
                          "OUEME",
                          "PLATEAU",
                          "ZOU")
test$com<-substr(test$rec,2,4)
test$com_name<-fct_recode(as.factor(test$com), !!!codes)
test$arr<-substr(test$rec,2,6)

test$com_nais<-substr(test$rec,29,31)
test$com_nais_name<-fct_recode(as.factor(test$com_nais), !!!codes)
test$com_nais[test$com_nais==998]<-NA
test$com_nais[test$com_nais==999]<-NA

test$dat_nais<-as.numeric(substr(test$rec,23,26))
test$dat_nais[test$dat_nais==9998]<-NA

test$com_ant<-substr(test$rec,44,46)
test$com_ant_name<-fct_recode(as.factor(test$lcom_ant), !!!codes)
test$com_ant[test$com_ant==998]<-NA
test$com_ant[test$com_ant==999]<-NA

test$dat_mig<-as.numeric(substr(test$rec,47,48))
test$dat_mig[test$dat_mig !=98]<-2013-test$dat_mig[test$dat_mig !=98]
test$dat_mig[test$dat_mig ==98]<-NA

test$chef<-as.factor(substr(test$rec,17,18)=="01")
levels(test$chef)<-c("N","O")

test$sexe<-as.factor(substr(test$rec,20,20))
levels(test$sexe)<-c("M","F")

test$resid<-as.factor(substr(test$rec,43,43))
levels(test$resid) <-c("Présent","Absent","Visiteur")

test$ethnie<-as.factor(substr(test$rec,33,35))

test$langue<-as.factor(substr(test$rec,51,53))

test$etude<-as.factor(substr(test$rec,55,56))
levels(test$etude)<-c(NA,"Maternel",
"CI",
"CP",
"CE1",
"CE2",
"CM1",
"CM2",
"6ème",
"5ème",
"4ème",
"3ème",
"2nd",
"1ère",
"Tle",
"1ère année",
"2ème  année",
"3ème année",
"2nd technique",
"1ère technique",
"Tle technique",
"BAC+1",
"BAC+2",
"BAC+3",
"BAC+4",
"BAC+5",
"BAC+6",
"BAC+7",
"Sup à BAC+7",
"Ecole coranique",
"Ecole biblique",
"Non précisé")
table(test$etude)



test$matrim <-as.factor(substr(test$rec,67,67))
levels(test$matrim)<-c("Célibataire",
"Mariage monogamique",
"Polygamique à 2 femmes",
"Polygamique à 3 femmes",
"Polygamique à 4 femmes",
"Divorcé(e)",
"Veuf(ve)",
"Séparé(e)",
"Union libre",
NA)

### Save
test<-test[,-c(1:2)]
saveRDS(test,"rp2013/indiv_arond.RDS")


dt<-data.table(test)

x<-dt[,.(sum=.N),.(dep,dep_name,com,com_name,arr)]

write.table(x,"data/arrond/code_arrond.csv",sep=";", row.name=F)
