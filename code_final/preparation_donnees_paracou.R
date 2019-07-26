rm(list=objects())
graphics.off()

library(ggplot2)
library(raster)



coord = function(Xfield,Yfield,c){                                          # Fonction coordonnées : renvoie les coordonées ayant 
  xy = matrix(rep(0,2*length(Xfield)), ncol = 2, nrow = length(Xfield))     # pour origine le coin sud ouest de la parcelle.
  xy[,1] = 100*((c-1)%%5)+Xfield
  xy[,2] = 100*(4-floor((c-1)/5))+Yfield
  return(xy)}




load("data/Parcelle16_2018.Rdata")                               # Importation des données de Paracou

p16 = Parcelle16[Parcelle16$CensusYear==2015,]                   # Sélection des données de 2015 uniquement

p16$X = coord(p16$Xfield,p16$Yfield,p16$SubPlot)[,1]             # Rajout des coordonnées dans le dataframe
p16$Y = coord(p16$Xfield,p16$Yfield,p16$SubPlot)[,2]

if(sum(p16$Y>500)!=0){                                           # Certaines valeurs ont des ordonnées supérieures à 500 : on enlève ces données 
  p16 = p16[-which(p16$Y>500),]}



altitude = raster("data/altitude.asc")                                              # Importation des données altitudes

p16$altitude = altitude[cellFromXY(altitude,cbind(p16$Xutm,p16$Yutm))]              # Ajout de l'altitude

# ggplot(p16, aes(x=X, y=Y, color=altitude)) + geom_point() + coord_fixed()         # Carte de l'altitude 



save(p16, file="data/p16_avec coord_et_altitude_2015.RData")      # Création du RData                  
