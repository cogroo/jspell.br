#---------------------------------------------------------------------
#  
# This is   ASPELL/Makefile
#
#---------------------------------------------------------------------


# make install
# make aspell
# make tgz

SHELL=/bin/bash
P=portugues
ABR=pt
DATE=`date +%Y%m%d`

all:
	make aspell

aspell: ../port.dic
	perl tt ../port.dic | LANG='C' sort | word-list-compress c > $P/portugues.cwl
#	perl tt ../port.dic > $P/portugues.aspell 
#	LANG='C' sort $P/portugues.aspell | word-list-compress c > $P/portugues.cwl
	cd $P; ./configure; make all

tgz:
	mkdir aspell-$(ABR).$(DATE)
	mv $P/CVS _CVS
	cp $P/* aspell-$(ABR).$(DATE)
	mv _CVS $P/CVS
	rm -f aspell-$(ABR).$(DATE)/*~
	tar czf aspell-$(ABR).$(DATE).tar.gz aspell-$(ABR).$(DATE)
	rm -fr aspell-$(ABR).$(DATE)

../port.dic:
	cd ..; make port.dic

install : 
	cd $P; make install

clean : 
	rm -f $P/*~ *~
	cd $P; make clean
	rm -rf aspell-$(ABR).$(DATE)

realclean: clean
	rm -f $P/portugues.aspell *.gz
