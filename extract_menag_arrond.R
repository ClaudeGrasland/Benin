#### Extract Households #######

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
#fic2<-fic[rec==2]
#fic3<-fic[rec==3]
#fic4<-fic[rec==4]
fic5<-fic[rec==5]



# Geocodes
codage<-read.table("rp2013/code_loc.csv",sep=";",header=T, encoding = "UTF-8",colClasses = "character")
codes<-codage$CODE
names(codes)<-codage$NAME
codes



## Empty file
length(fic5)
test<-data.frame(code=1:length(fic5),rec=fic5)

## Select ordinary households
test<-test[substr(test$rec,14,14)=="0",]

## Loc
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


test$radio<-substr(test$rec,45,45)
table(test$radio)

test$telev<-substr(test$rec,46,46)
table(test$telev)

test$hifi<-substr(test$rec,47,47)
table(test$hifi)

test$parab<-substr(test$rec,48,48)
table(test$parab)

test$magne<-substr(test$rec,49,49)
table(test$magne)

test$cddvd<-substr(test$rec,50,50)
table(test$cddvd)

test$frigo<-substr(test$rec,51,51)
table(test$frigo)


test$cuisi<-substr(test$rec,52,52)
table(test$cuisi)

test$foyam<-substr(test$rec,53,53)
table(test$foyam)

test$ferre<-substr(test$rec,54,54)
table(test$ferre)

test$clima<-substr(test$rec,55,55)
table(test$clima)

test$venti<-substr(test$rec,56,56)
table(test$venti)

test$lit<-substr(test$rec,57,57)
table(test$lit)

test$matel<-substr(test$rec,58,58)
table(test$matel)

test$faumo<-substr(test$rec,59,59)
table(test$faumo)

test$ordi<-substr(test$rec,60,60)
table(test$ordi)

test$inter<-substr(test$rec,61,61)
table(test$inter)

test$elgen<-substr(test$rec,62,62)
table(test$elgen)

test$bicyc<-substr(test$rec,63,63)
table(test$bicyc)

test$motoc<-substr(test$rec,64,64)
table(test$motoc)

test$voitu<-substr(test$rec,65,65)
table(test$voitu)

test$barqu<-substr(test$rec,66,66)
table(test$barqu)

test$nbtel<-as.numeric(substr(test$rec,67,68))
summary(test$nbtel)

test$nbgsm<-as.numeric(substr(test$rec,69,70))
summary(test$nbgsm)
table(test$nbgsm)



### Save
test<-test[,-c(1:2)]
saveRDS(test,"rp2013/menag_arond.RDS")



### agreg

dt<-data.table(test)

x<-dt[,.(tot= .N, 
         radio=sum(radio=="1"),
         telev=sum(telev=="1"),
         hifi=sum(hifi=="1") ,
         parab=sum(parab=="1"),
         magne=sum(magne=="1"),
         cddvd=sum(cddvd=="1") ,
         frigo=sum(frigo=="1"),
         cuisi=sum(cuisi=="1"),
         foyam=sum(foyam=="1") ,
         ferre=sum(ferre=="1"),
         clima=sum(clima=="1"),
         venti=sum(venti=="1") ,
         lit=sum(lit=="1"),
         matel=sum(matel=="1"),
         faumo=sum(faumo=="1") ,
         ordi=sum(ordi=="1"),
         inter=sum(inter=="1"),
         elgen=sum(elgen=="1") ,
         bicyc=sum(bicyc=="1"),
         motoc=sum(motoc=="1"),
         voitu=sum(voitu=="1"),
         barqu=sum(barqu=="1") ,
         telfi=sum(nbtel>0,na.rm=T),
         telmo=sum(nbgsm>0,na.rm=T)
         
         ),.(dep, dep_name,com,com_name, arr)]

saveRDS(x,"rp2013/menag_arond_equip.RDS")
