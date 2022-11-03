script <- "
  wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M25/GRCm38.primary_assembly.genome.fa.gz
"
rcp_gencode_grcm38 <- recipeMake(script, 
                                 outputID = "genome",
                                 outputGlob = "GRCm38.primary_assembly.genome.fa.gz")

