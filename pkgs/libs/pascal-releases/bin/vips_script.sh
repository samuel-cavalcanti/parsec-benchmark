#!/bin/bash 
#SBATCH --job-name=vips 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
VIPS='pkgs/apps/vips/inst/amd64-linux.gcc-pascal/bin/vips'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS="__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.



simsmall="input_simsmall.tar"
simsmall_run_args="im_benchmark pomegranate_1600x1200.v output.v --vips-concurrency=${NTHREADS}"


native="input_native.tar"
native_run_args="im_benchmark orion_18000x18000.v output.v --vips-concurrency=${NTHREADS}"

pascal="input_pascal.tar"
pascal_run_args="im_benchmark orion_10800x10800.v output.v  --vips-concurrency=${NTHREADS}, im_benchmark orion_12600x12600.v output.v  --vips-concurrency=${NTHREADS}, im_benchmark orion_14400x14400.v output.v  --vips-concurrency=${NTHREADS}, im_benchmark orion_16200x16200.v output.v  --vips-concurrency=${NTHREADS}, im_benchmark orion_18000x18000.v output.v  --vips-concurrency=${NTHREADS}"




# tenho 8 threads, portanto
MY_CORES="2:2";# colocar 32 caso usando o super computador

echo "Extracting  Input"
tar -xvf "pkgs/apps/vips/inputs/$pascal";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c ${MY_CORES} --ragt acc --ipts " ${pascal_run_args}" "$VIPS" -o "vips-pthreads_g.json" -r 10 -g


# # cleaing input
rm  *.v
