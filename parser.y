%{ 
#include "semantico.h"
%}
 
//VARIÁVEIS USADAS NO LÉXICO
%union { 
    int    numValue; 
    char  *stringValue; 
    struct node   *nodeValue;
    struct nodeList   *nodeValueList; 
} 
 
//INÍCIO DA GRAMÁTICA
%start  program; 
  
%type <nodeValue> program 
%type <nodeValue> declaration-list 
%type <nodeValue> declaration 
%type <nodeValue> var-declaration 
%type <nodeValue> type-specifier 
%type <nodeValue> fun-declaration 
%type <nodeValue> params 
%type <nodeValue> param-list 
%type <nodeValue> param 
%type <nodeValue> compound-stmt 
%type <nodeValue> local-declarations 
%type <nodeValue> statement-list 
%type <nodeValue> statement 
%type <nodeValue> expression-stmt 
%type <nodeValue> selection-stmt 
%type <nodeValue> iteration-stmt 
%type <nodeValue> return-stmt 
%type <nodeValue> expression 
%type <nodeValue> var 
%type <nodeValue> simple-expression 
%type <nodeValue> relop 
%type <nodeValue> additive-expression 
%type <nodeValue> addop  
%type <nodeValue> term  
%type <nodeValue> mulop  
%type <nodeValue> factor 
%type <nodeValue> call 
%type <nodeValue> args 
%type <nodeValue> arg-list 
%type <nodeValue> empty 

//declaração de tokens usados no lexico.l 
%token  <stringValue>    INT VOID IF WHILE ELSE RETURN 
%token  <stringValue>    PLUS MINUS TIMES DIVIDE 
%token  <stringValue>    OPEN_PAREN CLOSE_PAREN COMMA OPEN_KEY CLOSE_KEY END_LINE ATTRIB 
%token  <stringValue>    MINNOR_THEN MAJOR_THEN OPEN_BRACKET CLOSE_BRACKET 
%token  <numValue>       DIGIT 
%token  <stringValue>    ID 
%token  <stringValue>     LEQUAL EQUAL NEQUAL BEQUAL   
//associatividade a esquerda, maior precedencia de baixo pra cima 
%left PLUS MINUS 
%left TIMES DIVIDE 
%left EQUAL 
%left NEQUAL 
%left LEQUAL 
%left BEQUAL 
%left MINNOR_THEN MAJOR_THEN 
  
//----------------------------------------------------------------------------- 
%%  
//----------------------------------------------------------------------------- 
 
program           :            declaration-list                           {$$ = newnode("program",$1,NULL,NULL,NULL);raiz = $$;} 
                  ; 
 
declaration-list  :            declaration-list declaration               {$$ = newnode("declaration-list",$1,$2,NULL,NULL);}
                  |            declaration                                {$$ = $1;}
                  ; 
 
