%{ 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 
 
void    yyerror(const char *s); 
int     yylex(void); 
char strAst[20480]; 
 
//nó que tem 4 filhos 
typedef struct node { 
    struct node *nodeA; 
    struct node *nodeB; 
    struct node *nodeC; 
    struct node *nodeD; 
    char* no; 
}tNode ; 
 
tNode* raiz; 
 
//funções para criar os nós da arvore 
tNode *newnode(char* n, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode* nodeD); 
// tNode *newnum(double d); 
 
%} 
 
//declaração das variáveis usadas no lexico 
%union { 
    int    numValue; 
    char  *stringValue; 
    struct node   *nodeValue; 
} 
 
//onde a gramática vai começar 
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
                  |            declaration                                {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
declaration       :             var-declaration                           {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             fun-declaration                           {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
var-declaration   :             type-specifier ID END_LINE                                           {  tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                                                        $$ = newnode("var-declaration",$1,ideNo,NULL,NULL);
                                                                                                     } 
                  |             type-specifier ID OPEN_BRACKET DIGIT CLOSE_BRACKET  END_LINE         {
                                                                                                        tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                                                        $$ = newnode("var-declaration",$1,NULL,NULL,NULL);
                                                                                                     } 
                  ; 
 
type-specifier    :             INT                                                                  {$$ = newnode("INT",NULL,NULL,NULL,NULL);} 
                  |             VOID                                                                 {$$ = newnode("VOID",NULL,NULL,NULL,NULL);} 
                  ; 
 
fun-declaration   :             type-specifier ID OPEN_PAREN params CLOSE_PAREN compound-stmt        {
                                                                                                        tNode* ideNo = newnode($2,NULL,NULL,NULL,NULL);
                                                                                                        $$ = newnode("fun-declaration",$1,ideNo,$4,$6);
                                                                                                          
                                                                                                      } 
                  ;            
 
params            :             param-list                                              {$$ = newnode("params",$1,NULL,NULL,NULL);} 
                  |             VOID                                                    {$$ = newnode("params",NULL,NULL,NULL,NULL);} 
                  ; 
 
param-list        :             param-list COMMA param                                  {$$ = newnode("",$1,$3,NULL,NULL);} 
                  |             param                                                   {$$ = newnode("",$1,NULL,NULL,NULL);}   
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
 
statement         :             expression-stmt                                         {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             compound-stmt                                           {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             selection-stmt                                          {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             iteration-stmt                                          {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             return-stmt                                             {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
expression-stmt   :             expression  END_LINE                                    {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  |             END_LINE                                                {$$ = NULL;} 
                  ; 
 
selection-stmt    :             IF OPEN_PAREN expression CLOSE_PAREN statement                     {$$ = newnode("selection-stmt ",$3,$5,NULL,NULL);} 
                  |             IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement      {$$ = newnode("selection-stmt ",$3,$5,$7,NULL);} 
                  ; 
iteration-stmt    :             WHILE OPEN_PAREN expression CLOSE_PAREN statement                  {$$ = newnode("iteration-stmt",$3,$5,NULL,NULL);} 
                  ; 
 
return-stmt       :             RETURN END_LINE                                        {$$ = newnode("return-stmt ",NULL,NULL,NULL,NULL);} 
                  |             RETURN expression END_LINE                             {$$ = newnode("return-stmt ",$2,NULL,NULL,NULL);} 
                  ; 
 
expression        :             var ATTRIB expression                                  {$$ = newnode("=",$1,$3,NULL,NULL);} 
                  |             simple-expression                                      {$$ = newnode("",$1,NULL,NULL,NULL);} 
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
                  |             additive-expression                                    {$$ = newnode("",$1,NULL,NULL,NULL);} 
                  ; 
 
relop             :             LEQUAL                                                 {$$ = newnode("<=",NULL,NULL,NULL,NULL);} 
                  |             MINNOR_THEN                                            {$$ = newnode("<",NULL,NULL,NULL,NULL);} 
                  |             MAJOR_THEN                                             {$$ = newnode(">",NULL,NULL,NULL,NULL);} 
                  |             BEQUAL                                                 {$$ = newnode(">=",NULL,NULL,NULL,NULL);} 
                  |             EQUAL                                                  {$$ = newnode("==",NULL,NULL,NULL,NULL);} 
                  |             NEQUAL                                                 {$$ = newnode("!=",NULL,NULL,NULL,NULL);} 
                  ; 
 
additive-expression :         additive-expression addop term                    {$$ = newnode($2->no,$1,$3,NULL,NULL);} 
                    |         term                                              {$$ = newnode("",$1,NULL,NULL,NULL);} 
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
 
factor              :            OPEN_PAREN expression CLOSE_PAREN              {$$ = newnode("",$2,NULL,NULL,NULL);} 
                    |            var                                            {$$ = newnode("",$1,NULL,NULL,NULL);} 
                    |            call                                           {$$ = newnode("",$1,NULL,NULL,NULL);} 
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
                    |           expression                                      {$$ = newnode("",$1,NULL,NULL,NULL);} 
                    ; 
 
empty               :           %empty                                          {$$ = newnode("",NULL,NULL,NULL,NULL);} 
                    ; 
 
//----------------------------------------------------------------------------- 
%% 
//----------------------------------------------------------------------------- 
 
void yyerror(const char *s) { 
  fprintf(stdout, "%s\n", s); 
} 
 
tNode* newnode(char* no, tNode *nodeA, tNode *nodeB,tNode *nodeC, tNode* nodeD){ 

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
 
void imprimirArvore(tNode *no){ 
    if(no == NULL){ 
        return; 
    }
    printf("%s",no->no); 
    if(strcmp(no->no,"") != 0){
      strcat(strAst," [");
      strcat(strAst,no->no);
      //strcat(strAst," ");
    }
      
    // if(no->nodeD != NULL && strcmp(no->nodeD, "") != 0) {
    //     strcat(strAst,"[\n");
    //     strcat(strAst,no->nodeD);
    // }
    imprimirArvore(no->nodeA); 
    imprimirArvore(no->nodeB); 
    imprimirArvore(no->nodeC); 
    imprimirArvore(no->nodeD); 
    if(strcmp(no->no,"") != 0){  
        strcat(strAst,"] ");
    }
        
        
    // if(no->nodeD != NULL && strcmp(no->nodeD, "") != 0) {
    //   strcat(strAst,"]\n");
    // }
    
} 
 
int main( int argc, char *argv[] ) { 
  extern FILE *yyin; 
    raiz = newnode("",NULL,NULL,NULL,NULL); 
  if( argc != 3){ 
    printf("Quantidade de argumentos invalida!\n"); 
    return 1; 
  } 
 
  yyin = fopen(argv[1], "r"); 
 
  if (yyin == NULL){ 
    printf("Erro ao abrir o arquivo: %s \n", argv[1]); 
    return 1; 
  } 
 
  FILE *fp; 
  fp = fopen(argv[2], "w+"); 
  if (fp == NULL){ 
    printf("Erro ao abrir o arquivo: %s \n", argv[2]); 
    return 1; 
  } 
     
  yyparse(); 
  imprimirArvore(raiz); 
  fprintf(fp, "%s", strAst); 
 
  fclose(yyin); 
  fclose(fp); 
 
  return 0; 
 
} 