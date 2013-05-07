Brazilian Portuguese Jspell dictionaries
===========

Dicionários para o [Jspell](http://natura.di.uminho.pt/wiki/doku.php?id=ferramentas:jspell)

Este é um fork SVN do projeto português europeu: https://natura.di.uminho.pt/svn/main/dicionarios/jspell.pt
As entradas vão sendo adaptadas para português do Brasil, tendo enfoque na classificação dos termos de acordo com a ABL.



Buscas no dicionário (na pasta `scripts`):

	sudo query.pl

Buscas e flexões:

	sudo queryFlex.pl

Note que é necessário permissão de SUDO porque é necessário instalar os dicionários no sistema. Soluções para evitar isto são bem-vindas!
 

Gerando arquivos para o Cogroo:

	mvn clean
	sudo perl createCogrooFile.pl
	createFSADictionaries.sh
	mvn install
	


