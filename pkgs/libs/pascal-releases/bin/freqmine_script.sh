#!/bin/bash 
#SBATCH --job-name=freqmine 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
FREQMINE='pkgs/apps/freqmine/inst/amd64-linux.gcc-pascal/bin/freqmine'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.



simsmall="input_simsmall.tar"
simsmall_run_args="kosarak_250k.dat 220"


native="input_native.tar"
native_run_args="webdocs_250k.dat 11000"

pascal="input_pascal.tar"
pascal_run_args="webdocs_250k_05.dat 1100,webdocs_250k_06.dat 1100,webdocs_250k_07.dat 1100,webdocs_250k_08.dat 1100,webdocs_250k_09.dat 1100"





# tenho 8 threads, portanto
MY_CORES="1:32";# colocar 32 caso usando o super computador

tar -xf "pkgs/apps/freqmine/inputs/$pascal";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c ${MY_CORES} --ragt acc --ipts " ${pascal_run_args}" "$FREQMINE" -o "freqmine-pthreads_g.json" -r 10 -g


# # cleaing input
rm -rf *.dat
