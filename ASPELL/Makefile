#---------------------------------------------------------------------
# make install

# make aspell   (very slow!!!)
# make aspell.tgz

P=portugues

LIB=/usr/local/lib
ISPELLLIB=/home/jj/lib/aspell

aspell: ../port.dic
	perl tt ../port.dic > $P/portugues.aspell
	cd $P; make

$P.tgz: 
	tar -czf $P.tgz $P

../port.dic:
	cd ..; make port.dic

install : 
	cd $P; make install

clean : 


realclean:
	rm -f $P/portugues.aspell $P.tgz
