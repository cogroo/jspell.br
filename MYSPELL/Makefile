#---------------------------------------------------------------------
# EM TESTES
# NECESSITA DO ISPELL GERADO

# make install
# make myspell
# make tgz

P=portugues
ABR=pt
DATE=`date +%Y%m%d`

LIB=/usr/local/lib
#ISPELLLIB=/home/jj/lib/aspell

myspell:
	if test ! -f ../ISPELL/$P/$P.aff ; then \
		cd .. ; make ispell; \
	elif test ! -f ../ISPELL/$P/$P.dic ; then \
		cd .. ; make ispell; \
	fi;
	cp ../ISPELL/$P/$P.dic $P/
	cp ../ISPELL/$P/$P.aff $P/
	perl gendic.pl $P/$P.aff > $P/pt_PT.aff
	wc -l $P/$P.dic | cut -c 0-7 > $P/pt_PT.dic
	cat $P/$P.dic >> $P/pt_PT.dic
	rm $P/$P.dic
	rm $P/$P.aff
tgz: 
	tar -czf myspell.$(ABR).$(DATE).tar.gz $P

#install : 
	#cd $P; make install
clean : 
	make realclean
realclean:
	rm -f $P/*.aff $P.tgz $P/*~ $P/*.dic *~
