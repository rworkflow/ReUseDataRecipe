script <- "
specie=$1
version=$2

wget http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_$specie/release_$version/gencode.v$version.annotation.gtf.gz
gzip -d gencode.v$version.annotation.gtf.gz
"

p1 <- InputParam(id = "specie", type = "string", position = 1)
p2 <- InputParam(id = "version", type = "string", position = 2)
o1 <- OutputParam(id = "gtf", type = "File", glob = "*.gtf")
req1 <- requireShellScript(script)
req2 <- requireNetwork()
req3 <- requireDocker("alpine")
gencode_gtf <- cwlProcess(cwlVersion = "v1.2",
                          baseCommand = ShellScript(),
                          requirements = list(req1, req2, req3),
                          inputs = InputParamList(p1, p2),
                          outputs = OutputParamList(o1))

