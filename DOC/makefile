#Incluir licença em cada dic
#Incluir README e LEIAME em cada dic
#CUIDADO: OS ENCODING PODEM VARIAR de ficheiro para ficheiro

#Passar var do directório a copiar a documentação

D=GeneratedDOC
R=GenericREADME
L=GenericoLEIAME
r=README
l=LEIAME

all:
	@echo "Indicar dicionário!"

jspell: innerClean
	cp $(R) $(D)/$(r)
	cp $(L) $(D)/$(l)
	cat $(r).jspell >> $(D)/$(r)
	cat $(l).jspell >> $(D)/$(l)
	cp license/license.txt $(D)
	cp DEVEL.jspell $(D)

ispell:

myspell:

hunspell:

aspell5ptPT:

aspell6:

aspell5ptPTptBR:


clean:
	rm -f *~

innerClean:
	rm -f $(D)/*