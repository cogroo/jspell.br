#---------------------------------------------------------------------
# make install

# make aspell   (very slow!!!)
# make tgz

P=portugues
ABR=pt
DATE=`date +%Y%m%d`

LIB=/usr/local/lib
ISPELLLIB=/home/jj/lib/aspell

aspell: ../port.dic
	perl tt ../port.dic > $P/portugues.aspell
	cd $P; make

aspell-tgz: tgz

tgz: 
	tar czf aspell.$(ABR).$(DATE).tar.gz $P

../port.dic:
	cd ..; make port.dic

install : 
	cd $P; make install

clean : 


realclean:
	rm -f $P/portugues.aspell $P.tgz
