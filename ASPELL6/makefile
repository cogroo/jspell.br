#Aspell 6 Makefile for using official aspell Language Toolkit

#make (aspell)
#make (install)

#Do FIRST make
#then make dist|install


T=../ASPELL_TOOLKIT/aspell-lang
L=pt_PT
P=$T/$L
I=../ISPELL/portugues/portugues.aff
ID=../ISPELL/portugues/portugues.dic

DATE=date +%Y%m%d

all: aspell

aspell: aspell-wl
	rm -rf $P
	cd $T; perl pre $L iso-8859-1
	cp $L.wl $P
	cp Copyright $P
	cp $L_phonet.dat $P/$L_phonet.dat
	cp $L_repl.dat $P/$L_repl.dat
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/g;' info > $P/info
	perl -pe 's/LANG/$L/g' $L.dat > $P/$L.dat;
	if test ! -f $I ; then \
		cd .. ; make ispell; \
	fi;
#	Copiar o dic e o aff do Jspell depois
#	The affix file is expected to be named lang_affix.dat

	LANG="$L" perl genAff.pl $I > $P/$L_affix.dat
#	Preciso de contagem de elementos ?
	cd $P; perl proc create; ./configure
	cd $P; make

aspell-wl: ../port.dic
	if test ! -f ../ISPELL/$P/$P.dic ; then \
		cd .. ; make ispell; \
	fi;
	cp $(ID) $L.wl
#	perl gerarWordList ../port.dic > $L.wl

dist: aspell
	cd $P; make dist
	mv $P/aspell6*`${DATE}`* .

../port.dic:
	cd ..; make port.dic

install: aspell
	cd $P; make install

clean : 
	rm -rf *~ $T/*~ $P $L.wl a*bz2
