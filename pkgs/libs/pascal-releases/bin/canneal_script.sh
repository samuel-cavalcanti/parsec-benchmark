#!/bin/bash 
#SBATCH --job-name=canneal 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
CANNEAL='pkgs/kernels/canneal/inst/amd64-linux.gcc-pascal/bin/canneal'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.



simsmall="input_simsmall.tar"
simsmall_run_args="${NTHREADS} 10000 2000 100000.nets 32"


native="input_native.tar"
native_run_args="${NTHREADS} 15000 2000 2500000.nets 6000"


pascal="input_pascal.tar"
pascal_run_args="${NTHREADS} 15000 2000 2500000.nets 128,${NTHREADS} 15000 2000 2500000.nets 256,${NTHREADS} 15000 2000 2500000.nets 384,${NTHREADS} 15000 2000 2500000.nets 512,${NTHREADS} 15000 2000 2500000.nets 640"


# tenho 8 threads, portanto
MY_CORES="1:32";# colocar 32 caso usando o super computador

tar -xf "pkgs/kernels/canneal/inputs/$pascal";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c ${MY_CORES} --ragt acc --ipts " ${pascal_run_args}" "$CANNEAL" -o "canneal-pthreads_g.json" -g


# # cleaing input
rm -rf  *.nets