declaration       :             var-declaration                           {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             fun-declaration                           {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
var-declaration   :             type-specifier ID END_LINE                { 
                                                                            tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                            $$ = newnode("var-declaration",$1,ideNo,NULL,NULL);
                                                                          }

                  |             type-specifier ID OPEN_BRACKET DIGIT CLOSE_BRACKET END_LINE         {
                                                                                                      int count = $4;
                                                                                                      char name[20];
                                                                                                      sprintf(name, "%d", count); 
                                                                                                      tNode* nodoDigito = newnode(name,NULL,NULL,NULL,NULL);       
                                                                                                      tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                                                      $$ = newnode("var-declaration",$1,ideNo,nodoDigito,NULL);
                                                                                                    }
                  ; 
 
type-specifier    :             INT                                       {$$ = newnode("int",NULL,NULL,NULL,NULL);} 
                  |             VOID                                      {$$ = newnode("void",NULL,NULL,NULL,NULL);} 
                  ; 
 
fun-declaration   :             type-specifier ID OPEN_PAREN params CLOSE_PAREN compound-stmt        {
                                                                                                        tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                                                        $$ = newnode("fun-declaration",$1,ideNo,$4,$6);
                                                                                                        checkMain($$);
                                                                                                      }
                  ;            
 
params            :             param-list                                              {$$ = newnode("params",$1,NULL,NULL,NULL);} 
                  |             VOID                                                    {$$ = newnode("params",NULL,NULL,NULL,NULL);} 
                  ; 
 
param-list        :             param-list COMMA param                                  {$$ = newnode("",$1,$3,NULL,NULL);} 
                  |             param                                                   {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);}   
                  ; 
param             :             type-specifier ID                                       { tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                                          $$ = newnode("param",$1,ideNo,NULL,NULL);} 
                  |             type-specifier ID OPEN_BRACKET CLOSE_BRACKET            {     
                                                                                              tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                                              tNode* noBrackets = newnode("\\[\\]",NULL,NULL,NULL,NULL);
                                                                                              $$ = newnode("param",$1,ideNo,noBrackets,NULL);
                                                                                        } 
                  ; 

compound-stmt     :            OPEN_KEY local-declarations statement-list CLOSE_KEY     {$$ = newnode("compound-stmt",$2,$3,NULL,NULL);} 
                  ; 
 
local-declarations:             local-declarations var-declaration                      {$$ = newnode("",$1,$2,NULL,NULL);} 
                  |             empty                                                   {} 
                  ; 
 
statement-list    :             statement-list statement                                {$$ = newnode("",$1,$2,NULL,NULL);} 
                  |             empty                                                   {} 
                  ; 
 
statement         :             expression-stmt                                         {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             compound-stmt                                           {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             selection-stmt                                          {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             iteration-stmt                                          {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             return-stmt                                             {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
expression-stmt   :             expression  END_LINE                                    { tNode* node = newnode(";",NULL,NULL,NULL,NULL);
                                                                                         $$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             END_LINE                                                {$$ = newnode(";",NULL,NULL,NULL,NULL);} 
                  ; 
 
selection-stmt    :             IF OPEN_PAREN expression CLOSE_PAREN statement                     {$$ = newnode("selection-stmt ",$3,$5,NULL,NULL);} 
                  |             IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement      {$$ = newnode("selection-stmt ",$3,$5,$7,NULL);} 
                  ; 
iteration-stmt    :             WHILE OPEN_PAREN expression CLOSE_PAREN statement                  {$$ = newnode("iteration-stmt",$3,$5,NULL,NULL);} 
                  ; 
 
return-stmt       :             RETURN END_LINE                                        {$$ = newnode("return-stmt",NULL,NULL,NULL,NULL);} 
                  |             RETURN expression END_LINE                             {$$ = newnode("return-stmt",$2,NULL,NULL,NULL);} 
                  ; 
 
expression        :             var ATTRIB expression                                  {$$ = newnode("=",$1,$3,NULL,NULL);} 
                  |             simple-expression                                      {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
var               :             ID                                                     { 
                                                                                        tNode* ideNo = newnode($1,NULL,NULL,NULL,NULL);
                                                                                        $$ = newnode("var",ideNo,NULL,NULL,NULL);} 
                  |             ID OPEN_BRACKET expression CLOSE_BRACKET               {
                                                                                        tNode* ideNo = newnode($1,NULL,NULL,NULL,NULL);
                                                                                        $$ = newnode("var",ideNo,$3,NULL,NULL);
                                                                                       }                    
                  ; 
 
simple-expression :             additive-expression relop additive-expression          {$$ = newnode($2->no,$1,$3,NULL,NULL);} 
                  |             additive-expression                                    {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
relop             :             LEQUAL                                                 {$$ = newnode("<=",NULL,NULL,NULL,NULL);} 
                  |             MINNOR_THEN                                            {$$ = newnode("<",NULL,NULL,NULL,NULL);} 
                  |             MAJOR_THEN                                             {$$ = newnode(">",NULL,NULL,NULL,NULL);} 
                  |             BEQUAL                                                 {$$ = newnode(">=",NULL,NULL,NULL,NULL);} 
                  |             EQUAL                                                  {$$ = newnode("==",NULL,NULL,NULL,NULL);} 
                  |             NEQUAL                                                 {$$ = newnode("!=",NULL,NULL,NULL,NULL);} 
                  ; 
 
additive-expression :         additive-expression addop term                    {$$ = newnode($2->no,$1,$3,NULL,NULL);} 
                    |         term                                              {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                    ; 

 
addop               :            PLUS                                           {$$ = newnode("+",NULL,NULL,NULL,NULL);} 
                    |            MINUS                                          {$$ = newnode("-",NULL,NULL,NULL,NULL);} 
                    ; 
 
term                :            term mulop factor                              {$$ = newnode($2->no,$1,$3,NULL,NULL);} 
                    |            factor                                         {$$ = newnode("",$1,NULL,NULL,NULL);} 
                    ; 
 
mulop               :            TIMES                                          {$$ = newnode("*",NULL,NULL,NULL,NULL);} 
                    |            DIVIDE                                         {$$ = newnode("/",NULL,NULL,NULL,NULL);} 
                    ; 
 
factor              :            OPEN_PAREN expression CLOSE_PAREN              {$$ = $2;}//{$$ = newnode("",$2,NULL,NULL,NULL);} 
                    |            var                                            {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                    |            call                                           {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                    |            DIGIT                                          { 
                                                                                  int count = $1;
                                                                                  char name[20];
                                                                                  sprintf(name, "%d", count); 
                                                                                  $$ = newnode(name,NULL,NULL,NULL,NULL); 
                                                                                } 
                    ; 
                         
call                :            ID OPEN_PAREN args CLOSE_PAREN                 {
                                                                                    tNode* ideNo = newnode($1,NULL,NULL,NULL,NULL);
                                                                                    $$ = newnode("call",ideNo,$3,NULL,NULL);
                                                                                } 
                    ; 
 
args                :            arg-list                                       {$$ = newnode("args",$1,NULL,NULL,NULL);} 
                    |            empty                                          {$$ = newnode("args",$1,NULL,NULL,NULL);} 
                    ; 
 
arg-list            :           arg-list COMMA expression                       {$$ = newnode("",$1,$3,NULL,NULL);}
                    |           expression                                      {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                    ; 
 
empty               :           %empty                                          {$$ = newnode("",NULL,NULL,NULL,NULL);} 
                    ; 
 
//----------------------------------------------------------------------------- 
%% 
//-----------------------------------------------------------------------------

int main( int argc, char *argv[] ) { 
  extern FILE *yyin; 
    raiz = newnode("",NULL,NULL,NULL,NULL);
    operacao = malloc(sizeof(tOperacao));

    scope = malloc(sizeof(tFuncScope));
    funcoes = malloc(1024*sizeof(tFuncScope));

    var = malloc(sizeof(tInfoVar));
    varGlobais = malloc(sizeof(tInfoVar));

  if( argc != 3){ 
    printf("Poucos argumentos!\n");
    return 1;
  }
 
  yyin = fopen(argv[1], "r"); 
 
  if (yyin == NULL){
    printf("Arquivo nao pode ser aberto: %s \n", argv[1]);
    return 1;
  };
 
  FILE *fp;
  fp = fopen(argv[2], "w+");
  if (fp == NULL){
    printf("Arquivo nao pode ser aberto: %s \n", argv[2]);
    return 1;
  }

  yyparse();
  imprimirArvore(raiz);
  strcat(ASM,"\n.data\n.text\n");
  // imprimirAsm(raiz);
  //chamar a main do programa na main do .asm
  strcat(ASM,"main:\n");
  strcat(ASM,"jal _f_main\n");
  strcat(ASM,"li $v0, 10\n");
  strcat(ASM,"syscall\n");
  analiseSemantica(raiz);
  fprintf(fp, "%s", AST);
  // fprintf(fp, "%s", ASM);

  int tam = calcSizeVector(funcoes);
  printf("Quantidade de funções: %d\n",tam);

  //saber se o resultado da função de scopo ta certa
  for(int i=0; i<tam;i++){

    printf("nome da função %d\n", i);
    printf("%s\n",(&funcoes[i])->nameFunc);

    printf("parametros:\n");
    // int tamParam = calcSizeVectorParam((&funcoes[i])->param);
    // printf("%d  ", tamParam);
    for(int j=0; j<2;j++){
      printf("%s ",(&funcoes[i])->param[j]->tipo);
      printf("%s ",(&funcoes[i])->param[j]->nome);
      printf("%d\n",(&funcoes[i])->param[j]->isVector);
    }

    printf("variaveis:\n");
    // int tamVar = calcSizeVectorVar(funcoes[i]->var);
    for(int k=0; k<3;k++){
      printf("%s ",(&funcoes[i])->var[k]->tipo);
      printf("%s ",(&funcoes[i])->var[k]->nome);
      if((&funcoes[i])->var[k]->tamanVetor != NULL) 
        printf("%s\n",(&funcoes[i])->var[k]->tamanVetor);
      else printf("\n");
    }
  }

  fclose(yyin);
  fclose(fp);
 
  return 0;
}