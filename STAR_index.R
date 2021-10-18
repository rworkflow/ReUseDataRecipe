script <- "
ref=$1
gtf=$2
genomeDir=$3
threads=$4
sjdb=$5

if [ ! -f $ref ]
then
  wget $ref
  ref=`basename $ref`
fi 

if [ ! -f $gtf ]
then
  wget $gtf
  gtf=`basename $gtf`
fi

STAR --runMode genomeGenerate --runThreadN $threads --genomeDir $genomeDir --genomeFastaFiles $ref --sjdbGTFfile $gtf  --sjdbOverhang $sjdb
"

p1 <- InputParam(id = "ref", type = list("string", "File"), position = 1)
p2 <- InputParam(id = "gtf", type = list("string", "File"), position = 2)
p3 <- InputParam(id = "genomeDir", type = "string", position = 3)
p4 <- InputParam(id = "threads", type = "int", position = 4)
p5 <- InputParam(id = "sjdb", type = "int", position = 5, default = 100)
o1 <- OutputParam(id = "idx", type = "Directory", glob = "$(inputs.genomeDir)")
req1 <- requireShellScript(script)
req2 <- requireDocker("quay.io/biocontainers/star:2.7.9a--h9ee0642_0")
req3 <- requireNetwork()
STAR_index <- cwlProcess(cwlVersion = "v1.2",
                         requirements = list(req1, req2, req3),
                         baseCommand = ShellScript(),
                         inputs = InputParamList(p1, p2, p3, p4, p5),
                         outputs = OutputParamList(o1))

## ## human GRCh38 + gencode v38+ len100
## STAR_index$ref <- "/projects/rpci/shared/references/GRCh38_full/GRCh38_full_analysis_set_plus_decoy_hla.fa"
## STAR_index$gtf <- "/projects/rpci/shared/references/GENCODE_GRCh38/gencode.v38.annotation.gtf"
## STAR_index$genomeDir <- "STAR.2.7.9a_GRCh38.full_GENCODE.v38_100"
## STAR_index$threads <- 8
## STAR_index$sjdb <- 100
## notes <- paste("GRCh38_full_analysis_set_plus_decoy_hla", "GENCODE.v38", "STAR_2.7.9a", "length_101")
## BPPARAM <- BatchtoolsParam(workers = 1,
##                            cluster = "slurm",
##                            template = "~/slurm_rpci.tmpl",
##                            resources = list(ncpus = 8,
##                                             jobname = "index",                         
##                                             walltime = 60*60*4,
##                                             memory = 16000),
##                            log = TRUE, logdir = ".", progressbar = TRUE)
## res <- runCWLDataBatch(STAR_index, outdir = "/projects/rpci/shared/references/STAR/",
##                        prefix = "STAR.2.7.9a_GRCh38.full_GENCODE.v38_100",
##                        showLog = TRUE, notes = notes, docker = "singularity",
##                        BPPARAM = BPPARAM)
