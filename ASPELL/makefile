#Aspell Makefile for using official aspell Language Toolkit

#make (aspellX)
#make (installX)

#Do FIRST make
#then make distX|installX


T=aspell-lang
#Aspell6
L=pt_PT
P=$T/$L
#Aspell5
K=pt
O=$T/$C

DATE=date +%Y%m%d

all: aspell5 aspell6

aspell6: aspell-wl aspellv6 dist
	mv $P/aspell6*`${DATE}`* .

aspell5: aspell-wl aspellv5 dist
	mv $O/aspell5*`${DATE}`* .

aspellv6: 
	rm -rf $P
	cd $T; perl pre $L iso-8859-1
	cp $L.wl $P
	cp Copyright $P
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/g;s/ASPELL/aspell6/g' info > $P/info
	echo "special - -*-" >> $P/$L.dat
	cd $P; perl proc create; ./configure
	cd $P; make

aspellv5:
	rm -rf $O
	cd $T; perl pre $K iso-8859-1
	cp $K.wl $O
	cp Copyright $O
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/g;s/ASPELL/aspell5/g' info > $O/info
	echo "special - -*-" >> $O/$K.dat
	cd $O; perl proc create; ./configure; 
	cd $O; make


aspell-wl: ../port.dic
	perl gerarWordList ../port.dic > $L.wl

dist5: aspell5
	cd $O; make dist

dist6: aspell6
	cd $P; make dist

../port.dic:
	cd ..; make port.dic

install5: aspell5
	cd $O; make install

install6: aspell6
	cd $P; make install

clean : 
	rm -rf *~ $T/*~ $P $O $K.wl $L.wl a*bz2
