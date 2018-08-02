#include "semantico.h"
#include "funcoes.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 
#include <stdbool.h>

int temMain = 0;
int size=0;
int sizeVar=0;
char* nomeFuncao="";

int findOffSetOfVar(char* funcao, char* nomeVariavel){
// printf("=======FIND OFFSET OF VAR=======\n");
// printf("FUNCAO: %s\n",  funcao);
// printf("NOME_VARIAVEL: %s\n",  nomeVariavel);
 for(int i = 0; i < size; i++){
      int tamVar = funcoes[i].qtdVariaveis;
      
      if(strcmp(funcao,(&funcoes[i])->nameFunc)==0){
        //printf("%s\n",(&funcoes[i])->nameFunc );
        for(int k=0; k<tamVar;k++) {
          if(strcmp(nomeVariavel,(&funcoes[i])->var[k]->nome)==0){
            //printf("nome: %s ",(&funcoes[i])->var[k]->nome);
            return (&funcoes[i])->var[k]->offset;
          }
        }
      }
  }
  return -1;
}


int findVarOffSetOfFunction(char* funcao){
// printf("=======FIND OFFSET OF VAR=======\n");
// printf("FUNCAO: %s\n",  funcao);
// printf("NOME_VARIAVEL: %s\n",  nomeVariavel);
 int retorno = 0;
 for(int i = 0; i < size; i++){
      int tamVar = funcoes[i].qtdVariaveis;
      
      if(strcmp(funcao,(&funcoes[i])->nameFunc)==0){
        //printf("%s\n",(&funcoes[i])->nameFunc );
        //for(int k=0; k<tamVar;k++) {
          //if(strcmp(nomeVariavel,(&funcoes[i])->var[k]->nome)==0){
            if(tamVar > 0){

            printf("nome: %s \n",(&funcoes[i])->var[tamVar-1]->nome);
            printf("OFFSET: %s \n",(&funcoes[i])->var[tamVar-1]->nome);
            retorno = -((&funcoes[i])->var[tamVar-1]->offset);
            }
          //}
        //}
      }
  }
  return retorno;
}

void printDadosFuncoes(){
  // for(int i = 0 ; i <=;)
  printf("======DADOS-FUNCAO==========");
  for(int i = 0; i < size; i++){
      int tamVar = funcoes[i].qtdVariaveis;
      printf("%d-%s\n",i,(&funcoes[i])->nameFunc);
      for(int k=tamVar-1; k>=0;k--){
        printf("%d - tipo: %s ",k,(&funcoes[i])->var[k]->tipo);
        printf("nome: %s ",(&funcoes[i])->var[k]->nome);
        printf("offset: %d ",(&funcoes[i])->var[k]->offset);
        if((&funcoes[i])->var[k]->tamanVetor != NULL) 
          printf("%s\n",(&funcoes[i])->var[k]->tamanVetor);
        else printf("\n");
    }
  }
  //printf("============================\n");
  //printf("\nOFFSET : %d",findOffSetOfVar("main", "x"));
}
void debug(){
   printf("\n==============");
      printf("Aqui");
      printf("============== ");
}

void vdebug(char* arg){
   printf("\n==============");
      printf("%s",arg);
      printf("============== ");
}
int contadorIF= 0;
void outEntry(char* texto){
  strcat(ASM,texto);
  strcat(ASM,"\n");
}

char* intToString(int dado){
  char* name = malloc(20);
  sprintf(name, "%d", dado);
  return name;
}

void out(char* texto){
  strcat(ASM,"\t");
  strcat(ASM,texto);
  strcat(ASM,"\n");
}

void push_back(tFuncScope *no){
  funcoes[size] = *no;
  size++;
}

void push_backVar(tInfoVar *no){
  varGlobais[sizeVar] = *no;
  sizeVar++;
}

int calcSizeVector(tFuncScope *vector){
  int size=0;
  while((&vector[size])->nameFunc != NULL){
    size++;
  }
  return size;
}

int calcSizeVectorParam(tInfoParam *vector){
  int size=0;
  while((&vector[size])->tipo != NULL){
    size++;
  }
  return size;
}

int calcSizeVectorVar(tInfoVar *vector){
  int size=0;
  while((&vector[size])->tipo != NULL){
    size++;
  }
  return size;
}

