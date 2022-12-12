library(ReUseData)
library(Rcwl)
library(httr)
library(XML)

## Example 1: Download and unzip genome liftover file from Ensembl
recipeLoad('ensembl_liftover', return=T)  ## Encourage to use a meaningful name!!! or use recipeLoad(return=TRUE)
h1 <- GET("https://ftp.ensembl.org/pub/assembly_mapping/homo_sapiens/")
fls <- readHTMLTable(content(h1, as="text"))[[1]]$Name
wanted <- grepl("_to_", fls)
params_hm <- do.call(rbind, lapply(strsplit(fls[wanted], split="\\_|\\."), function(x) x[c(1,3)]))

h2 <- GET("https://ftp.ensembl.org/pub/assembly_mapping/mus_musculus/")
fls <- readHTMLTable(content(h2, as="text"))[[1]]$Name
wanted <- grepl("_to_", fls)
params_mm <- do.call(rbind, lapply(strsplit(fls[wanted], split="\\_|\\."), function(x) x[c(1,3)]))

params <- rbind(params_hm, params_mm)
params <- data.frame(species = c(rep("human", nrow(params_hm)), rep("mouse", nrow(params_mm))),
                     params)
colnames(params) <- c("species", "from", "to")
                     
for (i in seq_len(nrow(params))) {
    ensembl_liftover$species <- params[i, "species"]
    ensembl_liftover$from <- params[i, "from"]
    ensembl_liftover$to <- params[i, "to"]
    getData(ensembl_liftover,
            outdir = "gcpData/ensembl_liftover",
            notes = c('ensembl', 'liftover', ensembl_liftover$species, ensembl_liftover$from, ensembl_liftover$to)
            )
}

## Example 2: Download, unzip, and index transcripts files from gencode.
recipeLoad('gencode_transcripts', return=T)
params <- data.frame(species = rep(c("human", "mouse"), each=2), version = c(42, 41, "M31", "M30"))
for (i in seq_len(nrow(params))) {
    gencode_transcripts$species <- params[i, "species"]
    gencode_transcripts$version <- params[i, "version"]
    getData(gencode_transcripts,
            outdir = 'gcpData/gencode_transcriptome',
            notes = c('gencode', 'transcripts', gencode_transcripts$species, gencode_transcripts$version)
            )
}
    
## Example 3: Download and unzip annotation files from gencode
recipeLoad('gencode_annotation', return=TRUE)
params <- data.frame(species = rep(c("human", "mouse"), each=2), version = c(42, 41, "M31", "M30"))
for (i in seq_len(nrow(params))) {
    gencode_annotation$species <- params[i, "species"]
    gencode_annotation$version <- params[i, "version"]
    getData(gencode_annotation,
            outdir = 'gcpData/gencode_annotation',
            notes = c("gcp", "broad", "gatk", "hg38", gencode_annotation$species, gencode_annotation$version)
            )
}

## Example 4: Download GATK GCP files. 

## hg38
recipeLoad("gcp_broad_gatk_hg38", return = TRUE)
params <- data.frame(filename = c("1000G_omni2.5.hg38.vcf.gz",
                                  "Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"),
                     idx = c("tbi", "tbi"))

for (i in seq_len(nrow(params))) {
    gcp_broad_gatk_hg38$filename <- params[i, "filename"]
    gcp_broad_gatk_hg38$idx <- params[i, "idx"]
    getData(gcp_broad_gatk_hg38,
            outdir = "gcpData/gcp_broad_gatk_hg38",
            notes = c("gcp", "broad", "gatk", "hg38", gcp_broad_gatk_hg38$filename, gcp_broad_gatk_hg38$idx)
            )
}

## hg19
recipeLoad("gcp_broad_gatk_hg19", return = TRUE)
params <- data.frame(filename = c("1000G_omni2.5.b37.vcf.gz",
                                  "Mills_and_1000G_gold_standard.indels.b37.vcf.gz"),
                     idx = c("tbi", "tbi"))

for (i in seq_len(nrow(params))) {
    gcp_broad_gatk_hg19$filename <- params[i, "filename"]
    gcp_broad_gatk_hg19$idx <- params[i, "idx"]
    getData(gcp_broad_gatk_hg19,
            outdir = "gcpData/gcp_broad_gatk_hg19",
            notes = c("gcp", "broad", "gatk", "hg38", gcp_broad_gatk_hg19$filename, gcp_broad_gatk_hg19$idx)
            )
}


###################################
## modify the .yml file: #output
###################################

## mt <- read.csv("ReUseDataRecipes/meta_gcp.csv")
mt <- meta_data("gcpData", checkData = FALSE)

## remove local path in "# output:" row in .yml files.
for (i in seq_len(nrow(mt))) {
    cts <- readLines(mt$yml[i])
    idx <- grep("# output", cts)
    cts[idx] <- gsub(file.path(getwd(), "gcpData/"), "", cts[idx])
    write(cts, mt$yml[i])
}

## in meta csv, modify the "yml" and "output" columns for gcp file path. Push to "ReUseDataRecipes/meta_gcp.csv".
mt$yml <- gsub(file.path(getwd(), "gcpData"), "https://storage.googleapis.com/reusedata", mt$yml)
mt$output <- gsub(file.path(getwd(), "gcpData"), "https://storage.googleapis.com/reusedata", mt$output)
if (all(!grepl("https://storage.googleapis.com/reusedata", mt$output))) {
    mt$output <- paste0("https://storage.googleapis.com/reusedata/", mt$output)
}
write.csv(mt, "ReUseDataRecipes/meta_gcp.csv", row.names=FALSE, quote=FALSE)
## todo: push changes to origin/master!!!
## todo: upload data and annotation files to google bucket. 

## test
outdir <- file.path(tempdir(), "gcpData")
dataUpdate(outdir, cloud=TRUE)
dh <- dataSearch(c("ensembl", "liftover", "GRCh38"))
getCloudData(dh[1], outdir = outdir)
dataUpdate(outdir)  ## no cloud here. 
dataSearch()  ## data is available locally!!!


## Example 4: reference genome GRCh38, Homo sapiens, MT  (not tested/added yet!!!)
recipeLoad(reference_genome, return=TRUE)
for (i in c(1:22, "MT", "X", "Y")) {
    reference_genome$fasta <- paste0("http://ftp.ensembl.org/pub/release-104/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.", i, ".fa.gz")
    getData(reference_genome,
            outdir = "gcpData/referenceGenome",
            notes = c("homo sapiens", "grch38", "ensembl", i)  ## only MT here... 
            )
}

