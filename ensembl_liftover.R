script <- "
species=$1
from=$2
to=$3
if [ $species == 'human' ]
then 
  species='homo_sapiens'
elif [ $species == mouse ]
then 
  species='mus_musculus'
fi
wget https://ftp.ensembl.org/pub/assembly_mapping/$species/${from}_to_${to}.chain.gz
gzip -d ${from}_to_${to}.chain.gz"

rcp_liftover <- recipeMake(shscript = script,
                           paramID = c("species", "from", "to"), 
                           paramType = c("string", "string", "string"), 
                           outputID = "liftover", 
                           outputGlob = "*.chain") 
