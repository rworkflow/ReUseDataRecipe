script <- "
fasta=$1
if [ ! -f $fasta ]
then
  wget $fasta
else
  cp $fasta .
fi

fa=`basename $fasta`

if [[ $fa =~ \\.gz$ ]]
then
  gzip -d $fa
  fa=`basename $fa .gz`
fi

fn=`basename $fa .fa`
fn=`basename $fn .fasta`
mv $fa $fn.fa
fa=$fn.fa

samtools faidx $fa
picard CreateSequenceDictionary R=$fa O=$fn.dict
bwa index $fa
"

p1 <- InputParam(id = "fasta", type = list("string", "File"))
o1 <- OutputParam(id = "fa", type = "File", glob = "*.fa",
                  secondaryFile = list(".fai",
                                       "^.dict",
                                       ".amb",
                                       ".ann",
                                       ".bwt",
                                       ".pac",
                                       ".sa"))

req1 <- requireShellScript(script)
dockerfile <- CondaTool(tools = c("samtools", "picard", "bwa"))
req2 <- requireDocker(File = dockerfile, ImageId = "refindex")

req3 <- requireNetwork()
req4 <- requireJS()
reference_genome <- cwlProcess(cwlVersion = "v1.2",
                               baseCommand = ShellScript(),
                               requirements = list(req1, req2, req3, req4),
                               inputs = InputParamList(p1),
                               outputs = OutputParamList(o1))

## ## ensembl homo_sapiens GRCh38 primary
## reference_genome$fasta <- "http://ftp.ensembl.org/pub/release-104/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.MT.fa.gz"
## requirements(reference_genome)[[2]] <- requireDocker("refindex")
## res <- runCWLData(reference_genome, prefix = "Homo_sapiens.GRCh38.dna.MT", outdir = "test", docker =F, showLog=TRUE)
## ## docker2sif(req2$dockerFile, paste0(req2$dockerImageId, ".sif"), "--remote")
## ## reference_genome$fasta <- "http://ftp.ensembl.org/pub/release-104/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
## ## res <- runCWLData(reference_genome, outdir = "/projects/rpci/shared/references/Homo_sapiens.GRCh38", showLog = TRUE,
## ##                   prefix = "Homo_sapiens.GRCh38.dna.primary_assembly",
## ##                   version = "release-104",
## ##                   notes = paste("ensembl", "Homo_sapiens.GRCh38",
## ##                                 "primary_assembly",
## ##                                 "fai", "dict"),
## ##                   docker = "singularity")

## ## 1kg hg38
## reference_genome$fasta <- "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa"

## res <- runCWLDataBatch(reference_genome, outdir = "/projects/rpci/shared/references/GRCh38_full", showLog = TRUE,
##                        prefix = "GRCh38_full_analysis_set_plus_decoy_hla",
##                        version = "",
##                        notes = paste("1000genomes", "20150309", "Homo_sapiens", "GRCh38",
##                                      "decoy_hla", "fai", "dict", "bwa_index", "bwa_v0.7.17-r1188"),
##                        docker = FALSE,
##                        BPPARAM = BPPARAM)

## ## hs37d5
## reference_genome$fasta <- "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz"

## res <- runCWLDataBatch(reference_genome, outdir = "/projects/rpci/shared/references/hs37d5", showLog = TRUE,
##                        prefix = "hs37d5",
##                        version = "",
##                        notes = paste("1000genomes", "20110707", "Homo_sapiens", "GRCh37",
##                                      "fai", "dict", "bwa_index", "bwa_v0.7.17-r1188"),
##                        docker = FALSE,
##                        BPPARAM = BPPARAM)

## library(BiocParallel)
## BPPARAM <- BatchtoolsParam(workers = 1,
##                            cluster = "slurm",
##                            template = "~/slurm_rpci.tmpl",
##                            resources = list(ncpus = 2,
##                                             jobname = "index",                         
##                                             walltime = 60*60*4,
##                                             memory = 16000),
##                            log = TRUE, logdir = ".", progressbar = TRUE)
## bplapply(1,
##          runBatch,
##          libs = c("Rcwl", "tools"),
##          fun = runCWLData,
##          cwl = reference_genome,
##          outdir = "/projects/rpci/shared/references/hs37d5",
##          showLog = TRUE,
##          prefix = "hs37d5",
##          version = "",
##          notes = paste("1000genomes", "20110707", "Homo_sapiens", "GRCh37",
##                        "fai", "dict", "bwa_index", "bwa_v0.7.17-r1188"),
##          docker = FALSE,
##          BPPARAM = BPPARAM)

## ##
## ## GRCm39
## reference_genome$fasta <- "http://ftp.ensembl.org/pub/release-104/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.toplevel.fa.gz"
## res <- runCWLDataBatch(reference_genome, outdir = "/projects/rpci/shared/references/GRCm39",
##                        showLog = TRUE,
##                        prefix = "Mus_musculus.GRCm39.dna.toplevel",
##                        version = "release-104",
##                        notes = paste("us_musculus", "GRCm39", "toplevel", "release-104",
##                                      "fai", "dict", "bwa_index", "bwa_v0.7.17-r1188"),
##                        docker = FALSE,
##                        BPPARAM = BPPARAM)

## library(BiocParallel)
## BPPARAM <- BatchtoolsParam(workers = 1,
##                            cluster = "slurm",
##                            template = "~/slurm_rpci.tmpl",
##                            resources = list(ncpus = 2,
##                                             jobname = "index",                         
##                                             walltime = 60*60*4,
##                                             memory = 16000),
##                            log = TRUE, logdir = ".", progressbar = TRUE)
