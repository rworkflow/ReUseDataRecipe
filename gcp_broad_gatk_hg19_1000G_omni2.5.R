## gcp_broad_gatk_hg19_1000G_omni2.5

script <- "
path=https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0
wget $path/1000G_omni2.5.b37.vcf.gz
wget $path/1000G_omni2.5.b37.vcf.gz.tbi        
"
rcp <- recipeMake(shscript = script,
                  outputID = "vcf",
                  outputGlob = "1000G_omni2.5.b37.vcf.gz*")
## outputGlob = "$(inputs.rpath.split('/').slice(-1)[0])*")

rcp <- addMeta(rcp,
               label = "GCP_broad_gatk_b37_1000G_omni2.5",
               doc = "the 1000G_omni2.5 vcf.gz (and index) files from google bucket for broad reference data GATK hg19.",
               outputLabels = c("vcf"),
               outputDocs = c("The `1000G_omni2.5.b37.vcf.gz` and '.tbi' index files"),
               extensions = list(author = "rworkflow team",
                                 date = Sys.Date(),
                                 url = "https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/1000G_omni2.5.b37.vcf.gz", 
                                 example = paste("rcp <- recipeLoad('gcp_broad_gatk_hg19_1000G_omni2.5')",
                                                 "getData(rcp, outdir = 'data/folder', prefix = 'gcp_broad_hg19_v0_1000G_omni2.5', notes = c('gcp', 'broad', 'reference', 'hg19', 'v0', '1000G', 'omni2.5', 'b37')",
                                                 sep="\n"))
               )
