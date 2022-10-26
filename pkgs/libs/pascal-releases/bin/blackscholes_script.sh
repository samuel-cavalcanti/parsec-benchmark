#!/bin/bash 
#SBATCH --job-name=blackscholes 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
BLACKSCHOLES='pkgs/apps/blackscholes/inst/amd64-linux.gcc-pascal/bin/blackscholes'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.


# simsmall
simsmall="input_simsmall.tar"
simsmall_run_args="${NTHREADS} in_4K.txt prices.txt"

#native
native="input_native.tar"
native_run_args="${NTHREADS} in_10M.txt prices.txt"




# tenho 8 threads, portanto
MY_CORES="1:32";# colocar 32 caso usando o super computador

tar -xf "pkgs/apps/blackscholes/inputs/$simsmall";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c ${MY_CORES} --ragt acc --ipts " ${simsmall_run_args}" "$BLACKSCHOLES" -o "blackscholes-pthreads.json"


# # cleaing input
rm in_*.txt prices.txt
