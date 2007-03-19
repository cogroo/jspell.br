#Aspell Makefile for using official aspell Language Toolkit
#Aspell5

#make (aspell)
#make (install)

T=../ASPELL_TOOLKIT/aspell-lang
L=pt_PT
K=pt
O=$T/$K

DATE=date +%Y%m%d

all: aspell

aspell: aspell-wl
	rm -rf $O
	cd $T; perl pre $K iso-8859-1
	cp $L.wl $O/$K.wl
	cp Copyright $O
#	cp $L_phonet.dat $O/$K_phonet.dat
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/g;' info > $O/info
	perl -pe 's/LANG/$K/g' $K.dat > $O/$K.dat;
#	echo "special - -*-" >> $O/$K.dat
	cd $O; perl proc create; ./configure; 
	cd $O; make

aspell-wl: ../port.dic
	perl gerarWordList ../port.dic > $L.wl

dist: aspell
	cd $O; make dist
	mv $O/aspell5*`${DATE}`* .

../port.dic:
	cd ..; make port.dic

install: aspell
	cd $O; make install

clean : 
	rm -rf *~ $T/*~ $O $K.wl a*bz2
