###### EXTRACTION DES MOBILITES SPATIO TEMPORELLES
library(dplyr)


t1<-Sys.time()
x<-readRDS(file = "rp2013/fic2.rds")
n<-length(x)
z<-data.frame(id=1:n,rec=x)

codage<-read.table("rp2013/code_loc.csv",sep=";",header=T, encoding = "UTF-8",colClasses = "character")
codes<-codage$NAME
names(codes)<-codage$CODE

test<-z[,1:1000]
test<-z
test$ref<-as.factor(substr(test$rec,17,18)=="01")
levels(test$ref)<-c("N","O")
test$sex<-as.factor(substr(test$rec,20,20))
levels(test$sex)<-c("M","F")
test$loc1<-substr(test$rec,29,31)
test$loc1_name<-recode_factor(as.factor(test$loc1), !!!codes)
test$loc1[test$loc1==998]<-NA
test$loc1[test$loc1==999]<-NA
test$dat1<-as.numeric(substr(test$rec,23,26))
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


test<-test[,-c(1,2)]

t2=Sys.time()
t2-t1

saveRDS(test,"data/rp2013/mobind.RDS")

test2<-filter(test,mob12+mob23>0)

saveRDS(test2,"data/rp2013/mobind2.RDS")

test3 <- filter(test2,is.na(dat2)==FALSE) %>% filter(mob12+mob23==2)
saveRDS(test3,"data/rp2013/mobind3.RDS")
