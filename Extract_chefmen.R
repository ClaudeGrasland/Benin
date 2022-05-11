#### Extract Individuals #######

## Packages ##
library(readr)
library(forcats)
library(data.table)


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
codes<-codage$NAME
names(codes)<-codage$CODE

# Multilevel dataset

## Empty file
length(fic2)
z<-data.frame(code=1:length(fic2),rec=fic2)

test<-z

test$loc1<-substr(test$rec,29,31)
test$loc1_name<-recode_factor(as.factor(test$loc1), !!!codes)
test$loc1[test$loc1==998]<-NA
test$loc1[test$loc1==999]<-NA

test$dat1<-as.numeric(substr(test$rec,23,26))
test$dat1[test$dat1==9998]<-NA

test$loc2<-substr(test$rec,44,46)
test$loc2_name<-recode_factor(as.factor(test$loc2), !!!codes)
test$loc2[test$loc2==998]<-NA
test$loc2[test$loc2==999]<-NA

test$dat2<-as.numeric(substr(test$rec,47,48))
test$dat2[test$dat2 !=98]<-2013-test$dat2[test$dat2 !=98]
test$dat2[test$dat2 ==98]<-NA

test$loc3<-substr(test$rec,2,4)
test$loc3_name<-recode_factor(as.factor(test$loc3), !!!codes)
test$dat3<-2013

test$mob12<-as.numeric(test$loc1!=test$loc2)
test$mob23<-as.numeric(test$loc2!=test$loc3)
test$mob13<-as.numeric(test$loc1!=test$loc3)

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
saveRDS(dt,"rp2013/indiv.RDS")




### Filter head of households
dt<-data.table(test)
dt<-data.table(dt)
dt3<-dt[chef=="O"][as.numeric(loc1)<150][substr(loc1,3,3)!=0][substr(loc2,3,3)!=0][dat1<3000][dat1<1998]
saveRDS(dt3,"rp2013/chefmen.RDS")

### Samp
samp<-dt3[sample(nrow(dt3), 5000), ]
saveRDS(samp,"rp2013/chefmen_5000.RDS")
write.table(samp,"rp2013/chefmen_5000.csv",row.names = F,quote = TRUE,sep=";",
            fileEncoding = "UTF-8")
