script <- "
from=$1
to=$2
wget https://ftp.ensembl.org/pub/assembly_mapping/mus_musculus/${from}_to_${to}.chain.gz
gzip -d ${from}_to_${to}.chain.gz"

rcp_liftover <- recipeMake(shscript = script,
                           paramID = c("from", "to"), 
                           paramType = c("string", "string"), 
                           outputID = "ensembl_liftover_mouse", 
                           outputGlob = "*.chain") 
