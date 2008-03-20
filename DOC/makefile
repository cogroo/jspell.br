#Incluir licença em cada dic
#Incluir README e LEIAME em cada dic
#CUIDADO: OS ENCODING PODEM VARIAR de ficheiro para ficheiro

#Passar var do directório a copiar a documentação

D=generatedDOC
R=GenericREADME
L=GenericoLEIAME
r=README
l=LEIAME
LIC=COPYING

all:
	@echo "Indicar dicionário!"

jspell: innerClean
	cp $(R) $(D)/
	cp $(L) $(D)/
	cat $(r).jspell >> $(D)/$(R)
	cat $(l).jspell >> $(D)/$(L)
	cp license/$(LIC) $(D)
	perl processarMeta.pl jspell $(D)/$(R) $(D)/$(r)
	perl processarMeta.pl jspell $(D)/$(L) $(D)/$(l)
ispell:

myspell:

hunspell:

aspell5ptPT:

aspell6:

aspell5ptBRptPT: innerClean
#Common
	cp Copyright.aspell5ptBRptPT $(D)/Copyright
	cp license/$(LIC) $(D)/COPYING_
	perl processarMeta.pl aspell5ptBRptPT $(D)/COPYING_ $(D)/COPYING
#Portugal
	mkdir -p $(D)/doc/pt_PT
	cp $(R) $(D)/doc/pt_PT
	cp $(L) $(D)/doc/pt_PT
	cat $(r).aspell5ptBRptPT >> $(D)/doc/pt_PT/$(R)
	cat $(l).aspell5ptBRptPT >> $(D)/doc/pt_PT/$(L)
	perl processarMeta.pl aspell5ptBRptPT $(D)/doc/pt_PT/$(R) $(D)/doc/pt_PT/$(r)
	perl processarMeta.pl aspell5ptBRptPT $(D)/doc/pt_PT/$(L) $(D)/doc/pt_PT/$(l)
#Brasil (Dinamizar)
	mkdir -p $(D)/doc/pt_BR
	cp aspell5ptBRdoc/* $(D)/doc/pt_BR
clean:
	rm -f *~

innerClean:
	rm -rf $(D)/*
