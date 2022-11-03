script <- "
    wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/GRCh37.p13.genome.fa.gz
"
rcp_gencode_grch37 <- recipeMake(script, 
                                 outputID = "genome",
                                 outputGlob = "GRCh37.p13.genome.fa.gz")
