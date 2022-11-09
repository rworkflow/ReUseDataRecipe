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

rcp_gencode_annot <- addMeta(cwl = rcp_gencode_annot,
                             label = "gencode annotation",
                             doc = "Download and unzip annotation files from gencode",
                             inputLabels = c("species", "version"),
                             inputDocs = c("'human' or 'mouse'",
                                           paste0("Character string. Case sensitive. ",
                                                  "must match available versions for each species under source URL link. ",
                                                  "e.g., 'M31' (species='mouse'), '42' (species='human') ")),
                             outputLabels = c("annotation"),
                             outputDocs = c("the unzipped annotation file: `gencode.v$version.annotation.gtf`"),
                             extensions = list(`$namespaces` = list(
                                                   url = "<http://ftp.ebi.ac.uk/pub/databases/gencode/>",
                                                   date = Sys.Date(),
                                                   example = paste("rcp <- recipeLoad('gencode_annotation')",
                                                                   "rcp$species <- 'human'",
                                                                   "rcp$version <- '42'",
                                                                   "getData(rcp, outdir = 'data/folder', prefix = 'gencode_annotation_human_42', notes = c('gencode', 'annotation', 'human', '42')", sep="\n")))
                             )
