# PASCAL-PARSEC

Exemplo:

```bash
parsecmgmt  -a run -p swaptions -c gcc-pascal
```

Para compilar as aplicações do parsec com pascal foi expendido
o parsec adicionando uma nova flag: **-c gcc-pascal** para o parsec
e adicionado um novo define: **ENABLE_PASCAL_HOOKS**  para que é
inserido ao passar a flag -c gcc-pascal no pascal.


## Portando aplicações para o PARSEC

Com essa nova flag você precisa fazer duas coisas. Primeiro você precisa
criar um arquivo configuração chamado *gcc-pascal.bldconf* na pasta **parsec**
da aplicação de interesse, se baseie no arquivo do swaptions: [swaptions gcc-pascal.bldconf](pkgs/apps/swaptions/parsec/gcc-pascal.bldconf). Segundo você precisa portar o código para o PASCAL utilizando o novo define.
Exemplo:

```c++
// usando o novo define para incluir o pascalops.h
#ifdef ENABLE_PASCAL_HOOKS
#include <pascalops.h>
#endif

// usando o novo define para iniciar a região de interesse
#ifdef ENABLE_PASCAL_HOOKS
  pascal_start(1);
#endif

// usando o novo define para finalizar a região de interesse
#ifdef ENABLE_PASCAL_HOOKS
  pascal_stop(1);
#endif
```

Dica o parsec, possui a sua biblioteca de hooks semelhante ao pascal.
procure por ***__parsec_roi_begin*** e  ***__parsec_roi_end*** nos códigos
fontes e adicione o *pascal_start* e *pascal_stop*.
Veja o arquivo  [HJM_Securities.cpp)](pkgs/apps/swaptions/src/HJM_Securities.cpp) do swaptions como exemplo.


## Dicas git

esse é um dos meus repositórios [github.com/samuel-cavalcanti/parsec-benchmark](https://github.com/samuel-cavalcanti/parsec-benchmark), mais especificamente a branch pascal-parsec desse repositório.

Para utilizar começar a trabalhar nele use os comandos:

```bash
# baixando o repositório
git clone https://github.com/samuel-cavalcanti/parsec-benchmark

#mudando a branch para pascal-parsec
git checkout pascal-parsec
```


## exemplo de compilação

[![Watch the video](https://img.youtube.com/vi/tC5cU_M9zYw/maxresdefault.jpg)](https://youtu.be/tC5cU_M9zYw)
