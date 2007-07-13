#Incluir licença em cada dic
#Incluir README e LEIAME em cada dic
#OS ENCODING VARIAM de ficheiro para ficheiro

#Passar var do directório a copiar a documentação

D=GeneratedDOC
R=GenericREADME
L=GenericoLEIAME
r=README
l=LEIAME

all:
	@echo "Indicar dicionário!"

jspell:
	cp $(R) $(D)/$(r)
	cp $(L) $(D)/$(l)
	cat $(r).jspell >> $(D)/$(r)
	cat $(l).jspell >> $(D)/$(l)
	cp licence/license

ispell:

myspell:

hunspell:

aspell5ptPT:

aspell6:

aspell5ptPTptBR:


clean:
	rm -f *~