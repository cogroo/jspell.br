ge_verb: ge_verb.l ge_verb2.y
	flex ge_verb.l
	yacc ge_verb2.y
	$(CC) -o ge_verb y.tab.c  -L/usr/local/lib -lfl

realclean: clean

clean:
	rm -f y.tab.c lex.yy.c *.o ge_verb
