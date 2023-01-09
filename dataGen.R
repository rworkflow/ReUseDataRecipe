library(ReUseData)
library(Rcwl)
library(httr)
library(XML)

## echo and print to file
recipeLoad('echo_out', return = T)
echo_out$input <- "Hello World!"
echo_out$outfile <- "outfile"
getData(echo_out,
        outdir = 'gcpData/echo',
        notes = c("echo", "hello", "world", "txt"))

## Download and unzip genome liftover file from Ensembl
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

## Download, unzip, and index transcripts files from gencode.
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
    
## Download and unzip annotation files from gencode
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

## Download GATK GCP files. 

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

## reference genome GRCh38, Homo sapiens, MT  (not tested/added yet!!!)
recipeLoad("reference_genome", return=TRUE)
params <- data.frame(
    fasta = c("http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa", "http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz"),
    notes = c("GRCh38", "GRCh37"))

for (i in seq_len(nrow(params))) {
    reference_genome$fasta <- params$fasta[i]
    getData(reference_genome,
            outdir = "gcpData/reference_genome",
            notes = c("homo sapiens", "1000 genomes", params$notes[i])  
            )
}

## gencode genome grch38 (no input paramater)
## FIXME: add_meta() now calls inputs()
recipeLoad("gencode_genome_grch38", return = TRUE)  ## addMeta calls inputs(rcp) which doesn't exist... 


## mutect2
recipeLoad("gcp_gatk_mutect2_b37.R", return = TRUE)
params <- data.frame(filename = c("af-only-gnomad.raw.sites.vcf",
                                  "small_exac_common_3.vcf",
                                  "Mutect2-exome-panel.vcf",
                                  "Mutect2-WGS-panel-b37.vcf"),
                     idx = c("idx", "idx", "idx", "idx"))

for (i in seq_len(nrow(params))) {
    gcp_gatk_mutect2_b37$filename <- params[i, "filename"]
    gcp_gatk_mutect2_b37$idx <- params[i, "idx"]
    getData(gcp_gatk_mutect2_b37,
            outdir = "gcpData/gcp_gatk_mutect2_b37",
            notes = c("gcp", "broad", "gatk", "mutect2", "b37", gcp_gatk_mutect2_b37$filename),
            showLog = TRUE)
}

recipeLoad("gcp_gatk_mutect2_hg38.R", return = TRUE)
params <- data.frame(filename = c("af-only-gnomad.hg38.vcf.gz",
                                  "small_exac_common_3.hg38.vcf.gz",
                                  "1000g_pon.hg38.vcf.gz"),
                     idx = c("tbi", "tbi", "tbi"))

for (i in seq_len(nrow(params))) {
    gcp_gatk_mutect2_hg38$filename <- params[i, "filename"]
    gcp_gatk_mutect2_hg38$idx <- params[i, "idx"]
    getData(gcp_gatk_mutect2_hg38,
            outdir = "gcpData/gcp_gatk_mutect2_hg38",
            notes = c("gcp", "broad", "gatk", "mutect2", "hg38", gcp_gatk_mutect2_hg38$filename),
            showLog = TRUE)
}

## reference genome
recipeLoad("reference_genome.R", return = TRUE)
reference_genome$fasta <- "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_42/GRCh38.primary_assembly.genome.fa.gz"
getData(reference_genome,
        outdir = "gcpData/reference_genome",
        notes = c("reference_genome", "GRCh38.primary_assembly", "bwa_index", "dict", "fai"),
        showLog = TRUE, conda=TRUE)

## STAR
recipeLoad("STAR_index.R", return = TRUE)
STAR_index$ref <- "gcpData/reference_genome/GRCh38.primary_assembly.genome.fa"
STAR_index$gtf <- "gcpData/gencode_annotation/gencode.v42.annotation.gtf"
STAR_index$sjdb <- 100
STAR_index$genomeDir <- "GRCh38.GENCODE.v42_100"
STAR_index$threads <- 16

bp <- BatchtoolsParam(workers = 1,
                      cluster = "slurm",
                      template = "~/slurm_rpci.tmpl",
                      resources = list(ncpus = 16,
                                       jobname = "star_index",                         
                                       walltime = 60*60*24,
                                       memory = 64000),
                      log = TRUE, logdir = ".", progressbar = TRUE)

