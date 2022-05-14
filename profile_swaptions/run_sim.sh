#! /bin/bash
. env.sh

for sim in  'simsmall' 'simmedium' 'simlarge' 'native'
do
    parsecmgmt -a run -p swaptions -i $sim
    gprof pkgs/apps/swaptions/inst/amd64-linux.gcc/bin/swaptions pkgs/apps/swaptions/run/gmon.out > "profile_swaptions/${sim}.txt"
done