build: find.l find.y
	bison -d find.y
	flex find.l
	gcc lex.yy.c find.tab.c
run:
	./a.out<text.in

clear:
	rm -r ./a.out
	rm -r ./lex.yy.c