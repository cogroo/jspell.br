#Makefile para gerar a lista de palavras do dicionário
#ATENÇÃO À VAR OLDDATE

#Para fazer difenças é necessário uma wordlist anteriormente gerada

#A olddate obtém sempre a data YYYYMMDD da penúltima wordlist do directório.

############# TODO - Rever codigo do diff... ################################

L=pt_PT
DATE=`date +%Y%m%d`
D=/home/natura/download/sources/Dictionaries/
DS=$(D)misc/
OLDDATE=`ls -c1 $(DS)wordlist |grep -v 'latest' |sed -e 's/\.tar\.bz2//' |sed -e 's/[^0-9]\+//' |sort |tail -n 2 |head -n 1`
RCDATE=`ls -c1 $(DS)wordlist |grep -v 'latest' |sed -e 's/\.tar\.bz2//' |sed -e 's/[^0-9]\+//' |sort |tail -n 1`
#RCDATE=20070504
#OLDDATE=20070426

diff: #wl
	rm -f *bz2
#	ifeq ($(RCDATE),$(DATE))
#		RECENTDATE=$(OLDDATE)
#	endif
#Copia a última wordlist do natura
	cp $(DS)wordlist/wordlist.$L-$(RCDATE).tar.bz2 .
	tar xfj wordlist.$L-$(RCDATE).tar.bz2
	-diff wordlist.$L-$(RCDATE).txt wordlist.$L-$(DATE).txt > rawdiffwordlist.$L-$(DATE).txt
	perl verbdiff.pl rawdiffwordlist.$L-$(DATE).txt > verbdiffwordlist.$L-$(DATE).txt
