script <- "
  wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M31/GRCm39.primary_assembly.genome.fa.gz
"
rcp_gencode_grcm39 <- recipeMake(script, 
                                 outputID = "genome",
                                 outputGlob = "GRCm39.primary_assembly.genome.fa.gz")
