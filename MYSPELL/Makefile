#---------------------------------------------------------------------
# Generates ISPELL if required

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
	cat $P.replace >> $P/pt_PT.aff
	wc -l $P/$P.dic | cut -c 0-7 > $P/pt_PT.dic
	cat $P/$P.dic >> $P/pt_PT.dic
	rm $P/$P.dic
	rm $P/$P.aff
tgz: 
	tar -czf myspell.$(ABR).$(DATE).tar.gz $P/*pt*
zip:
	zip myspell_$(ABR)_$(DATE).zip $P/*pt*

install : 	# Openoffice user directory #Mozilla Mail #Thunderbird
	#Como detectar a ultima versão ?			
	if test -w $(HOME)/.openoffice/1.1.3/user/wordbook ; then \
		cp $P/*pt* $(HOME)/.openoffice/1.1.3/user/wordbook ; \
		echo "OpenOffice install!"; \
	fi;
	if test -w /usr/lib/mozilla/components/myspell ; then \
		cp $P/*pt* /usr/lib/mozilla/components/myspell; \
		echo "Mozilla install!"; \
	fi;
	if test -w /usr/lib/MozillaThunderbird/components/myspell ; then \
		cp $P/*pt* /usr/lib/MozillaThunderbird/components/myspell; \
		echo "Mozilla Thunderbird install!"; \
	fi;

clean : 
	make realclean
realclean:
	rm -f $P/*.aff *.gz $P/*~ $P/*.dic *~ *.zip
