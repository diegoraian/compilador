all:
	make compilador

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexico.l parser.tab.h
	flex lexico.l

compilador: lex.yy.c parser.tab.c parser.tab.h
	gcc lex.yy.c parser.tab.c -lfl -o compilador

clean:
	rm -f parser.tab.h lex.yy.c parser.tab.c lexico