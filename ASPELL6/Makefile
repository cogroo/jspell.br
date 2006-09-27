#---------------------------------------------------------------------
#  
# This is   ASPELL/Makefile for version 0.60.X
#
#---------------------------------------------------------------------


# make install
# make aspell
# make tgz

SHELL=/bin/bash
P=portugues
ABR=pt
DATE=`date +%Y%m%d`

aspell: ../port.dic
#generate myspell dic
	if test ! -f ../ISPELL/$P/$P.aff ; then \
		cd .. ; make ispell; \
	elif test ! -f ../ISPELL/$P/$P.dic ; then \
		cd .. ; make ispell; \
	fi;
	cp ../ISPELL/$P/$P.dic $P/
	cp ../ISPELL/$P/$P.aff $P/
	LANG="pt_PT" perl gendic.pl $P/$P.aff > $P/$P_affix.dat
	cat $P.replace >> $P/$P_affix.dat
	cat $P/$P.dic >> $P/pt.dic
#rm $P/portugues.aff

#Generate cwl
	LANG='C' sort $P/$P.dic | word-list-compress c > $P/$P.cwl
	cd $P; ./configure; make all

tgz:
	mkdir aspell6.$(ABR)-$(DATE)
	cp ../COPYING aspell6.$(ABR)-$(DATE)
	cp $P/* aspell6.$(ABR)-$(DATE)
	cd aspell6.$(ABR)-$(DATE); rm -f *~ *.old *.rws Makefile *.dic *.aff
	tar czf aspell6.$(ABR)-$(DATE).tar.gz aspell6.$(ABR)-$(DATE)
	rm -fr aspell6.$(ABR)-$(DATE)

../port.dic:
	cd ..; make port.dic

install : 
	cd $P; make install

clean : 
	rm -f $P/*~ *~
	rm -rf aspell6.$(ABR)-$(DATE)

realclean: clean
	rm -f $P/portugues.cwl *.gz
