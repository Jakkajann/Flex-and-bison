%option noyywrap nodefault yylineno case-insensitive
%{
    /* Lista 1 exericio 4 :: Flex
       realiza scan e reconhecimento de identificadores na linguagem C */

    int chars = 0;
    int words = 0;
    int lines = 0;

    int totchars = 0;   
    int totwords = 0;
    int totlines = 0;

    struct palRes {
        char* nomePal;
        unsigned int qtdLida;
        struct ref *ref;
        struct palRes* nextPal;
    };


    struct ref {
        char* fileName;
        unsigned int linha;
        struct ref* nextRef;
    };

    struct palRes* pRes = NULL;
    char* currentFile;

    struct ref* alocaReferencia(char* currentFile, unsigned int linha);
    struct palRes* alocaPalavraReservada(char* currentFile, unsigned int linha,char* nomePal);
    void addRef(char* currentFile, unsigned int linha, char* palavra);
%}

NOVALINHA               [\n]+
ESPACO                  [a-zçãõéêôó\-,.;:\*áàâíìúûù" "]
NASA                    NASA
FASES                   FASES
LUA                     LUA
LINHA                   LINHA
HORIZONTE               HORIZONTE
GRAVIDADE               {ESPACO}+GRAVIDADE+{ESPACO}+
LINHAHORIZONTE          {ESPACO}+{LINHA}+{ESPACO}+{HORIZONTE}+{ESPACO}+
FASESLUA                {ESPACO}+{FASES}+{ESPACO}+{LUA}+{ESPACO}+
FARSANASA               FARSA+{ESPACO}+{NASA}+

%%

{NOVALINHA}         ;
{GRAVIDADE}         { addRef(currentFile, yylineno, yytext); }
{LINHAHORIZONTE}    { addRef(currentFile, yylineno, yytext); }
{FASESLUA}          { addRef(currentFile, yylineno, yytext); }
{FARSANASA}         { addRef(currentFile, yylineno, yytext); }
.


%%

struct ref* alocaReferencia(char* currentFile, unsigned int linha) {
    struct ref* pr = (struct ref*)malloc(sizeof(struct ref));
    if(!pr) { return NULL; }
    pr->nextRef = NULL;
    pr->linha = linha;
    pr->fileName = currentFile;
    return pr;
}

struct palRes* alocaPalavraReservada(char* currentFile, unsigned int linha, char* nome) {
    struct palRes* p = (struct palRes*)malloc(sizeof(struct palRes));
    if(!p) { return NULL; }
    p->nomePal = strdup(nome);
    p->qtdLida = 0;
    p->ref = alocaReferencia(currentFile, linha);
    p->nextPal = NULL;
    return p;
}

void addRef(char* currentFile, unsigned int linha, char* palavra) {
    struct ref* pRef = NULL;
    struct palRes* p = pRes, *p2;
    if(!p) {
        p2 = alocaPalavraReservada(currentFile, linha, palavra);
        pRes = p2;
        return;
    }
    while(p) {
        if(p->ref->linha == linha && !strcasecmp(p->nomePal, palavra) && p->ref->fileName == currentFile) {
            return;
        }
        if(!strcasecmp(p->nomePal, palavra)) {
            pRef = p->ref;
            while(pRef->nextRef) { pRef = pRef->nextRef; }
            pRef->nextRef = alocaReferencia(currentFile, linha);
            return;
        }
        if(p->nextPal)
            p = p->nextPal;
        else
            break;
    }
    p->nextPal = alocaPalavraReservada(currentFile, linha, palavra);
}


int main(argc,argv) 
int argc;
char **argv;
{   
    int i;
    struct palRes* p = pRes;
    struct ref* r = NULL;

    for(i = 1; i < argc; i++) {
        currentFile = argv[i];
        FILE *pFile = fopen(argv[i],"r");

        if(!pFile) {
            perror(argv[i]);
            return 1;
        }
        yyrestart(pFile);
        yylineno = 1;
        yylex();
        fclose(pFile);
        // printf("%d %d %d %s\n", lines, words, chars, argv[i]);
        totchars += chars; chars = 0;
        totwords += words; words = 0;
        totlines += lines; lines = 0;
    }
    if(argc > 1) {
        for(p = pRes; p; p = p->nextPal) {
            int j = 0;
            printf("%s\n", p->nomePal);
            for(r = p->ref; r; r = r->nextRef) {
                printf(" ( %s ){ %d }\n", r->fileName, r->linha);                  
            }
            printf("\n------------------------------------------------------------------------------------------------------------------------------------------\n");
        }
    }
    return 0;
}