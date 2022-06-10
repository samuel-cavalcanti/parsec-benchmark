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


## Mudança para o OpenMP

### Alterado o Makefile
Para mudar para o OpenMP, primeiramente foi configurado o Makefile adicionando
uma nova versão que compila utilizando o OpenMP. Foi adicionado um Define para o
OpenMP o **OPENMP_VERSION** ,dessa forma podemos adicionar a nova feature sem alterar o código existente.


```Makefile
ifdef version
# nova versão adicionada
  ifeq  "$(version)" "openmp" 
	DEF := $(DEF) -DENABLE_THREADS -DOPENMP_VERSION
	CXXFLAGS := $(CXXFLAGS) -fopenmp
  endif

  ifeq "$(version)" "pthreads" 
    DEF := $(DEF) -DENABLE_THREADS
    CXXFLAGS := $(CXXFLAGS) -pthread
  endif
  ifeq "$(version)" "tbb"
    DEF := $(DEF) -DENABLE_THREADS -DTBB_VERSION
    LIBS := $(LIBS) -ltbb
  endif
endif
```

### Adicionado novas linhas de código

Com o define **OPENMP_VERSION**, foi incluído a lib **#include <omp.h>**

```c++
#ifdef ENABLE_THREADS
#include <pthread.h>
#define MAX_THREAD 1024

#ifdef OPENMP_VERSION

#include <omp.h>

#endif // OPENMP_VERSION
...
```
Na versão pthreads observamos que nos laços for utilizados,
a lib pthreads chama a função **worker** com o parâmetro sendo a referência do **threadIDs[i]**. 

```c++
	int threadIDs[nThreads];
        for (i = 0; i < nThreads; i++) {
          threadIDs[i] = i;
          pthread_create(&threads[i], &pthread_custom_attr, worker, &threadIDs[i]);// thread_id
        }
        for (i = 0; i < nThreads; i++) {
          pthread_join(threads[i], NULL);
        }

	free(threads);
```
por tanto, para usarmos o OpenMP, foi utilizado o pragma omp
sendo que é passado para ele o número threads que deve ser utilizado: num_threads(nThreads), sendo nThreads um parâmetro
que passado por linha de comando.

```c++
#ifdef OPENMP_VERSION

  #pragma omp parallel for num_threads(nThreads) 
  for (i = 0; i < nThreads; i++)
  {
    int thread_id =  omp_get_thread_num();
    printf("Call worked on thread id: %i\n",thread_id);// test
    worker(&thread_id);
  }

#endif // OPENMP_VERSION

```


## integração com parsec

Por fim a aplicação é integrada com o **parsec** criando o arquivo de configuração chamado [gcc-openmp.bldconf](.../../../pkgs/apps/swaptions/parsec/gcc-openmp.bldconf)
nele é passado as configurações de compilação que informa
ao Makefile que a versão utilizada nessa compilação é o openmp.
```shell
...
# Environment to use for configure script and Makefile
build_env="version=openmp"# modificação 
```
Basicamente esse arquivo é uma copia do arquivo de configuração do
[gcc-pthreads.bldconf](.../../../pkgs/apps/swaptions/parsec/gcc-pthreads.bldconf), mudando o valor da variável version
para **openmp**

## Compilação e testes iniciais

Sabendo que o porte para OpenMP está configurado com o parsec,então para a compilação do projeto usando OpenMP é usando a linha de comando:

```shell
parsecmgmt -a build -c gcc-openmp -p swaptions
```

Para execução de do projeto usando o openmp, é necessário passar o
parâmetro **-c gcc-openmp**, um exemplo de comando seria assim:

```shell
parsecmgmt -a run -p swaptions -i simsmall -c gcc-openmp -n 8
```
no exemplo a cima o swaptions é executado usando o os dados de entrada simsmall e passando o número de threads igual a 8, **-n 8**.


## Referências
https://ppc.cs.aalto.fi/ch2/openmp/