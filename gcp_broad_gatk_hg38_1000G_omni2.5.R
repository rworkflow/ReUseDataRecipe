## gcp_broad_gatk_hg38_1000G_omni2.5

script <- "
path=https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0
wget $path/1000G_omni2.5.hg38.vcf.gz
wget $path/1000G_omni2.5.hg38.vcf.gz.tbi        
"
rcp <- recipeMake(shscript = script,
                  outputID = "vcf",
                  outputGlob = "1000G_omni2.5.hg38.vcf.gz*")
## outputGlob = "$(inputs.rpath.split('/').slice(-1)[0])*")

rcp <- addMeta(rcp,
               label = "gcp_broad_gatk_hg38_1000G_omni2.5",
               doc = "the 1000G_omni2.5 vcf.gz (and index) files from google bucket for broad reference data GATK hg38.",
               outputLabels = c("vcf"),
               outputDocs = c("The `1000G_omni2.5.hg38.vcf.gz` and '.tbi' index files"),
               extensions = list(author = "rworkflow team",
                                 date = Sys.Date(),
                                 url = "https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/1000G.phase3.integrated.sites_only.no_MATCHED_REV.hg38.vcf", 
                                 example = paste("rcp <- recipeLoad('gcp_broad_gatk_hg38_1000G_omni2.5",
                                                 "getData(rcp, outdir = 'data/folder', prefix = 'gcp_broad_hg38_v0_1000G_omni2.5', notes = c('gcp', 'broad', 'reference', 'hg38', 'v0', '1000G', 'omni2.5')",
                                                 sep="\n"))
               )
