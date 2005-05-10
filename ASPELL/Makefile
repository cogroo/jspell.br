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

tgz: aspell
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
