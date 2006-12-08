#Aspell Makefile for using official aspell Language Toolkit

#make aspell
#make install


P=aspell-lang/pt_PT
ABR=pt_PT
DATE=`date +%Y%m%d`

aspell: aspell-wl

aspell-wl: ../port.dic
#	perl gerarWordList ../port.dic | LANG='C' sort > pt_PT.wl
	perl gerarWordList ../port.dic > pt_PT.wl

dist:

../port.dic:
	cd ..; make port.dic

install : 
	cd $P; make install

clean : 
	rm -f *~
	rm -f $P/*~