getData(STAR_index,
        outdir = "gcpData/STAR_index",
        notes = c("STAR_index", "GRCh38.primary_assembly", "gencode.v42", "star_2.7.9a"),
        showLog = TRUE, docker = "singularity", BPPARAM = bp)

## salmon index
recipeLoad("salmon_index.R", return = TRUE)
salmon_index$genome <- "gcpData/reference_genome/GRCh38.primary_assembly.genome.fa"
salmon_index$transcript <- "gcpData/gencode_transcriptome/gencode.v42.transcripts.fa"
getData(salmon_index,
        outdir = "gcpData/salmon_index_GRCh38",
        notes = c("salmon_index", "GRCh38", "gencode.v42"),
        showLog = TRUE, conda=TRUE)

## bowtie2
recipeLoad("bowtie2_index.R", return = TRUE)
bowtie2_index$genome <- "gcpData/reference_genome/GRCh38.primary_assembly.genome.fa"
getData(bowtie2_index,
        outdir = "gcpData/bowtie2_index",
        notes = c("bowtie2_index", "GRCh38.primary_assembly"),
        showLog = TRUE, conda=TRUE)

## hisat2
recipeLoad("hisat2_index.R", return = TRUE)
hisat2_index$genome <- "gcpData/reference_genome/GRCh38.primary_assembly.genome.fa"
getData(hisat2_index,
        outdir = "gcpData/hisat2_index",
        notes = c("hisat2_index", "GRCh38.primary_assembly"),
        showLog = TRUE, conda=TRUE)

## UCSC database
recipeLoad("ucsc_database.R", return = TRUE)

params <- data.frame(build = c("hg38", "hg38", "mm39", "mm39"),
                     dbname = c("refGene", "knownGene", "refGene", "knownGene"))

for (i in seq_len(nrow(params))) {
    ucsc_database$build <- params[i, "build"]
    ucsc_database$dbname <- params[i, "dbname"]
    getData(ucsc_database,
            outdir = "gcpData/ucsc_database",
            notes = c("ucsc", "annotation", "database",
                      ucsc_database$build, ucsc_database$dbname),
            showLog = TRUE)
}


###################################
## modify the .yml file: #output
###################################

## mt <- read.csv("ReUseDataRecipes/meta_gcp.csv")
mt <- meta_data("gcpData", checkData = FALSE)

## remove local path in "# output:" row in .yml files.
ymls <- unique(mt$yml)
for (i in seq(ymls)) {
    cts <- readLines(ymls[i])
    if(any(grepl(getwd(), cts))){
        cts <- gsub(file.path(getwd(), "gcpData/"), "", cts)
        write(cts, ymls[i])
    }
}

## in meta csv, modify the "yml" and "output" columns for gcp file path. Push to "ReUseDataRecipes/meta_gcp.csv".
mt$yml <- gsub(file.path(getwd(), "gcpData"), "https://storage.googleapis.com/reusedata", mt$yml)
mt$output <- gsub(file.path(getwd(), "gcpData"), "https://storage.googleapis.com/reusedata", mt$output)
idx <- !grepl("https://storage.googleapis.com/reusedata", mt$output)
mt$output[idx] <- paste0("https://storage.googleapis.com/reusedata/", mt$output[idx])
write.csv(mt, "meta_gcp.csv", row.names=FALSE, quote=FALSE)
## todo: push changes to origin/master!!!
## todo: upload data and annotation files to google bucket. 

############
## test
############

outdir <- file.path(tempdir(), "gcpData")
dh <- dataUpdate(outdir, cloud=TRUE)
## dh <- dataSearch(c("ensembl", "liftover", "GRCh38"))
dh1 <- dataSearch(c("homo sapiens", "grch38", "1000 genomes"))  ## multiple data in one yml file
dh1 <- dataSearch(c("gencode", "human", "annotation"))
dh1 <- dataSearch(c("ensembl", "liftover", "mouse"))     
dh1 <- dataSearch(c("gencode", "transcripts", "mouse"))  ## multiple data, in multiple yml files
dh1 <- dataSearch(c("echo", "hello", "world"))
getCloudData(dh1, outdir = outdir)  ## multiple data together
dataUpdate(outdir)  ## no cloud here. 
dataSearch()  ## data is available locally!!!



