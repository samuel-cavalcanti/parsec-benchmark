# Executando pascalanalyzer  no super computador

Primeiro clone o repositório na sua máquina:

```bash
git clone https://github.com/samuel-cavalcanti/parsec-benchmark.git
```

Dentro da pascal parsec-benchmark, mude o branch para pascal-parsec:

```bash
git checkout pascal-parsec
```

Execute os testes de compilação.

```bash
./test_gcc_pascal_build.sh
```
Os testes de compilação irão compilar todos os projetos,
portanto esse passo vai demorar um pouco. Aproveite
o tempo e leia a seção: [Testes de compilação](PASCAL_README.md#testes-de-compilação)
e baixe os dados de entrada.

### Dados de entrada

O parsec possui dois conjuntos de dados: simulation-input, native-input.
Para baixar e usar esses conjuntos execute o script [get-inputs](get-inputs).
No entanto, este projeto possui um outro conjunto de dados chamado **pascal-input**.

```bash
# para baixar as entradas simulation-input, native-input
# execute esse script na pasta raiz desse repositório
./get-inputs
```

Para baixar o o conjunto de dados do pascal-input faça o download
do arquivo: [parsec-3.0-input-pascal.tar.gz](https://drive.google.com/file/d/1Mk5KlmGuT64Fr-Rznapo65jG2_FRYDB-/view) e extraia
para a pasta raiz desse repositório, ou execute o script [get-pascal-inputs](get-pascal-inputs.sh).
Caso o link do mega não esteja disponível, procure na pasta: **/mnt/beegfs/scratch/input-pascal/**  do super pc no NPAD.

```bash
# para baixar as entrada pascal-input
# execute esse script na pasta raiz desse repositório
./get-pascal-inputs
```

### Executando um benchmark no NPAD

Sabendo que os pacotes foram compilados e os dados de entrada foram baixados.
Portanto para executar um pacote do parsec com pascalanalyzer no NPAD, foram criados
scripts na pasta [pascal-releases/bin](pkgs/libs/pascal-releases/bin/). Cada
script representa um workload.
Todos os workloads suportados estão na tabela: [Executados com input_pascal.tar](PASCAL_README.md#executados-com-input_pascaltar):

```bash
# Um exemplo de execução de um workload
sbatch ./pkgs/libs/pascal-releases/bin/swaptions_script.sh 
```