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
	if test ! -f ../ISPELL/portugues/portugues.aff ; then \
		cd .. ; make ispell; \
	elif test ! -f ../ISPELL/portugues/portugues.dic ; then \
		cd .. ; make ispell; \
	fi;
	cp ../ISPELL/portugues/portugues.dic portugues/
	cp ../ISPELL/portugues/portugues.aff portugues/
	perl gendic.pl portugues/portugues.aff > portugues/pt_PT.aff
	mv portugues/portugues.dic portugues/pt_PT.dic
	rm portugues/portugues.aff
tgz: 
	tar -czf myspell.$(ABR).$(DATE).tar.gz $P

#install : 
	#cd $P; make install
clean : 
	make realclean
realclean:
	rm -f $P/*.aff $P.tgz $P/*~ $P/*.dic
