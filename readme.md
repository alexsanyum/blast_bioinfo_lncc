---
title: "Trabalho de bininfo LNCC BLAST"
description: "Respositorio para apresentacao do programa BLAST"
author: "Alex Sanchez Yumbo"
data: 2026-25-08
---

# BLAST na linha de comando

Neste repositório, apresentamos a ferramenta para BLAST na linha de comando como atividade da disciplina "Introdução à Biologia Computacional e Bioinformática".

## 1. Contexto Biológico

O Basic Local Alignment Search Tool (BLAST) é a ferramenta mais utilizada para a busca de similaridade local entre sequências biológicas (1). Ele alinea uma sequência(s) de interesse, seja DNA, RNA, ou proteína, contra bancos de dados de sequências já caracterizadas, permitindo explorar as informações disponíveis para essa sequência (ou parte dela) (1,2). Esta abordagem inicial possibilita identificar se a sequência já foi descrita em outros organismos e quais informações estão associadas a ela. Por meio das similaridades entre as sequências, é possível inferir funções biológicas, classificação taxonômica e outras propriedades com base no conhecimento previo, fornecendo uma fonte de informação para análises mais aprofundadas (3).

O BLAST está disponível em um servidor web que permite realizar a busca de sequências nos bancos de dados do National Center for Biotechnology Information (NCBI). No entanto, a interface web apresenta limitações em projetos de grande escala, seja porque os bancos de dados disponíveis não são adaptáveis a perguntas específicas de pesquisa (organismos pouco estudados, dados sensíveis ou não públicos, etc.) ou devido às restrições de processamento do próprio servidor (4). Nestes casos, o BLAST pode ser executado localmente por meio do pacote ncbi-blast+. Neste trabalho, abordamos de maneira prática o uso do BLAST local na linha de comando, mostrando o uso básico dos principais programas ( ```blastn```, ```blastp```, ```blastx```, ```makeblastdb```).

## 2. Algoritmo
O BLAST baseia a busca de similaridade das sequências usando uma estratégia de seed-and-extend com matrizes de pontuação definidas. Para entender o processo, é importante definir dois tipos de sequência:
* Sequência query: Nossa sequência-alvo, que é desconhecida e a qual queremos comparar com bancos de dados.
* Sequência subject: A sequência (ou sequências) na qual realizamos a busca por similaridade. Elas conformam os bancos de dados.

### 2.1 Alinhamento de sequências
Antes do BLAST, o alinhamento de sequências era realizado por algoritmos como Needleman-Wunsch (global) e Smith-Waterman (local). Embora esses métodos garantam um alinhamento ótimo e satisfaçam as demandas iniciais, exigiam um alto custo computacional. Nesse contexto, o BLAST utiliza uma abordagem heurística que busca obter resultados próximos aos desses algoritmos, mas de forma mais rápida (5).

Para pontuar um alinhamento de duas sequências, o processo baseia-se em uma matriz. Essa matriz atribui pesos para casos de coincidência (match), diferenças (mismatch) e vazios/saltos (gaps) para sequências de DNA, ou matrizes de substituição (como BLOSUM ou PAM) para sequências de aminoácidos (6). Em ambos os casos, a ideia central é pontuar as coincidências e penalizar as diferenças e gaps. A Figura 1 exemplifica uma matriz de alinhamento mostrando o cálculo do score.

**Figura 1.** Matriz de alinhamento de duas sequências (PNHIGD vs. PTHIKWGD). Cada evento (match, mismatch, gap) possui uma pontuação previamente definida. Com a matriz preenchida, busca-se o caminho com os maiores scores (ressaltado com setas). Figura retirada de (7).

### 2.2 Algoritmo do BLAST
O BLAST é amplamente utilizado para a busca em grandes bancos de dados biológicos (como os do NCBI), nos quais o alinhamento par a par exato torna-se computacionalmente inviável. Na Figura 2, mostra-se um exemplo do processo de alinhamento de uma sequência de aminoácidos.

**Figura 2.** Processo de alinhamento heurístico do BLAST para sequências de aminoácidos. (1) leitura de query e formação dos k-mers. (2) busca e seleção das palavras vizinhas, com pontuação acima do limiar. (3) extensão do alinhamento a partir do sítio onde os k-mers e seus vizinhos foram encontrados. Figura adaptada de (8).

