#!/bin/bash 
#SBATCH --job-name=x264 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
X264='pkgs/apps/x264/inst/amd64-linux.gcc-pascal/bin/x264'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.


# simsmall
simsmall="input_simsmall.tar"
simsmall_run_args="--qp 20 --partitions b8x8\,i4x4 --ref 5 --direct auto --b-pyramid normal --weightp 1 --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8\,i4x4 --threads ${NTHREADS} -o eledream.264 eledream_640x360_8.y4m"

#native
native="input_native.tar"
native_run_args=" --qp 20 --partitions b8x8\,i4x4 --ref 5 --direct auto --b-pyramid normal --weightp 1 --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8\,i4x4 --threads ${NTHREADS} -o eledream.264 eledream_1920x1080_512.y4m"


pascal="input_pascal.tar"
pascal_run_args="--qp 20 --partitions b8x8\,i4x4 --ref 5 --direct auto --b-pyramid normal --weightp 1 --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8\,i4x4 --threads ${NTHREADS} -o eledream.264 eledream_1920x1080_512.y4m,--qp 20 --partitions b8x8\,i4x4 --ref 5 --direct auto --b-pyramid normal --weightp 1 --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8\,i4x4 --threads ${NTHREADS} -o eledream.264 eledream_1920x1080_459.y4m,--qp 20 --partitions b8x8\,i4x4 --ref 5 --direct auto --b-pyramid normal --weightp 1 --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8\,i4x4 --threads ${NTHREADS} -o eledream.264 eledream_1920x1080_408.y4m,--qp 20 --partitions b8x8\,i4x4 --ref 5 --direct auto --b-pyramid normal --weightp 1 --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8\,i4x4 --threads ${NTHREADS} -o eledream.264 eledream_1920x1080_357.y4m,--qp 20 --partitions b8x8\,i4x4 --ref 5 --direct auto --b-pyramid normal --weightp 1 --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8\,i4x4 --threads ${NTHREADS} -o eledream.264 eledream_1920x1080_306.y4m"

# tenho 8 threads, portanto
MY_CORES="1:32";# colocar 32 caso usando o super computador

tar -xf "pkgs/apps/x264/inputs/$pascal";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c ${MY_CORES} --ragt acc --ipts "${pascal_run_args}" " $X264" -o "x264-pthreads.json" -r 10


# # cleaing input
rm -rf  eledream.264 *.y4m;
