
script <- "
filename=$1

files='AlphaMissense_aa_substitutions.tsv.gz AlphaMissense_gene_hg19.tsv.gz AlphaMissense_gene_hg38.tsv.gz AlphaMissense_hg19.tsv.gz AlphaMissense_hg38.tsv.gz AlphaMissense_isoforms_aa_substitutions.tsv.gz lphaMissense_isoforms_hg38.tsv.gz README.pdf'

for f in $files;
do
    url=https://storage.googleapis.com/dm_alphamissense/$f
    wget $url
done

tabix -s 1 -b 2 -e 2 -f -S 1 AlphaMissense_hg38.tsv.gz
tabix -s 1 -b 2 -e 2 -f -S 1 AlphaMissense_hg19.tsv.gz
"

gcp_alphamissense <- recipeMake(shscript = script,
                                  outputID = "gfiles",
                                outputGlob = "*",
                                requireTools = "tabix")



gcp_alphamissense <- addMeta(gcp_alphamissense,
                             label = "gcp_alphamissense",
                             doc = "AlphaMissense Predictions for human major transcripts and isoforms.")


getData(gcp_alphamissense,
        outdir = "/projects/rpci/shared/references/alphamissense",
        notes = c("alphamissense", "pathogenic predictions"))
