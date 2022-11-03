script <- "
  wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M1/NCBIM37.genome.fa.gz
"
rcp_gencode_ncbim37 <- recipeMake(script, 
                                 outputID = "genome",
                                 outputGlob = "NCBIM37.primary_assembly.genome.fa.gz")
