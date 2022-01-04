###### TEST DE CHARGEMENT

library(readr)
library(forcats)

# Create empty table
tab1<-as.character()
tab2<-as.character()
tab5<-as.character()
list.files()
myFile<-"INSAE_RGPH4_2013.dat"
t1<-Sys.time()
fic <- read_lines(myFile,skip=0,n_max = 1000000)
max<-length(fic)
i<-1
head(fic)

while(i< max) {
#if(length(fic[i]<1)){i<-i+1} else
if(substr(fic[i],1,1)==1) {  
   tab1<-c(tab1,fic[i]) 
  i<-i+1                       
  } else
if(substr(fic[i],1,1)==2) {  
      tab2<-c(tab2,fic[i]) 
      i<-i+1                       
    } else
if(substr(fic[i],1,1)==5) {  
        tab5<-c(tab5,fic[i]) 
        i<-i+1                       
      } else
{i=i+1}
}  
t2<-Sys.time()
t2-t1

x<-data.frame(rec=tab2)
x$com<-substr(x$rec,2,4)

z<-x[x$com=="011",]
saveRDS(z,"COM011.rds")

#### TEST DE RECODAGE ###############################################
z<-readRDS("COM011.rds")

# CODE
z$loc<-substr(z$rec,1,16)

z<-z[,-2]

# LIEN DE PARENTE
z$par<-as.factor(substr(z$rec,17,18))

# SEXE
z$sex<-as.factor(substr(z$rec,20,20))
levels(z$sex)<-c("M","F") 
#table(z$sex)

# AGE
z$age<-as.numeric(substr(z$rec,27,28))
#hist(z$age,breaks=75)

# LIEU DE NAISANCE
z$loc_nais<-substr(z$rec,29,31)
#table(z$loc_nais)


# ETHNIE_NATIONALITE
z$eth<-substr(z$rec,33,35)
table(z$eth)

# RELIGION
z$rel<-substr(z$rec,36,36)
table(z$rel)

# HANDICAP 1 
z$hand1<-substr(z$rec,37,38)
table(z$hand1)

# HANDICAP 2 
z$hand2<-substr(z$rec,39,40)
table(z$hand2)

# HANDICAP 3 
z$hand3<-substr(z$rec,41,42)
table(z$hand3)

# RESIDENCE
z$res<-substr(z$rec,43,43)
table(z$res) 

# RESIDENCE ANTERIEURE
z$loc_ant<-substr(z$rec,44,46)
table(z$loc_ant) 

# DUREE RESIDENCE ACTUELLE
z$loc_time<-as.numeric(substr(z$rec,47,48))
hist(z$loc_time[z$loc_time<98],breaks=50,main="durée de résidence",xlab="nb. années")

# LANGUE PARLEE (principale)
z$lang<-substr(z$rec,51,53)
table(z$lang)

# SCOLARISATION
z$scol_freq<-substr(z$rec,54,54)
table(z$age,z$scol_freq)

# NIVEAU SCOLAIRE
z$scol_niv<-substr(z$rec,55,56)
table(z$scol_niv)

# ALPHABETISATION
z$alph<-substr(z$rec,57,57)
table(z$alph)

# OCCUPATION
z$occ<-substr(z$rec,58,58)
table(z$occ)

# OCCUATION / PROFESSION 
z$occ_prof<-substr(z$rec,59,61)
table(z$occ_prof)

# OCCUPATION / STATUT
z$occ_stat<-substr(z$rec,62,62)
table(z$occ_stat)

# OCCUPATION / BRANCHE
z$occ_bran<-substr(z$rec,63,66)
table(z$occ_bran)

# SITUATION MATRIMONIALE
z$matr<-substr(z$rec,67,67)
table(z$matr)


