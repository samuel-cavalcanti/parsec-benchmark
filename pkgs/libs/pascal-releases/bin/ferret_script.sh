#!/bin/bash 
#SBATCH --job-name=ferret 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
FERRET='pkgs/apps/ferret/inst/amd64-linux.gcc-pascal/bin/ferret'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.



simsmall="input_simsmall.tar"
simsmall_run_args="corel lsh queries 10 20 ${NTHREADS} output.txt"


native="input_native.tar"
native_run_args="corel lsh queries 50 20 ${NTHREADS} output.txt"

pascal="input_pascal.tar"
pascal_run_args="corel_5 lsh queries_5 10 20 ${NTHREADS} output.txt,corel_6 lsh queries_6 10 20 ${NTHREADS} output.txt,corel_7 lsh queries_7 10 20 ${NTHREADS} output.txt,corel_8 lsh queries_8 10 20 ${NTHREADS} output.txt,corel_9 lsh queries_9 10 20 ${NTHREADS} output.txt"




# tenho 8 threads, portanto
MY_CORES="2:2";# colocar 32 caso usando o super computador

tar -xf "pkgs/apps/ferret/inputs/$simsmall";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c ${MY_CORES} --ragt acc --ipts " ${simsmall_run_args}" "$FERRET" -o "ferret-pthreads.json" -r 10


# # cleaing input
rm -rf queries*   output.txt corel*
