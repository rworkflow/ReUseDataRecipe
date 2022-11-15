## gcp_public_data_broad_reference_hg38_v0_1000G_omni2.5

## Example:
## rcp$fn <- "1000G_omni2.5.hg38.vcf.gz"
## rcp$idx <- "tbi"
## getData(rcp,
##         outdir = "/home/qian/workspace/SharedData/gcp_public_data_broad_references_hg38_v0",
##         prefix = "gcp_broad_hg38_v0_1000G_omni2.5",
##         notes = c("gcp", "broad", "reference", "hg38", "v0", "1000G", "omni2.5"),
##         showLog = TRUE)

script <- "
fn=$1
idx=$2
wget https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/$fn
if [[ $idx ]]; then wget $fn.$idx; fi
"
rcp <- recipeMake(shscript = script,
                  paramID = c("fn", "idx"),
                  paramType = c("string", "string?"),
                  outputID = "dfile",
                  outputGlob = "1000G_omni2.5.hg38.vcf.gz*")
## outputGlob = "$(inputs.rpath.split('/').slice(-1)[0])*")

rcp <- addMeta(rcp,
               label = "",
               doc = "",
               inputLabels = c(),
               inputDocs = c(),
               outputLabels = c(),
               outputDocs = c(),
               extensions = list()
               )