Na primeira etapa, a sequência query é dividida em subfragmentos de tamanho fixo chamados k-mers ou palavras (words). O tamanho dessa “palavra” é definido pelo parâmetro word size, com valores padrões de 28 e 3 para sequências de DNA e aminoácidos, respectivamente. O BLAST cria uma tabela hash na qual as palavras atuam como chaves, com o objetivo de melhorar o desempenho de consulta das posições e pontuações de cada palavra.

Em vez de alinhar a sequência completa logo no início, o algoritmo busca cada palavra contra as sequências do banco de dados (subject). O alinhamento só é processado em sequências que contêm essa palavra ou variações similares, chamadas palavras vizinhas (neighborhood words), para sequências de proteínas (em DNA busca coincidências exatas). A ocorrência de uma dessas palavras no banco de dados é chamada de hit (5).

O conceito de palavra vizinha significa que o algoritmo gera um hit não apenas com a palavra exata, mas também com palavras semelhantes para sequências de proteínas. Por exemplo, se uma das palavras for PQG, seus vizinhos podem ser PEG, PMG, PQA, entre outros. Cada um desses vizinhos (incluindo a palavra original) recebe uma pontuação obtida a partir das matrizes de substituição. O BLAST considera como hit as sequências no banco de dados que contêm o k-mer exato (em sequências de DNA) ou qualquer vizinho cuja pontuação supera um limiar pré-estabelecido (em proteínas) (5,6).

Quando um hit é encontrado no banco de dados, o algoritmo passa para a etapa de extensão (seed extension) expandindo o alinhamento nas duas direções. No início, essa extensão ocorre sem gaps (gap-free extension) e, depois, com gaps (gapped extension). À medida que o alinhamento é estendido, o score é continuamente recalculado, e se a pontuação cair abaixo de um determinado limite, a extensão é interrompida (5,8).

Em resumo, o BLAST não realiza uma busca exaustiva no banco de dados. Ele identifica regiões sementes (iguais ou muito semelhantes a subfragmentos da query) e, somente quando encontra essas coincidências, estende o alinhamento. Dessa forma, o algoritmo reduz o espaço de busca e o tempo de processamento necessário.

### Pacote ncbi-blast+
Para o uso em linha de comando, o BLAST disponibiliza o pacote de ferramentas ncbi-blast+ que contém diferentes programas de alinhamento a depender dos tipos de sequências comparadas (9):

| **Programa** | **Tipo de Query** | **Tipo de Subject** |
|---|---|---|
| `blastn` | Nucleotídeo | Nucleotídeo |
| `blastp` | Proteína | Proteína |
| `blastx` | Nucleotídeo | Proteína |
| `tblastn` | Proteína | Nucleotídeo |

Os programas `blastx` e `tblastn` envolvem passos adicionais de tradução da sequência de nucleotídeos para proteínas antes de realizar o alinhamento.

O BLAST é amplamente utilizado para a busca em grandes bancos de dados biológicos (como os do NCBI), nos quais a alinhamento par a par exato torna-se computacionalmente inviável.  Na Figura 2, mostra-se um exemplo do processo de alinhamento de uma sequência de aminoácidos. 


Figura 2. Proceso de alineamiento heurístico do BLAST para secuencias de aminoácidos. (1) leitura de query e formação dos k-mers. (2) busca e seleção das palavras vizinhas, com pontuação acima do limiar.(3) extensão do alinhamento a partir do sítio onde os k-mers e seus vizinhos foram encontrados. Figura adaptada de (8)

Na primeira etapa, a sequência query é dividida em sub fragmentos de tamanho fixo chamados  k-mers ou palavras (words). O tamanho dessa “palavra” é definido pelo parâmetro word size, com valores padrões de 28 e 3 para sequências de DNA e aminoácidos, respectivamente. O BLAST cria uma tabela hash na qual as palavras atuam como chaves, com o objetivo de melhorar o desempenho de consulta das posições e pontuações de cada palavra. 
Em vez de alinhar a sequência completa logo no início, o algoritmo busca cada palavra contra as sequências do banco de dados (subject). O alinhamento só é processado em sequências que cometem essa palavra ou variações similares, chamadas palavras vizinhas (neighborhood words), para sequências de proteínas (em DNA busca coincidências exatas) . A ocorrência de uma dessas palavras no banco de dados é chamada de hit (5).
	O conceito de palavra velhinha significa que o algoritmo gera um hit não apenas com a palavra exata, mas também com palavras semelhantes para sequências de proteínas. Por exemplo, se uma das palavras for PQG, seus vizinhos podem ser PEG, PMG, PQA, entre outros. Cada um desses vizinhos (incluindo a palavra original) recebe uma pontuação obtida a partir das matrizes de substituição. O BLAST considera como hit as sequências no banco de dados que contém o k-mer exato (em sequências de DNA) ou qualquer vizinho cuja pontuação supera um limiar pré-estabelecido (em proteínas) (5,6). 
	Quando um hit é encontrado no banco de dados, o algoritmo passa para a etapa de extensão (seed extension) expandindo o alinhamento nas duas direções. Ao início, essa extensão ocorre sem gaps (gap-free extension) e, depois com gaps (gapped extension). À medida que o alinhamento é estendido, o score é continuamente recalculado, e se a pontuação cair abaixo de um determinado limite, a extensão é interrompida (5,8). 
