# EDIT snapshot, 20250306

# class features
ClassFeatures <- c("class-list","climatic-features","landforms",
                   "physiographic-interval-properties","physiographic-nominal-properties",
                   "physiographic-ordinal-properties","annual-production","forest-overstory",
                   "forest-understory","rangeland-plant-composition","soil-surface-cover",
                   "soil-parent-material","soil-interval-properties","soil-nominal-properties",
                   "soil-ordinal-properties","soil-profile-properties","soil-surface-textures",
                   "model-state-narratives","model-transition-narratives")

# api function
cf <-  function(mlras, i, ClassFeatures, j){
  cat(mlras[i,1],"  ")
  l <-  paste0("https://edit.jornada.nmsu.edu/services/downloads/esd/",mlras[i,1],"/",ClassFeatures[j], ".txt")
  read.table(l, sep="\t", quote = "\"", header=TRUE, skip=2)
}

# convey
t1 <- Sys.time()

mlras <- read.table("https://edit.jornada.nmsu.edu/services/downloads/esd/geo-unit-list.txt", 
                    sep="\t", quote = "\"", header=TRUE, skip=2) 

for (j in 1:length(ClassFeatures)){
  cf.list <- list()
  for (i in 1:nrow(mlras)) {cf.list[[i]] <- cf(mlras, i, ClassFeatures, j)} 
  assign(paste0("cf.", j), do.call("rbind", cf.list))
  cat(ClassFeatures[j],"  ", sep="\n")
}

t2 <- Sys.time()

t2-t1 # 21.295 mins
length(unique(cf.1$Ecological.site.ID)) # 7503 ES concepts

# combine & save
cf.all <- c(list(mlras), lapply(seq(1,length(ClassFeatures)), function(k) get(paste0("cf.", k))))
names(cf.all) <- c("geo-unit-list", ClassFeatures)

saveRDS(cf.all, "EDIT/EDIT20250306.rds")

#end