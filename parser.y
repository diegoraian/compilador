%{ 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 
#include "funcoes.h"
 
void    yyerror(const char *s); 
int     yylex(void); 
char    AST[20480];
char    ASM[20480];

tNode* raiz;
tFuncScope* scope;
tOperacao* operacao;
tFuncScope* Funcoes[20480];

int temMain = 0;
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
 
declaration-list  :            declaration-list declaration               {$$ = newnode("",$1,$2,NULL,NULL);}
                  |            declaration                                {$$ = $1;}
                  ; 
 
declaration       :             var-declaration                           {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             fun-declaration                           {$$ = $1;}//{$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
var-declaration   :             type-specifier ID END_LINE                {  tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
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
 
void clean(char *var) {
  int i = 0;
  while(var[i] != '\0') {
      var[i] = '\0';
      i++;
  }
}

void yyerror(const char *s) { 
  fprintf(stdout, "%s\n", s);
  exit(0); 
}

void mainLast(tNode *no){
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->nodeA->no,"declist") == 0){
    mainLast(no->nodeA);
  }
  if(no->nodeD != NULL){
    printf("%s D\n",no->nodeD->no);
    if(strcmp(no->nodeD->no,"fun-declaration") == 0){
      if(strcmp(no->nodeD->nodeB->no,"main")){
        yyerror("last nodo isnt mainD");
        clean(AST);
      }
    }else{
      yyerror("has something after main");
      clean(AST);
    }
  }else{
    if(no->nodeC != NULL){
      printf("%s C\n",no->nodeC->no);
      if(strcmp(no->nodeC->no,"fun-declaration") == 0){
        if(strcmp(no->nodeC->nodeB->no,"main")){
          yyerror("last nodo isnt mainC");
          clean(AST);
        }
      }else{
        yyerror("has something after main");
        clean(AST);
      }
    }else{
      if(no->nodeB != NULL){
        printf("%s B\n",no->nodeB->no);
        if(strcmp(no->nodeB->no,"fun-declaration") == 0){
          if(strcmp(no->nodeB->nodeB->no,"main")){
            yyerror("last nodo isnt mainB");
            clean(AST);
          }
        }else{
          yyerror("has something after main");
          clean(AST);
        }
      }else{
        if(no->nodeA != NULL){
          printf("%s A\n",no->nodeA->no);
          // printf("%s A\n",no->nodeA->nodeB->no);
          if(strcmp(no->nodeA->no,"fun-declaration") == 0){
            if(strcmp(no->nodeA->nodeB->no,"main")){
              yyerror("last nodo isnt mainA");
              clean(AST);
            }
          }else{
            yyerror("has something after main");
            clean(AST);
          }
        }
      }
    }
  }
}

void verificaTypeVar(tNode *no){ 
  if(no == NULL){ 
    return; 
  }
  if(strcmp(no->no,"var-declaration") == 0 && strcmp(no->nodeA->no,"void") == 0){
    clean(AST);
  }
  if(strcmp(no->no,"param") == 0 && strcmp(no->nodeA->no,"void") == 0){
    clean(AST);
  }
  verificaTypeVar(no->nodeA);
  verificaTypeVar(no->nodeB);
  verificaTypeVar(no->nodeC);
  verificaTypeVar(no->nodeD);
}

void analiseSemantica(tNode *no){
  if(no == NULL){
    return;
  }
  verificaTypeVar(no);
  // mainLast(no);
}
 
 void checkMain(tNode* no){
  if ( !strcmp(no->nodeB->no, "main") ){
    if(temMain==1){
      clean(AST);
      yyerror("has more the one main");
    }
    temMain = 1;
    if ( strcmp(no->nodeA->no, "void") ){
      clean(AST);
      yyerror("main has to be type void");
    }
    if ( no->nodeC->nodeA != NULL ){
      clean(AST);
      yyerror("main cant have params");
    }
  }
  else{
    if(temMain==1){
      clean(AST);
      yyerror("has something after main");
    }
  }
  if(!strcmp(no->nodeB->no, "println")){
    clean(AST);
    yyerror("cant redefine println");
  }
  if(!strcmp(no->nodeB->no, "input")){
    clean(AST);
    yyerror("cant redefine input");
  }
}

tNode* newnode(char* no, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode *nodeD){ 

  tNode *tree = malloc(sizeof(tNode)); 
  if(!tree){ 
      yyerror("vazio"); 
      exit(0);
  }
    tree->no = malloc(20);
    strcpy(tree->no, no); 

  tree->nodeA = nodeA; 
  tree->nodeB = nodeB; 
  tree->nodeC = nodeC; 
  tree->nodeD = nodeD;
  return tree; 
}

void scopeGenerate(tNode *no){
  tInfoParam *param = malloc(sizeof(tInfoParam)); 
  if(strcmp(no->no,"fun-declaration") == 0){
    scope->nameFunc = no->nodeB->no;
    printf("%s\n",scope->nameFunc);
    if(no->nodeC->nodeA != NULL){
      //caso não tenha mais de um parametro 
      if(strcmp(no->nodeC->nodeA->no, "param") == 0){
        scope->param[0] = param;
        scope->param[0]->tipo = no->nodeC->nodeA->nodeA->no;
        scope->param[0]->nome = no->nodeC->nodeA->nodeB->no;
        printf("%s\n",scope->param[0]->tipo);
        printf("%s\n",scope->param[0]->nome);
      }
    }else{
      //Função sem parametros
    }
  }
}

void imprimirArvore(tNode *no){ 
  if(no == NULL){ 
      return; 
  }
  // printf("%s",no->no); 
  if(strcmp(no->no,"") != 0){
    strcat(AST,"[");
    strcat(AST,no->no);
    scopeGenerate(no);
  }
  imprimirArvore(no->nodeA); 
  imprimirArvore(no->nodeB); 
  imprimirArvore(no->nodeC); 
  imprimirArvore(no->nodeD); 
  if(strcmp(no->no,"") != 0){  
      strcat(AST,"]");
  }
}

void opSimples(tNode *no){
  if(strcmp(no->no,"-")==0){
    operacao->simbolo = no->no;
    operacao->op1 = no->nodeA->nodeA->no;
    operacao->op2 = no->nodeB->nodeA->no;
  }
  if(strcmp(no->no,"+")==0){
    operacao->simbolo = no->no;
    operacao->op1 = no->nodeA->nodeA->no;
    operacao->op2 = no->nodeB->nodeA->no;
  }
}

void imprimeOpSimples(){
  //grava o valor do primeiro parametro
  strcat(ASM,"li $a0, ");
  strcat(ASM,operacao->op1);
  //da um push
  strcat(ASM,"\nsw $a0, 0($sp)\n");
  strcat(ASM,"addiu $sp, $sp, -4\n");
  //grava o valor do segundo parametro
  strcat(ASM,"li $a0, ");
  strcat(ASM,operacao->op2);
  //da um pop
  strcat(ASM,"\nlw $t1, 4($sp)\n");
  strcat(ASM,"addiu $sp, $sp, 4\n");
  //realiza a operação
  if(strcmp(operacao->simbolo,"+") == 0)
    strcat(ASM,"add $a0, $t1, $a0\n");
  if(strcmp(operacao->simbolo,"-") == 0)
    strcat(ASM,"sub $a0, $t1, $a0\n");
  //da um push com o resultado
  strcat(ASM,"sw $a0, 0($sp)\n");
  strcat(ASM,"addiu $sp, $sp, -4\n");
}

void guardarRetornoMain(){
  //push na pilha com o endereço de retorno
  strcat(ASM,"sw $ra, 0($sp)\n");
  strcat(ASM,"addiu $sp, $sp, -4\n");
}

void imprimeFunction(tNode *no){
  if(strcmp(no->no,"fun-declaration") == 0){
    strcat(ASM,"_f_");
    strcat(ASM,no->nodeB->no);
    strcat(ASM,":\n");
    if(strcmp(no->nodeB->no, "main") == 0){
      guardarRetornoMain();
      if(operacao!=NULL)
        imprimeOpSimples();
    }
  }
}

void codigoPrintln(){
  //eu acho que esse código é default
  strcat(ASM,"lw $a0, 4($sp)\n");
  strcat(ASM,"li $v0, 1\n");
  strcat(ASM,"syscall\n");
  strcat(ASM,"li $v0, 11\n");
  strcat(ASM,"li $a0, 0x0a\n");
  strcat(ASM,"syscall\n");
  strcat(ASM,"addiu $sp, $sp, 4\n");
  strcat(ASM,"li $a0, 0\n");
  strcat(ASM,"j $ra\n");
}

void imprimePrintln(tNode *no){
  if(strcmp(no->no,"call") == 0 && strcmp(no->nodeA->no,"println") == 0){
    strcat(ASM,"_f_");
    strcat(ASM,no->nodeA->no);
    strcat(ASM,":\n");
    codigoPrintln();
  }
}

void imprimirAsm(tNode *no){ 
  if(no == NULL){ 
    return; 
  }
  if(strcmp(no->no,"") != 0){
    opSimples(no);
  }
  imprimirAsm(no->nodeA); 
  imprimirAsm(no->nodeB); 
  imprimirAsm(no->nodeC); 
  imprimirAsm(no->nodeD);

  if(strcmp(no->no,"") != 0){
    imprimeFunction(no);
    imprimePrintln(no);
  }
}
 
int main( int argc, char *argv[] ) { 
  extern FILE *yyin; 
    raiz = newnode("",NULL,NULL,NULL,NULL);
    operacao = malloc(sizeof(tOperacao)); 
    scope = malloc(sizeof(tFuncScope)); 

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

  fclose(yyin);
  fclose(fp);
 
  return 0;
}