Em resumo, o BLAST não realiza uma busca exaustiva no banco de dados. Ele identifica regiões sementes (iguais ou muito semelhantes a sub fragmentos da query) e, somente quando encontra essas coincidências, estende o alinhamento. Dessa forma, o algoritmo reduz o espaço de busca e o tempo de processamento necessário. 


| **Program** 	| **Query type** 	| **Subject type** 	|
|-------------	|----------------	|------------------	|
| blastn      	| nucleotide     	| nucleotide       	|
| blastp      	| protein        	| protein          	|
| blastx      	| nucleotide     	| protein          	|
| tblastn     	| protein        	| nucleotide       	|

The last two involves addiotnal trnaslation algoriths that will briefly mentioned. Blastx first generate a list of possible translated aminoacid sequences based on a certain algorithm before performing the search. tblastn, the subject sequences is translated at search time. 

## 3. Requisitos computacionais

Na documentacao do NCBI, tem as seguentes dependencias 
SQLite: a partirBLAST+ 2.15.0
LMDB: a partirBLAST+ 2.7.1
Zstandard: a partirBLAST+ 2.17.0
Bzip2: a partirBLAST+ 2.17.0
Zlib: starting with BLAST+ 2.17.0

Para windows
Visual Studio 2015 C++ redistributate runtime package

## Arquivos entrada e saída
**Arquivo de entrada**
- Um arquivo FASTA contendo as sequências query;
- Um arquivo FASTA com a sequência(s) subject ou o nome do banco de dados na qual será realizada a busca.
  
**Saída**
No standard output, tem se os resultados dos alinhamentos das sequências de query com as de subject, no formato especificado. O formato de saída padrão é o mesmo visualizado no servidor web. Se o parametro ```-out``` é usado, ou a standard output é redirreccionado com ```>``` o resultado sera savo em um arquivo de texto

## Execucao

### Instalação

O pacote de programas do ncbi-blast+ esta disponivel por deferentes canais de instalacao, e geralmente esta disponivel como modulos em ambentes de HPC. Se recomenda revisar as deferentes formas de instalacao acorde aos recursos disnpoveils. Listamos aqui algumas formas de sua instalacao:
- ```apt install```: Disponivel como pacote a travez de apt
- ```conda install```: Disponivel em deferentes canais de conda como bioconda (ultima versao ate 08/2026 2.17.0)
- Disponivel em ```ftp``` do ncbi: [ncbi-blast+](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.17.0/)
- GitHub: O toolkit ```ncbi-c++-toolkit``` esta disponivel em GitHub, com programas adicionais  

### Uso 'basico'
Os tres programas requerem um arquivo query de entrada, y um outro arquivo subject, ou o nome do banco de dados (caso esteje dispinivel) no qual sera usada como subject. 

Blast com dois arquivos fasta
~~~bash
blast<n,p,x> -query <fasta_input.fasta> -subject <subject.fasta>
~~~

Blast com um arquivo fasta e um banco de dados
~~~bash
blast<n,p,x> -query <fasta_input.fasta> -db <path_to_blast_db>
~~~

Se não for definido, o resultado sera mostrado no *standard output* que pode ser redireccionado usando '>'. Tambem, tem o parametro '-out'.

~~~bash
blast<n,p,x> -query <fasta_input.fasta> -db <path_to_blast_db> -out <out_file_name>
~~~

### Formato de saida

