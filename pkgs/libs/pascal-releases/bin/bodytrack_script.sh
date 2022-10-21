#!/bin/bash 
#SBATCH --job-name=bodytrack 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive




PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
BODYTRACK='pkgs/apps/bodytrack/inst/amd64-linux.gcc-pascal/bin/bodytrack'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.


# simsmall
input_simsmall="input_simsmall.tar"
arg_simsmall="sequenceB_1 4 1 1000 5 0 $NTHREADS"

#native
input_native="input_native.tar"


# -ns == nSwaptions número de simulações
# -sm == NUM_TRIALS

#número de tentativas por simulaçãoimage.png
# -nt == nThreads  número de Threads

# tenho 8 threads, portanto
MY_CORES="1,2,3,4,5,6,7,8";#,16,32,64 ";# colocar 32 caso usando o super computador

tar -xf "pkgs/apps/bodytrack/inputs/$input_simsmall";
echo "./$PASCALANALYZER -t man -c "$MY_CORES" --ipts " $arg_simsmall" "$BODYTRACK" -o bodytrack-pthreads.json"

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c "$MY_CORES" --ipts " \"$arg_simsmall\"  " "$BODYTRACK" -o "bodytrack-pthreads.json"



# cleaing input
rm -rf sequenceB_1
