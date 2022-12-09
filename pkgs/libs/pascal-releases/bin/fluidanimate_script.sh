#!/bin/bash 
#SBATCH --job-name=fluidanimate 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
FLUIDANIMATE='pkgs/apps/fluidanimate/inst/amd64-linux.gcc-pascal/bin/fluidanimate'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.



simsmall="input_simsmall.tar"
simsmall_run_args="${NTHREADS} 5 in_35K.fluid out.fluid"


native="input_native.tar"
native_run_args="${NTHREADS} 500 in_500K.fluid out.fluid"

pascal="input_pascal.tar"
pascal_run_args="${NTHREADS} 200 in_500K.fluid out.fluid,${NTHREADS} 300 in_500K.fluid out.fluid,${NTHREADS} 400 in_500K.fluid out.fluid,${NTHREADS} 500 in_500K.fluid out.fluid"




# tenho 8 threads, portanto
MY_CORES="2,4,8,16,32";# colocar 32 caso usando o super computador

tar -xf "pkgs/apps/fluidanimate/inputs/$pascal";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c ${MY_CORES} --ragt acc --ipts " ${pascal_run_args}" " $FLUIDANIMATE" -o "fluidanimate-pthreads_g.json" -r 10 -g


# # cleaing input
rm -rf  *.fluid
