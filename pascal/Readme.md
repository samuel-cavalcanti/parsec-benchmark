# Analizando dados com pascalanalyzer

até o momento eu

## pascalanalyzer

baixei o pascalanalyzer no repositório https://gitlab.com/lappsufrn/pascal-releases e coloquei na sub pasta pascal-releases.
Adicionei no .**gitignore** essa pasta, pois não sei quando a licença do software em ter uma copia nesse repositório.   

## compilei o swaptions usando o pascal

Modifiquei o arquivo Makefile para habilitar a lib pthreads
limpei a antiga compilação com os comandos:
```shell
parsecmgmt -a fullclean -p all
parsecmgmt -a uninstall -p all
```
compilei com o swaptions:

```shell
parsecmgmt -a build -p swaptions
```

## Copiei o executável para a pasta pascal e seus argumentos

A compilação gera um arquivo executável chamado __swaptions__ na pasta __inst__.
Copiei o arquivo __swaptions__ e analizei os arquivos:

- [simsmall.runconf](../pkgs/apps/swaptions/parsec/simsmall.runconf)

- [simmedium.runconf](../pkgs/apps/swaptions/parsec/simmedium.runconf)

- [simlarge.runconf](../pkgs/apps/swaptions/parsec/simlarge.runconf)

- [native.runconf](../pkgs/apps/swaptions/parsec/native.runconf)

criando a primeira parte do shell script [run_parscal.sh](run_parscal.sh)

## finalizei o run_parscal.sh com informações da vídeo aula

Assistindo a vídeo aula, entendi que :

### o parâmetro **-c (core)**
especifica em qual core a aplicação sera executada, no nosso caso
quero que a aplicação utilize todos os cores, sem nenhuma limitação, por tanto não foi passado esse parâmetro 

### o parâmetro **-i (inputs)**
**-i INPUTS** ou **--ipts INPUTS** especifica os argumentos de entrada da aplicação swaptions, por tanto concatenei todas as entradas: simsmall, simmedium, simlarge, native no parâmetro
**--ipts**, sendo que como tenho  8 threads, em todos os parâmetros (simsmall, simmedium, simlarge, native) , foi passado **NTHREADS=8**

![aula_remota_exemplo_pascalanalyzer](aula_remota_exemplo_pascalanalyzer.png)

## teste na minha máquina

Apos criar o script [run_parscal.sh](run_parscal.sh), fui na
pasta **pascal-releases**, e adicionei o pascalanalyzer no meu ambiente:
```zsh
source pascal-releases/env.sh 
```
e executei o script
```zsh
./run_parscal.sh
```

gerando o arquivo [swaptions.json](swaptions.json)
