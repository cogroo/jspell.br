#Aspell Makefile for using official aspell Language Toolkit

#make (aspell6|aspell5)
#make install

#Do FIRST make
#then make dist|install


T=aspell-lang
L=pt_PT
P=$T/$L
DATE=date +%Y%m%d

all:
	make aspell5
	rm -rf $P #aspell5 is still there
	make aspell6

aspell6:
	make aspellv V=6
	make dist
	mv $P/aspell6*`${DATE}`* .

aspell5:
	make aspellv V=5
	make dist
	mv $P/aspell5*`${DATE}`* .

aspellv: aspell-wl
	cd $T; perl pre $L iso-8859-1
	cp $L.wl $P
	cp Copyright $P
	perl -pe 'BEGIN{$$D=`${DATE}`;chomp $$D}; s/VERSAO/$$D/g;s/ASPELL/aspell${V}/g' info > $P/info
	cd $P; perl proc create; ./configure; make

aspell-wl: ../port.dic
	perl gerarWordList ../port.dic > $L.wl

dist:
	@echo "WARNING TO MANUAL USAGE: Compile first wished version"
	cd $P; make dist

../port.dic:
	cd ..; make port.dic

install :
	@echo "WARNING TO MANUAL USAGE: Compile first wished version"
	cd $P; make install

clean : 
	rm -rf *~ $T/*~ $P $L.wl a*bz2
