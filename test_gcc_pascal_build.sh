#! /bin/bash


packages=(
    "swaptions"
    "facesim"

     );

pacal_lib_paths=()

for package in ${packages[@]}; do
    rm -rf pkgs/apps/$package/inst/
    rm -rf pkgs/apps/$package/obj/

    parsecmgmt -a build -p $package -c gcc-pascal
    
    pacal_lib_path=$(ldd "pkgs/apps/$package/inst/amd64-linux.gcc-pascal/bin/$package"  | grep libmanualinst.so)
    
   
    pacal_lib_paths+=("$pacal_lib_path")
done;


for index in ${!pacal_lib_paths[@]}; do

    path=${pacal_lib_paths[$index]}
    package=${packages[$index]}

    if [[ "$path" =~ .*"not found".* ]]; then
        echo "ERROR: $package => $path"
        exit 1
    fi

    echo "$package -- ${pacal_lib_paths[$index]}"
done;
