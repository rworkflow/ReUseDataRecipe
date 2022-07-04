script <- "
path=$1
idx=$2
wget https://storage.googleapis.com/$path
if [[ $idx ]]; then wget https://storage.googleapis.com/$path.$idx; fi
"
googleBucket <- recipeMake(shscript = script,
                           paramID = c("rpath", "index"),
                           paramType = c("string", "string?"),
                           outputID = "dfile",
                           outputGlob = "$(inputs.rpath.split('/').slice(-1)[0])*")
