#Incluir licença em cada dic
#Incluir README e LEIAME em cada dic
#CUIDADO: OS ENCODING PODEM VARIAR de ficheiro para ficheiro

#Passar var do directório a copiar a documentação

D=generatedDOC
R=GenericREADME
L=GenericoLEIAME
r=README
l=LEIAME

all:
	@echo "Indicar dicionário!"

jspell: innerClean
	cp $(R) $(D)/
	cp $(L) $(D)/
	cat $(r).jspell >> $(D)/$(R)
	cat $(l).jspell >> $(D)/$(L)
	cp license/license.txt $(D)
	perl processarMeta.pl jspell $(D)/$(R) $(D)/$(r)
	perl processarMeta.pl jspell $(D)/$(L) $(D)/$(l)
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