#!/bin/bash
COMPILER=$1

CASES=$2/

BASELINE=$3/

totalfiles=0;
passed=0;
rm relatorio.txt;

for f in $CASES*.c; do
    totalfiles=$((totalfiles+1));

    correct=${f/%.c/.out}
    correct=${correct/$2}
    echo running $f
    $1 $f tempfile

    DIFF=$(diff -w $BASELINE/$correct tempfile)
    
    if [ "$DIFF" != "" ] 
    then
        echo -e "file: $f ------ ERROR \n\n" $DIFF "\n">> relatorio.txt
    else
        echo -e "file: $f test passed ------ OK \n\n" >> relatorio.txt
        passed=$((passed+1))
    fi

done

rm tempfile 
echo $passed/$totalfiles >> relatorio.txt

percent=$(awk "BEGIN { pc=100*${passed}/${totalfiles}; i=int(pc); print (pc-i<0.5)?i:i+1 }")

echo $percent%
echo $percent >> relatorio.txt

# executar o script como "bash autodiff.sh ./<caminho-para-compilador> <pasta-contendo-testes-de-caso> <caminho-para-pasta-com-saidas-corretas>"
# exemplo: $ bash autodiff.sh ./compilador casos 95
# a saída vai ser gerada na pasta do script como relatorio.txt