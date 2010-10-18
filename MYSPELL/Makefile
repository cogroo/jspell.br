# Gets MYSPELL
# Requires Ispell, Jspell, updated port.hash 

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
	LANG="pt_PT" perl gendic.pl $P/$P.aff > $P/pt_PT.aff
	cat $P.replace >> $P/pt_PT.aff
	wc -l $P/$P.dic | awk '{print $$1}' > $P/pt_PT.dic
	cat $P/$P.dic >> $P/pt_PT.dic
#	perl -i retiraRegra.pl PL $P/pt_PT.dic #Remove P and L RULE and extra /
#	perl compact.pl $P/pt_PT.dic > pt_PT.dic #Remove lemas duplicados
#	mv pt_PT.dic $P/
	rm $P/$P.dic

myspell-tgz: tgz

myspell-zip: myspell
	mkdir myspell.$(ABR)-$(DATE)
	cp $P/pt_PT.dic $P/README_pt_PT.txt $P/pt_PT.aff myspell.$(ABR)-$(DATE)
	cp ../DOC/COPYING myspell.$(ABR)-$(DATE)
	zip -r myspell.$(ABR)-$(DATE).zip myspell.$(ABR)-$(DATE)
	rm -rf myspell.$(ABR)-$(DATE)

tgz: myspell
	mkdir myspell.$(ABR)-$(DATE)
	cp $P/pt_PT.dic $P/README_pt_PT.txt $P/pt_PT.aff myspell.$(ABR)-$(DATE)
	cp ../DOC/COPYING myspell.$(ABR)-$(DATE)
	tar -czf myspell.$(ABR)-$(DATE).tar.gz myspell.$(ABR)-$(DATE)
	rm -rf myspell.$(ABR)-$(DATE)

install :
	cd $P
	./install.sh
clean : 
	rm -rf myspell.$(ABR)-$(DATE)
	rm -rf *~ $P/*~ $P/*.aff *.gz $P/*~ $P/*.dic *.zip


