all:
	yacc -d roseta.y
	lex roseta.l
	gcc -o parser lex.yy.c y.tab.c -ly
compile:
	./parser < myprogram.rs > output.c
	
clean:
	rm -f output.c