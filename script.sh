#!bin/bash
reset;
lex lexico.l;
make;
./compilador entrada.c novasaida.out;
