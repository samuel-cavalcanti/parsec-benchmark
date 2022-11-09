#!/bin/bash 
#SBATCH --job-name=dedup 
#SBATCH --time=2-0:0
#SBATCH --cpus-per-task=32
#SBATCH --hint=compute_bound
#SBATCH --exclusive
export OMP_NUM_THREADS=32



PASCALANALYZER='pkgs/libs/pascal-releases/bin/pascalanalyzer'
DEDUP='pkgs/kernels/dedup/inst/amd64-linux.gcc-pascal/bin/dedup'

echo "Esse script é feito para ser executado na pasta raiz do parsec!!"


NTHREADS=2;#"__nt__" 
# tenho que passar esse parâmetro  __nt__
# para os cores.


# simsmall
simsmall="input_simsmall.tar"
simsmall_run_args="-c -p -v -t ${NTHREADS} -i media.dat -o output.dat.ddp"

#native
native="input_native.tar"
native_run_args="-c -p -v -t ${NTHREADS} -i FC-6-x86_64-disc1.iso -o output.dat.ddp"




# tenho 8 threads, portanto
MY_CORES="1,2,3,4,6,8";#,16,32,64 ";# colocar 32 caso usando o super computador

tar -xf "pkgs/kernels/dedup/inputs/$simsmall";





# RODANDO COM PASPASCALANALYZERCAL
# LEMBRE-SE  de OLHAR O parâmetro NTHREADS, e verifica se o valor é __nt__

# -t man é para informar que estou utilizando pascalops.h para isolar a região paralelizada
./$PASCALANALYZER -t man -c "$MY_CORES" --ragt acc --ipts " ${simsmall_run_args}" "$DEDUP" -o "dedup-pthreads.json" -v DEBUG

# RODANDO COM GDB
# LEMBRE-SE  de  (colocar a flag -g no arquivo /config/gcc-pascal.bldconf)
# gdb --args "./$DEDUP $simsmall_run_args"


# RODANDO SOLO 
# ./"$DEDUP $simsmall_run_args"

# # cleaing input
rm -rf  media.dat
rm -rf  output.dat.ddp