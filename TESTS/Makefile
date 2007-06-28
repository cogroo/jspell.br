#---------------------------------------------------------------------
# 
#---------------------------------------------------------------------

P=pt_PT
DATE=`date +%Y%m%d`
D=/home/natura/download/sources/Dictionaries/
DS=$(D)misc/
FIRSTDATE=`ls -c1 $(DS)wordlist |grep -v 'latest' |sed -e 's/\.tar\.bz2//' |sed -e 's/[^0-9]\+//' |sort |head -n 2 |tail -n 1`
LASTDATE=`ls -c1 $(DS)wordlist |grep -v 'latest' |sed -e 's/\.tar\.bz2//' |sed -e 's/[^0-9]\+//' |sort |tail -n 1`


versao:
	@echo versões *spellers:
	@echo "  Jspell: "`jspell -v |head -n 1`
	@echo "  Ispell: "`ispell -v |head -n 1`
	@echo "  Aspell: "`aspell -v |head -n 1`
	@echo "Hunspell: "`hunspell -v|head -n 1`
	@echo " myspell: Falta teste"
	@echo
	@echo "Primeira Wordlist de comparação: $(FIRSTDATE)"
	@echo "Última Wordlist de comparação: $(LASTDATE)"

#texto:
#Fazer um test com um ficheiro de texto

#sintaxe:
#Verificar estrutura dos ficheiros

testarPalavrasErradasReEmergentes:
	perl testarPalavrasErradasReEmergentes.pl $(DS)wordlist acceptWords

../port.dic:
	cd ..; make port.dic

clean : 
	rm *~