O programa pode mostar e devolver o resultado dos alineamentos em diferentes formatos. Este é controlado com o parametro ```outfmt``` que aceita valores de 0-18. O valor por defeito devolta um resultado visual do alineamento (similar aos resultados individuals feitos no site do blast). Para usos de filtragem, control de qualidade, é comunmente usado o formato tabular 6, permitendo tambem customizar as columas a mostrar. Sem embargo, nao mostra os labels das columas (nao tem uma columa de header). O formato 7 tambem é tabular, mais contem muitas linhas intermedias de comentarios. 

Acorde na dacomentacao [REF blast], se as columnas não sao especificas, eles sao mostradas no seguente orden por padrao

| Nome     	| Descrição                                                                                    	|
|----------	|----------------------------------------------------------------------------------------------	|
| qseqid   	| Identificador da sequência query (valor extraído do cabeçalho da sequência em formato FASTA) 	|
| sseqid   	| Identificador da sequência subject                                                           	|
| pident   	| Porcentagem de identidade                                                                    	|
| length   	| Tamanho do alinhamento                                                                       	|
| mismatch 	| Número de mismatches (desemparelhamentos)                                                    	|
| gapopen  	| Número de aberturas de gaps                                                                  	|
| qstart   	| Posição inicial do alinhamento na sequência query                                            	|
| qend     	| Posição final do alinhamento na sequência query                                              	|
| sstart   	| Posição inicial do alinhamento na sequência subject                                          	|
| send     	| Posição final do alinhamento na sequência subject                                            	|
| evalue   	| E-value (valor estatístico)                                                                  	|
| bitscore 	| Score de alinhamento normalizado                                                            	|


Na linha de comando
~~~bash
blast<n,p,x> -query <fasta_input.fasta> -db <path_to_blast_db> \
            -out <out_file_name> \
            -outfmt 6 'qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore' 
~~~

### Create blast database with ```makblastdb```

É possivel criar un banco de dados con nossas propias sequencias a partir de um arquivo fasta usando ```makblastdb```. Esto programa indexara en un banco de datos, permitendo agilizar os alineamentos. Criar um banco de dados BLAST é recomendado en usos frequentes con grandes volumnes de dados. Para alineamentos e consultas rapidas, o uso com -subject devolve o mesmo resultado. 

A proceso de criar o banco de dados cria varios arquivos asociados ao banco de dados (;ndb, .nhr, .nin. njs. not, .nsq, .ntf, .nto), pelo que é recomendado colocar o banco de dados em um directorio especidico. 

Para criar a partir de um arquivo fasta
~~~bash
makeblastdb -in <subject.fasta> -dbtype <nucl,prot> -out <output_path/db_name> 
~~~

Uma vez terminado ele, o programa devolve no standard output o tempo que levo criar o banco de dados, as sequencias que foram indexedas, e seu nome.

## Monitoramento

Como tal, o programa nao mostra no standard output um mensagem de progreso das sequencias que foram analizadas. Se todo ocurrer con normalidade, blast<n,x,p> os programas nao mostraran ninguem mensagem por si sos. Ainda ocurrece um error, como interupcao da execucao, nao sera mostrado. Assim, o monitoreamento devera ser feito por parte do usuaria (ou desenvolvedor), adicionando mensagemes que permitan conhcer o progreso por arquivo (se for o caso) e blocos de verificador se o arquivo de resultado foi gerado.

## Logs e erros
Os programas blast<n,x,p> tem um certo nivel de controlo sobre a formatacao do arquivo fasta que poden levantar avisos ou deter a execucao do programa. O o programa espera que as sequencias tenhan o formato de cabezalio (denotado com >) seguido das sequencias que pode estar divida em multiples linhas. Os testes mostrarom que ele exclui as linhas em blanco e as que inician com #, usado como comentario. Se houver uma lina fora dessa notacao, o programa tentara identificar se se trata de alguma sequencia e mostrara um aviso sobre una sequencia na qual nao consigio extrair o nome ou a sequencia. Se nao conseguir, o programa a execucao vai serdetemida

Quando o execucao finaliza sem interupcoes


Quando o execucao e interrumpida (e.g. Ctrl + c)




## Autumação

O blast<x,p,n> tem o parametro ```num_threads``` que permite definir o numero de threas para a busca em paralel. Para multiplos arquivos, é possivel usar um nucle for. 


## GitHub


