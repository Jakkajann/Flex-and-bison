%{
#include <stdio.h>
#include <stdlib.h>
%}

%union {
    char c;
}

/* Definição dos tokens */
%token NOME
%token CONTEUDO
%token CLASSE
%token PACOTE
%token AUTOR
%token TITULO

%type <c> texto capitulo configuracao identificacao documentoLatex
%type <c> principal inicio fim corpoLista secao subsecao corpo textoEstilo
%type <c> listas listaNumerada itensLItens itensLNumerada listaItens

/* Definição da Gramática */

%%
documentoLatex: 
    configuracao identificacao principal
;

configuracao: 
    CLASSE PACOTE
    | CLASSE
;

identificacao: 
    TITULO AUTOR
    | TITULO
;

principal: 
    inicio corpoLista fim
;

inicio: 
    '\' begin '{' document '}'
;

fim: 
    '\' end '{' document '}'
;

corpoLista: 
    capitulo secao subsecao corpoLista 
    |   corpoLista
;

capitulo: 
    '\' chapter '{' NOME '}' corpo capitulo 
    | '\' chapter '{' NOME '}'
;

secao: 
    '\' section '{' NOME '}' corpo secao
    | corpo
;

subsecao: 
    '\' section '{' NOME '}' corpo subsecao
    | corpo
;

corpo: 
    texto
    | texto corpo
    | textoEstilo corpo
    | listas corpo 
;

texto: 
    '\' paragraph '{' CONTEUDO '}' {;}
;

textoEstilo: 
    '\' bf '{' CONTEUDO '}'
    | '\' underline '{' CONTEUDO '}'
    | '\' it '{' CONTEUDO '}'
;

listas: 
    listaNumerada
    | listaItens
;

listaNumerada: 
    '\' begin '{' enumerate '}' itensLNumerada '\' end '{' enumerate '}'
;

itensLNumerada:  
    '\' item '{' CONTEUDO '}'
    | '\' item  '{' CONTEUDO '}' itensLNumerada
    | listas
;

listaItens: 
    '\' begin '{' itemize '}' itensLItens '\' end '{' itemize '}'
;

itensLItens: 
    '\' item '{' CONTEUDO '}'
    | '\' item '{' CONTEUDO '}' itensLItens
    | listas
;


%%

int main(int argc, char **argv) {

}