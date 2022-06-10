#!/bin/sh

# Execute esse script depois de instanciar o pascalanalizer

NTHREADS="__nt__" 
# segundo frankson, tenho que passar esse parâmetro  __nt__
# para os cores.

# simsmall
#run_args="-ns 16 -sm 10000 -nt ${NTHREADS}"

simsmall="-ns 16 -sm 10000 -nt ${NTHREADS}"

# simmedium
#run_args="-ns 32 -sm 20000 -nt ${NTHREADS}"

simmedium="-ns 32 -sm 20000 -nt ${NTHREADS}"

#simlarge
#run_args="-ns 64 -sm 40000 -nt ${NTHREADS}"

simlarge="-ns 64 -sm 40000 -nt ${NTHREADS}"

#native
#run_args="-ns 128 -sm 1000000 -nt ${NTHREADS}"
native="-ns 128 -sm 1000000 -nt ${NTHREADS}"


# -ns == nSwaptions número de simulações
# -sm == NUM_TRIALS número de tentativas por simulação
# -nt == nThreads  número de Threads

# tenho 8 threads, portanto
MY_CORES=8;

pascalanalyzer -c 1:$MY_CORES --ipts "$simsmall,$simmedium,$simlarge,$native" "./swaptions" -o "swaptions.json"
