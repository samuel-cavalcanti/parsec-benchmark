#!/bin/bash 
#SBATCH --job-name=swaptions 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
FACESIM='pkgs/apps/facesim/inst/amd64-linux.gcc-pascal/bin/facesim'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.


# simsmall
simsmall="input_simsmall.tar"

#native
native="input_native.tar"


# -ns == nSwaptions número de simulações
# -sm == NUM_TRIALS

#número de tentativas por simulaçãoimage.png
# -nt == nThreads  número de Threads

# tenho 8 threads, portanto
MY_CORES="1,2,3,4,6,8";#,16,32,64 ";# colocar 32 caso usando o super computador

tar -xf "pkgs/apps/facesim/inputs/$simsmall";
# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c "$MY_CORES" --ipts " -timing -threads $NTHREADS" "$FACESIM" -o "facesim-pthreads.json"


# cleaing input
rm -rf Face_Data
rm -rf Storytelling