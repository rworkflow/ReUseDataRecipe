script <- "
species=$1
version=$2
wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_$species/release_$version/gencode.v$version.annotation.gtf.gz
gzip -d gencode.v$version.annotation.gtf.gz
"

rcp_gencode_annot <- recipeMake(shscript = script,
                                paramID = c("species", "version"),
                                paramType = c("string", "string"),
                                outputID = "annotation", 
                                outputGlob = "gencode.v*.annotation.gtf"
                                )  
