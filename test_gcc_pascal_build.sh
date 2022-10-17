#! /bin/bash

# execute esse test na raiz do repositório

source env.sh

 case "${OSTYPE}" in
  *linux*)   ostype="linux";;
  *solaris*) ostype="solaris";;
  *bsd*)     ostype="bsd";;
  *aix*)     ostype="aix";;
  *hpux*)    ostype="hpux";;
  *irix*)    ostype="irix";;
  *amigaos*) ostype="amigaos";;
  *beos*)    ostype="beos";;
  *bsdi*)    ostype="bsdi";;
  *cygwin*)  ostype="windows";;
  *darwin*)  ostype="darwin";;
  *interix*) ostype="interix";;
  *os2*)     ostype="os2";;
  *osf*)     ostype="osf";;
  *sunos*)   ostype="sunos";;
  *sysv*)    ostype="sysv";;
  *sco*)     ostype="sco";;
  *)         ostype="${OSTYPE}";;
  esac

  # Determine HOST name to use for automatically determined PARSECPLAT
  case "${HOSTTYPE}" in
  *i386*)    hosttype="i386";;
  *x86_64*)  hosttype="amd64";;
  *amd64*)   hosttype="amd64";;
  *i486*)    hosttype="amd64";;
  *sparc*)   hosttype="sparc";;
  *sun*)     hosttype="sparc";;
  *ia64*)    hosttype="ia64";;
  *itanium*) hosttype="ia64";;
  *powerpc*) hosttype="powerpc";;
  *ppc*)     hosttype="powerpc";;
  *alpha*)   hosttype="alpha";;
  *mips*)    hosttype="mips";;
  *arm*)     hosttype="arm";;
  *)         hosttype="${HOSTTYPE}";;
  esac


export MAKE="/bin/make -j8";


package_names=(
    "blackscholes"
    "bodytrack"
    "facesim"
    "ferret"
    "fluidanimate"
    "freqmine"
    "raytrace"
    "swaptions"
    "vips"
    "x264"
    "canneal"
    "dedup"
    "streamcluster"
     );

packages=(
    "apps/blackscholes"
    "apps/bodytrack"
    "apps/facesim"
    "apps/ferret"
    "apps/fluidanimate"
    "apps/freqmine"
    "apps/raytrace"
    "apps/swaptions"
    "apps/vips"
    "apps/x264"
    "kernels/canneal"
    "kernels/dedup"
    "kernels/streamcluster"
     );
package_binary=(
    "blackscholes"
    "bodytrack"
    "facesim"
    "ferret"
    "fluidanimate"
    "freqmine"
    "rtview"
    "swaptions"
    "vips"
    "x264"
    "canneal"
    "dedup"
    "streamcluster"
)

pacal_lib_paths=()
# parsecmgmt -a fullclean -p all
# parsecmgmt -a fulluninstall -p all

for index in ${!packages[@]}; do
    package=${packages[$index]};
    binary=${package_binary[$index]};
    package_name=${package_names[$index]}


    parsecmgmt -a build -p $package_name -c gcc-pascal;

    my_personal_path="${hosttype}-${ostype}.gcc-pascal"
    binary_path="pkgs/$package/inst/$my_personal_path/bin/$binary"

    pacal_lib_path=$(ldd "$binary_path"  | grep libmanualinst.so)
    
   
    pacal_lib_paths+=("$pacal_lib_path")
done;


RED='\033[0;31m'
NO_COLOR='\033[0m'
GREEN='\033[0;32m'
for index in ${!pacal_lib_paths[@]}; do

    path=${pacal_lib_paths[$index]}
    package=${packages[$index]}
    message="$package  path:${pacal_lib_paths[$index]}"

    if [[ "$path" =~ .*"/libmanualinst.so".* ]]; then

        echo -e "$GREEN TEST PASS: $NO_COLOR $message"

    else
        
        echo -e "$RED ERROR: $NO_COLOR $message"
        
    fi

 
done;