## Interpretação de resultados
Dos resultados do formato tabular Por cada aline temos a locacao exata de em que sequencias e regions (subjext start sucject end) se alienearon nossas sequencias (query start, end).
Alem desso, temos o porcentage de identidate, que é o percentage de posiciones com nucleotidos/amino acidos identicos na secao que se alineo. 
Lenght, comprimento da regions alineada, tambem denotada como tamano de overlap

Com estos resultados, temos a informcao de com que sequencias dentro do banco (ou subject utilizado) se alinearon nossas sequencias, assim como as coordenadas onde se alinearon as sequencias, o porcentage de identiade nessa region, mismatch, e gaps. 

Com essas informoces, junto com o metada asociada al banco de dados, e possivel asignar anotacoes, homologia, identificaco, etc. Alem dessas metricas da alineacao, tem se o e-value, e o bit-score

## Metrica estatistica
O bit-score é o puntagem obtido do alineamento, usado na conta do e-value. Ele é obtido apartir da normalizacao raw aligment, que é o puntagem obtido a partir da matrix de pesos para mathc, mismatch, e gaps. Como ele pe normalizado respecto ao sistema de puntuacao, pode ser comparado entre diferentes buscas. 

O e-value (expect value), descrive o numero de sequencias (do conjunto do subject) na qual  minha sequencia é esperada (expect) de alinear com o mesmo score por aletoriedade. Tem em conta nao so o score de alineamento, mais tambem o tamanho do banco de dados na qual esta se efetuando a busqueda. Tenta responder nocoes como: esta alineacao foi gerada por que as duas sequencias sao realemnte parecidas, ou por mera casualidade.

O e-value, ao ter em conta o score de alinacao, e o tamanho de banco de dados, e usado comumnete coomo filtro de "qualidade" da alinecao. Junto com o porcentagem de identidade, tamanho, e outros score, é usad o para filter alineacoes.

## Limitações 
O Blast é uma ferramente versatil mais que tem suas limitatoes. Ao ser baseado em alineamento local, ele nao é recomendadl para alinear sequencias longas (e.g. genomas completos). 
O seu uso esta limitado para fazer exploracoes o identificaco de sequencias, mais deve ser acompanhado de outras evidencias. 
O programa devolve metricas de que tao similares sao duas sequencias, e que tao boa é essa alineacao num conjunto de dados espeficos. Por si so, so asigna similaridade, nao homologia, tao aplicacao tem que ver com quais sequencias estao se comparando. 

## Exemplo pratico: Padronizacao de nomemclatura de genes por alineamento

Os genomas depositados do NCBI poden ser muito antigos, como muito recentes organismos da misma familia, e a forma em que eles foram anotados é diferentes. Em ocacoes, o mesmo gene pode ser sido anotado de maneiras deferentes ao longo do tempo. Esto gera problemas de extracao automatica de dados, onde ter um identificador, ou nome padronizado é importante para extrair information de diferentes genomas para um mesmo grupo taxonomico. 

Esto problema foi encontrado para genomas da familia de Orthopoxvirus, que recentemente tem uma nomemclatura de genes chamada de Orthopoxvrius genes (OPG). Sem embargo, nao todos os genomoas disponiveis estao baixo essa nomemclatura, pelo que foi necesario padrodinzarlos para o sistema OPG. Para isso, foi usado o BLAST coma  estrategia de anotocao. 

O arquivo OPG_genes.fasta contem sequencias de referencia com todos os OPG (com sua correspondiente nomemclatura). O arquivo ```fasta_files.tar.gz``` contem sequencias anotadas como genes correspondentes a 500 genomas da familia Orthopoxvirus. 

A estrategia for, (1) criar um banco de dados blast com os OPG_genes.fasta, e alinear os genes dos 500 genomas contra elas. Dessa forma, com um criterio de similaridade, asociar cada gene na mesma nomemclatura. Para isso, usa-se os filtros de %identidade >= 80%, coverage > 80%, e um e-value < 1e-5. 

Se a sequencia era alineado conta um dos genes OPG com esse criterio, pasaba a ter esse label. 


Na pasta ```src``` tem dois scripts. O script  ```install_blast_conda.sh.sh``` cria um ambente conda é instala em ele a ultima versao do blast. o Script ```running_example.sh``` vai criar o banco de dadas com o arquivo OPG_genes.fasta, e alinaer as sequencias contidas em ```fasta_files.tar.gz``` usando blastn.

Para rodar o exemplo, basta executar
~~~bash
bash src/install_blast_conda.sh
bash src/running_example.sh data blast_results
~~~

## Referencias


