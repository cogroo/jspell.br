#Aspell Makefile for using official aspell Language Toolkit
#Aspell5 - pt_PT e pt_BR

#make (aspell)
#make (install)

T=../ASPELL_TOOLKIT/aspell-lang
L=pt_PT
J=pt_BR
K=pt
O=$T/$K

DATE=date +%Y%m%d

all: aspell

BRversion:
#wget

aspell: aspell-wl
	rm -rf $O
	cd $T; perl pre $K iso-8859-1
	cp $L-only.wl $O
	cp $J-only.wl $O
	cp $K-only.wl $O
	cp Copyright $O
#	cp $L_phonet.dat $O/$K_phonet.dat
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/g;' info > $O/info
	cd $O; perl proc create; ./configure; 
	cd $O; make

aspell-wl: ../port.dic BRversion
	perl gerarWordList ../port.dic > $L.wl
	perl getCommonWords.pl $L.wl $J.wl
	LC_ALL=C cat $L-only.wl_ | sort -u > $L-only.wl
	LC_ALL=C cat $J-only.wl_ | sort -u > $J-only.wl
	LC_ALL=C cat $K-only.wl_ | sort -u > $K-only.wl
dist: aspell
	cd $O; make dist
	mv $O/aspell5*`${DATE}`* .
../port.dic:
	cd ..; make port.dic

install: aspell
	cd $O; make install

clean : 
	rm -rf *~ $T/*~ $O $K.wl a*bz2 *_