void clearStruct(tFuncScope *no){
  if(no != NULL){
    no->nameFunc = NULL;
    for(int i=0; i<2; i++){
      no->param[i]->nome = NULL;
      no->param[i]->tipo = NULL;
      no->param[i]->isVector = NULL;
    }
    for(int i=0; i<3; i++){
      no->var[i]->nome = NULL;
      no->var[i]->tipo = NULL;
      no->var[i]->tamanVetor = NULL;
    }
      scope = malloc(sizeof(tFuncScope)); 
  }
}

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

int pos = 0;
void findParams(tNode *no){
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->no, "param") == 0){
    tInfoParam *param = malloc(sizeof(tInfoParam));
    scope->param[pos] = param;
    scope->param[pos]->tipo = no->nodeA->no;
    scope->param[pos]->nome = no->nodeB->no;
    if(no->nodeC != NULL){
      scope->param[pos]->isVector = true;
    }else{
      scope->param[pos]->isVector = false;
    }
    pos++;
  }
  findParams(no->nodeA); 
  findParams(no->nodeB); 
  findParams(no->nodeC); 
  findParams(no->nodeD); 
}

int posVar = 0;
void findVarDeclaration(tNode *no){
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->no, "var-declaration") == 0){
    tInfoVar *var = malloc(sizeof(tInfoVar));
    scope->var[posVar] = var;
    scope->var[posVar]->tipo = no->nodeA->no;
    scope->var[posVar]->nome = no->nodeB->no;
    scope->var[posVar]->offset = -(4*(posVar+1));
    //recalcula os offsets;
    // printf("RECALCULA OFFSETS\n");
    // for(int i = 0; i<=  posVar;i++){
    //   scope->var[i]->offset = scope->var[i]->offset+ 4;
    //  // printf("%s %d\n", scope->var[i]->nome, scope->var[i]->offset);
      
    // }
    // printf("=================\n");
    if(no->nodeC != NULL){
      scope->var[posVar]->tamanVetor = no->nodeC->no;
    }else{
      scope->var[posVar]->tamanVetor = NULL;
    }
    posVar++;
  }
  findCalls(no);

  findVarDeclaration(no->nodeA); 
  findVarDeclaration(no->nodeB); 
  findVarDeclaration(no->nodeC); 
  findVarDeclaration(no->nodeD); 
}

void findGlobalDeclaration(tNode *no){
  if(no == NULL){
      return;
  }
  if(strcmp(no->no, "var-declaration") == 0){
    tInfoVar *varialvel = malloc(sizeof(tInfoVar));
    var = varialvel;
    var->tipo = no->nodeA->no;
    var->nome = no->nodeB->no;
    if(no->nodeC != NULL){
      var->tamanVetor = no->nodeC->no;
    }else{
      var->tamanVetor = NULL;
    }
    push_backVar(var);
    free(var);
  }
  findGlobalDeclaration(no->nodeA);
  findGlobalDeclaration(no->nodeB);
  findGlobalDeclaration(no->nodeC);
  findGlobalDeclaration(no->nodeD);
}

int contCall=0;
void findCalls(tNode *no){
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->no,"call") == 0){
    call = malloc(sizeof(tCallFun));
    scope->call[contCall] = call;
    scope->call[contCall]->nome = no->nodeA->no;
    contCall++;
    // free(call);
  }
}

void findExpression(tNode *no){
  if(no == NULL){ 
    return; 
  }
  char *vartemp = no->no;
  if((strcmp(no->no,"=") == 0)||(strcmp(no->no,"<=") == 0)||(strcmp(no->no,"<") == 0)||(strcmp(no->no,">") == 0)
      ||(strcmp(no->no,">=") == 0)||(strcmp(no->no,"==") == 0)||(strcmp(no->no,"!=") == 0)||(strcmp(no->no,"+") == 0)
      ||(strcmp(no->no,"-") == 0)||(strcmp(no->no,"*") == 0)||(strcmp(no->no,"/") == 0)){
    expression->simbolo = vartemp;
    expression->lEsquerdo = no->nodeA;
    expression->lDireito = no->nodeB;
  }
  //se for pra simple-expression -> factor no->nodeA->nodeA->nodeA->no DIGITO
}
// Encontra a posição de uma determinada variável na pilha local




