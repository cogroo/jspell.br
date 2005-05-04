#---------------------------------------------------------------------
# Generates MYSPELL if required

# make install
# make myspell
# make tgz

P=portugues
ABR=pt
DATE=`date +%Y%m%d`

myspell:
	if test ! -f ../ISPELL/$P/$P.aff ; then \
		cd .. ; make ispell; \
	elif test ! -f ../ISPELL/$P/$P.dic ; then \
		cd .. ; make ispell; \
	fi;
	cp ../ISPELL/$P/$P.dic $P/
	cp ../ISPELL/$P/$P.aff $P/
	perl gendic.pl $P/$P.aff > $P/pt_PT.aff
	cat $P.replace >> $P/pt_PT.aff
	wc -l $P/$P.dic | cut -c 0-6 > $P/pt_PT.dic
	cat $P/$P.dic >> $P/pt_PT.dic
	rm $P/$P.dic
	rm $P/$P.aff
myspell-tgz: tgz

myspell-zip: zip

tgz: 
	tar -czf myspell.$(ABR)-$(DATE).tar.gz $P/*pt* $P/makefile
zip:
	zip myspell_$(ABR)_$(DATE).zip $P/*pt*

install :
	cd $P
	make install
clean : 
	make realclean
realclean:
	rm -f $P/*.aff *.gz $P/*~ $P/*.dic *~ *.zip
