#!/bin/bash 
#SBATCH --job-name=swaptions 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
SWAPTIONS='pkgs/apps/swaptions/inst/amd64-linux.gcc-pascal/bin/swaptions'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.


# simsmall
simsmall="-ns 16 -sm 10000 -nt ${NTHREADS}"

#native
native="-ns 128 -sm 1000000 -nt ${NTHREADS}"

pascal="-ns 32 -sm 2000000 -nt __nt__,-ns 32 -sm 3000000 -nt __nt__,-ns 32 -sm 4000000 -nt __nt__,-ns 32 -sm 5000000 -nt __nt__,-ns 32 -sm 6000000 -nt __nt__"

# -ns == nSwaptions número de simulações
# -sm == NUM_TRIALS

#número de tentativas por simulaçãoimage.png
# -nt == nThreads  número de Threads

# tenho 8 threads, portanto
MY_CORES=32;# colocar 32 caso usando o super computador

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c 1:$MY_CORES --ipts "$pascal" "$SWAPTIONS" -o "swaptions-pthreads_g.json" -r 10 -g