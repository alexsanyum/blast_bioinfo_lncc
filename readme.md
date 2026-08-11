---
title: "Trabalho de bininfo LNCC BLAST"
description: "Respositorio para apresentacao do programa BLAST"
author: "Alex Sanchez Yumbo"
data: 2026-25-08

---
# BLAST na linha de comando

Neste repositorio, apresentamos a ferramenta para BLAST na linha de comnado como atividade avaliativa da disciplina ''Introdução a Biologia Computacional e Bioinformática''

## 1. Contexto Biológico

Basic Local Aligment Search Tool (BLAST) e a farramenta de busca de sequencias por similiaridare mais usadas. Ela permite a busca de sequencias por similaridade na sua sequencia de ADN, ARN, e amino acidos. A travez desta ferramente, é possivel fazer uma exploracao sob a informacao dispinivel de uma sequencia nova, o parte dela [https://www.ncbi.nlm.nih.gov/books/NBK279670/]. Tambe, permite realizar analizas mais detalhas entre grupos de sequences, como determinicao de homologia de genes, com base nas metricas de alinamento fornecida pelo BLAST. A BLAST esta disponivel em um servidor web que permite realizar a busca de sequencias com bancos de dados disponivels no National Center Biotecnlongy Information, retornando nao so a grau de similitude com uma sequencia especica, mais tambem fornece metricas se dita similitude for aletaroria, a travez do e-value. 

Sem embargo, a opcao em linea tem limitaoes em projetos de grande escale, seja por que os bancos de dados disponiveis nao sao adaptaveis a pergunta de pesquisa (organismos pouco estudas, uso de dados sensiveis nao disponiveis), ou por sua limitacao de numero de sequencias que pode procesar. Entao, a ferramente BLAST tambem esta disponivel para ser usado de manera local, a travez do toolkit ncbi-cxx-toolkit, que contem o ncbi-blast+. Neste trabalho, abordamos de manera pratica o uso do blast de maneira local, pasando por as diversas formas de instalacao, sues programas, e o fluxo de trabalho 

## 2. Algoritmo

O BLAST, basease a busca por similareide no alimanente local de duas sequencias, e a indexadao de k-mer em tabelas hash para a busca extensao nos bancos de dados disponiveis. o 

Respecto sob o alinamente, o BLAST usa um algoritmo de alineamento que cria uma matrix de puntuacao de paara o alineamento de sequencias. Nesta matriz e prenchida com custo para match, mismathc, e gap, determinando o alimaneto e um score. 

Sob a busca no banco de dados, o programa usa um metodo heuristico de busca. Antes de alineamento, a sequencia desconhecida (query), e duvidida em sub strings de um tamanho fixo (k-mers). Cada k-mer e buscado no banco de dados usando uma tabela hash, ate o score de alimente cair de um certo threshold. 

O pacote do blast comtem os sequenfes programas

| **Program** 	| **Query type** 	| **Subject type** 	|
|-------------	|----------------	|------------------	|
| blastn      	| nucleotide     	| nucleotide       	|
| blastp      	| protein        	| protein          	|
| blastx      	| nucleotide     	| protein          	|
| tblastn     	| protein        	| nucleotide       	|

The last two involves addiotnal trnaslation algoriths that will briefly mentioned. Blastx first generate a list of possible translated aminoacid sequences based on a certain algorithm before performing the search. tblastn, the subject sequences is translated at search time. 

## 3. Requisitos computacionais

Na documentacao do NCBI 

## Arquivos entrada e saida
Arquivo de entrada
- Un arquivo com a sequencia(s) "desconhecida", query

- (Opcional) Um arquivo com a sequenca(s) com o qual serao comparadas, subject
- Ou, o nome do banco de dados na qual sera realizada a busca por similaridade, e comtem as sequencias subjec
  
Saida
No standard output, tem se os resultados dos alineamentos das sequencias de query com as de subject, no formato especificado. Por padrao, o mesmo visualizado no servidor web

## Execucao 


## Monitoramento

## Logs e erros

## Autumação

## GitHub

## Interpretação de resultados

## Metrica estatistica

## Limitações 

## Referencias