void percorreArvore(tNode *no){ 
  if(no == NULL){ 
      return; 
  }
  if(strcmp(no->no,"") != 0){
    findExpression(no);
    if(strcmp(no->no,"declaration") == 0){
      findGlobalDeclaration(no);
    }
    if(strcmp(no->no,"fun-declaration") == 0){
      scope->nameFunc = no->nodeB->no;
      scope->no = no;
    }
    if((strcmp(no->no, "params") == 0) && (no->nodeA != NULL)){
      findParams(no);
    }else if((strcmp(no->no, "params") == 0) && (no->nodeA == NULL)){
      tInfoParam *param = malloc(sizeof(tInfoParam));
      scope->param[0] = param;
      scope->param[0]->tipo = "void";
    }
    
    if(strcmp(no->no, "compound-stmt") == 0){
      findVarDeclaration(no);
      scope->qtdVariaveis  =posVar;
      
      contCall=0;
      
      push_back(scope);
      free(scope);
      scope = malloc(sizeof(tFuncScope));
      pos=0;
      posVar=0;
    }
  }
  percorreArvore(no->nodeA); 
  percorreArvore(no->nodeB); 
  percorreArvore(no->nodeC); 
  percorreArvore(no->nodeD);
}

void analiseSemantica(tNode *no){
  if(no == NULL){
    return;
  }
  verificaTypeVar(no);
  percorreArvore(no);
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

void imprimirArvore(tNode *no){ 
  if(no == NULL){ 
      return; 
  }
  if((strcmp(no->no,"") != 0) || (strcmp(no->no,"declaration") != 0)){  
    strcat(AST,"[");
    strcat(AST,no->no);
  }

  imprimirArvore(no->nodeA); 
  imprimirArvore(no->nodeB); 
  imprimirArvore(no->nodeC); 
  imprimirArvore(no->nodeD); //|| (strcmp(no->no,"declaration") != 0)
  if((strcmp(no->no,"") != 0) || (strcmp(no->no,"declaration") != 0)){  
      strcat(AST,"]");
  }
}

//----------------INICIO DO CODEGEN-------------------------------


void jumpFuncao(){
  out("jal _f_");
  out(operacao->nome);
  out("lw $ra, 4($sp)");
  out("addiu $sp, $sp, 4");
  out("j $ra");
}

void empilhaFP(){
  out("sw $fp 0($sp) ");
  out("addiu $sp $sp -4");
}

void branchFalse(tNode *node){
  strcat(ASM,"false");
  //printf("saida %s\n",intToString(contadorIF));
  strcat(ASM,intToString(contadorIF));
  strcat(ASM,":\n");
  if(node->nodeC != NULL)
    gerarStatements(node->nodeC);
  strcat(ASM,"\tb end_if");
  strcat(ASM,intToString(contadorIF));
  strcat(ASM,"\n");
}

void branchTrue(tNode *node){
  strcat(ASM,"true");
  strcat(ASM,intToString(contadorIF));
  strcat(ASM,":\n");
  gerarStatements(node);
}

void branchEndIf(){
  strcat(ASM,"end_if");
  strcat(ASM,intToString(contadorIF));
  strcat(ASM,":\n");

}


void gerarCondicional(tNode *node){
  //assumindo que vamos comparar aprenas inteiros
  //strcat(ASM,"\tlw $a0 "); out(node->nodeA->nodeA->nodeA->no);

  //strcat(ASM,"\tlw $t1 "); out(node->nodeA->nodeB->no);
  out("#INICIO CONDICIONAL");
  if(node->nodeA->nodeA->nodeA != NULL ){
    //caso o parametro seja uma variável
    printf("PARAMETRO COMPARADOR 1 1 a %s\n",node->nodeA->nodeA->nodeA->no);
    //strcat(ASM,node->nodeA->nodeA->nodeA->no)
    //printf("aushduahsudauishdiuahsidhashiduashids\n");
    //printf("encontrou %s\n", intToString(findOffSetOfVar(nomeFuncao,node->nodeA->nodeA->nodeA->no)));
    out("");
    strcat(ASM,"\tlw $a0, ");
    strcat(ASM,intToString(findOffSetOfVar(nomeFuncao,node->nodeA->nodeA->nodeA->no)));
    strcat(ASM,"($fp)\n");
    out("sw $a0, 0($sp)");
    out("addiu $sp, $sp, -4");
    out("");
  } else {
    //caso o parametro seja uma constante
    printf("PARAMETRO COMPARADOR 1 2 a %s\n",node->nodeA->nodeA->no);
    
  }

  if(node->nodeA->nodeB->nodeA != NULL ){
    //caso o parametro seja uma variável
    printf("PARAMETRO COMPARADOR 2 1 b %s\n",node->nodeA->nodeB->nodeA->no);
    out("");
    strcat(ASM,"\tlw $a0, ");
    strcat(ASM,intToString(findOffSetOfVar(nomeFuncao,node->nodeA->nodeB->nodeA->no)));
    strcat(ASM,"($fp)\n");
    out("lw $t1 4($sp)");
    out("addiu $sp, $sp, 4");
    out("");
  }else{
    //caso o parametro seja uma constante
   printf("PARAMETRO COMPARADOR 2 2 b %s\n",node->nodeA->nodeB->no);
  }
  
  contadorIF++;
  if(strcmp(node->nodeA->no,"==") == 0){
    strcat(ASM,"\tbeq $a0 $t1 ");
  }
  if(strcmp(node->nodeA->no,"<=") == 0){
    strcat(ASM,"\tbge $a0 $t1 ");
  }
  if(strcmp(node->nodeA->no,"<") == 0){
    strcat(ASM,"\tblt $a0 $t1 ");
  }
  if(strcmp(node->nodeA->no,">") == 0){
    strcat(ASM,"\tbgt $a0 $t1 ");
  }
  if(strcmp(node->nodeA->no,">=") == 0){
    strcat(ASM,"\tble $a0 $t1 ");
  }
  if(strcmp(node->nodeA->no,"!=") == 0){
    strcat(ASM,"\tbne $a0 $t1 ");
  }
  strcat(ASM,"true");
  strcat(ASM,intToString(contadorIF));
  strcat(ASM,"\n");
  out("#FIM CONDICIONAL");
  
  branchFalse(node);

  branchTrue(node->nodeB);
  branchEndIf();

}


void geraOperacaoMatematica(char *texto){
  if(texto != NULL){
    if(strcmp("+",texto) == 0){
        out("add  $a0,  $t1,  $a0  ");
    }else if(strcmp("-",texto) == 0){
        out("sub  $sp  $sp  -4 ");
    }
  }

}
void gerarExpression(tNode *node){
  //se for apenas um digito

  
  if(strcmp(node->no,"call") == 0){
      //printf("%s",node->nodeB->nodeA->no);
      
      printf("CHAMADA DE FUNCAO:  %s\n",node->nodeA->no);
      if(strcmp(node->nodeA->no,"input")==0) {
        out("\n\t#INICIO chamada de input");
        	out("li $v0, 5");
	        out("syscall");
	        out("move $a0, $v0");
          out("#FIM chamada de input\n");
      } else {
        //startCallFunction(node);
      
      if(node->nodeA != NULL && node->nodeB != NULL) {
        
        if( (strcmp(node->nodeB->nodeA->no,"+" ) == 0) || (strcmp(node->nodeB->nodeA->no,"-" ) == 0)){
            printf("%s",node->nodeB->nodeA->nodeA->no); //operador 1
            //empilha parametros da soma
            strcat(ASM,"\tli $a0, ");
            out(node->nodeB->nodeA->nodeA->no);
             startCallFunction(node);
            strcat(ASM,"\tli, $a0 ");
            out(node->nodeB->nodeA->nodeB->no);
            out("lw  $t1,  4($sp) ");    
            geraOperacaoMatematica(node->nodeB->nodeA->no);
            out("addiu  $sp,  $sp,  4 ");
            out("sw  $a0  0($sp)"); 
            out("addiu  $sp,  $sp,  -4 ");
            
            
            
          }else{
          
            //printf("%s",(node->nodeB->nodeA->nodeA->no);
            
              if(strcmp(node->no,"call") == 0 && node->nodeB->nodeA->no != NULL ){
                strcat(ASM,"\tli $a0 ");
                 
                // if(node->nodeB->nodeA->nodeA != NULL){
                //   out(node->nodeB->nodeA->nodeA->no);
                //   }else{
                //   out(node->nodeB->nodeA->no);
                // }

              if(node->nodeB->nodeA->no!= NULL){
                strcat(ASM,node->nodeB->nodeA->no);
                strcat(ASM,"\n");
              }else if(node->nodeB->nodeA->nodeA->no != NULL){
                strcat(ASM,node->nodeB->nodeA->nodeA->no);  
                strcat(ASM,"\n");
              }
               // out(node->nodeB->nodeA->nodeA->no);
               startCallFunction(node);
                //printf("%s",node->nodeB->nodeA->no);
              }
          }
          }
           
           finishCallFunction(node);
      }
     
      return;
      
    } else if (strcmp(node->no,"=") == 0){
      //printf("%s/n"node->no);
        printf("\n==============");
      gerarExpression(node->nodeB);
      printf("%s\n",node->no);
      printf("VARIAVEL %s\n",node->nodeA->nodeA->no);//parâmetro
      printf("OFFSET %d\n",findOffSetOfVar(nomeFuncao,node->nodeA->nodeA->no));
      printf("============== "); 
      //intToString
      strcat(ASM,"\tsw $a0, ");
      strcat(ASM,intToString(findOffSetOfVar(nomeFuncao,node->nodeA->nodeA->no)));
      strcat(ASM,"($fp)\n");
      
      return;
  }
  
}





void gerarStatements(tNode *node){

  if (node == NULL) { 
    return; 
  }


  if (strcmp(node->no,"expression-stmt") == 0 || strcmp(node->no,"selection-stmt") == 0 || strcmp(node->no,"return-stmt") == 0
    || strcmp(node->no,"iteration-stmt") == 0 || strcmp(node->no,"compound-stmt") == 0 || strcmp(node->no,"var-declaration") == 0){
   
    //printf("%s \n",node->no);
  }

  if(strcmp(node->no,"var-declaration") == 0){
    printf("#declarou %s\n",node->nodeB->no);
    out("addiu $sp, $sp, -4");
    return;
  }
  if(strcmp(node->no,"selection-stmt") == 0){
    //assumindo que no if vai ter apenas expressões boleanas simples (3>4)
    
    gerarCondicional(node);
    
    return;
  }

  if(strcmp(node->no,"expression-stmt") == 0){
   
    gerarExpression(node->nodeA);
    return;
  }

  gerarStatements(node->nodeA);
  gerarStatements(node->nodeB);
  gerarStatements(node->nodeC);
  gerarStatements(node->nodeD);

}

void startCallFunction(tNode *node){
  //push na pilha com o endereço de retorno
  out("sw $a0, 0($sp)");
  out("addiu $sp, $sp, -4");
  //empilhar os parametros
  
}

void finishCallFunction(tNode *node){
  strcat(ASM,"\tjal _f_");
  strcat(ASM,node->nodeA->no);
  strcat(ASM,"\n");
}

void imprimeFunction(tNode *no){
  //cgen F-entry
  nomeFuncao = no->nodeB->no;
  if(strcmp(no->nodeB->no, "main") != 0){
    
    //out("move $fp $sp") ;
    out("sw $ra 0($sp)");
    out("addiu $sp $sp -4");
    int  z = 4;
    gerarStatements(no->nodeD);
    out("lw $ra 4($sp)");

      strcat(ASM,"addiu $sp $sp ");
      out(intToString(findVarOffSetOfFunction((no->nodeB->no)))); // onde tem o z
    out("lw $fp 0($sp)");
    out("jr $ra ");
    //gerarStatements(no->nodeD);
  }else{
     if(strcmp(no->nodeB->no, "main") == 0){
      strcat(ASM,"_f_");
      strcat(ASM,no->nodeB->no);
      strcat(ASM,":\n");
      out("move $fp $sp") ;
      out("sw $ra 0($sp)");
      out("addiu $sp $sp -4");
      gerarStatements(no->nodeD);
      strcat(ASM,"addiu $sp $sp ");
      out(intToString(findVarOffSetOfFunction((no->nodeB->no))));
      out("lw $ra 4($sp)");
      strcat(ASM,"addiu $sp $sp ");
      out(intToString(findVarOffSetOfFunction((no->nodeB->no))));
      out("lw $fp 0($sp)");
      out("jr $ra ");
     }
    
  }
}

// void imprimePrintln(tNode *no){
//   if(strcmp(no->no,"call") == 0 && strcmp(no->nodeA->no,"println") == 0){
//     strcat(ASM,"_f_");
//     strcat(ASM,no->nodeA->no);
//     out(":");
//     codigoPrintln();
//   }
// }

void imprimirAsm(tNode *no){ 
  if(no == NULL){ 
    return; 
  }
  if(strcmp(no->no,"") != 0){
    if(strcmp(no->no,"fun-declaration") == 0){
      imprimeFunction(no);
   }
  }
  imprimirAsm(no->nodeA); 
  imprimirAsm(no->nodeB); 
  imprimirAsm(no->nodeC); 
  imprimirAsm(no->nodeD);


}
 