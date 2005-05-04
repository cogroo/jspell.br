#---------------------------------------------------------------------
# make install
# make aspell
# make tgz

P=portugues
ABR=pt
DATE=`date +%Y%m%d`

aspell: ../port.dic
	perl tt ../port.dic > $P/portugues.aspell
	cd $P; make

aspell-tgz: tgz

tgz:
	tar cfz aspell.$(ABR)-$(DATE).tar.gz $P/portugues.aspell $P/Makefile $P/README $P/port*dat

../port.dic:
	cd ..; make port.dic

install : 
	cd $P; make install

clean : 
	rm -f $P/*~ *~
	cd $P; make clean

realclean: clean
	rm -f $P/portugues.aspell $P.tgz
