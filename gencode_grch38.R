script <- "
  wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_42/GRCh38.primary_assembly.genome.fa.gz
"
rcp_gencode_grch38 <- recipeMake(script, 
                                 outputID = "genome",
                                 outputGlob = "GRCh38.primary_assembly.genome.fa.gz")
