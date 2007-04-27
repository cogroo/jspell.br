#-------------------------------------------------------------------
# Run 'make' to view options
#-------------------------------------------------------------------

# Version $Revision$

#-------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------

LING=portugues
ABR=pt
#iso631 country code
ABRX=pt_PT
DATE=`date +%Y%m%d`

## In case you change this, please let jspell maintainers know...
DIST_DIR=jspell.$(ABR)-$(DATE)

LIB=`jspell-dict --dic-dir`
#ISPELLLIB=/home/jj/lib/ispell
#JSPELLLIB=/home/jj/lib/jspell

IRRFILES=IRR/ge_verb.l IRR/ge_verb2.y IRR/makefile


PTDIC = DIC/port.geral.dic DIC/port.inf.dic DIC/port.np.dic DIC/port.siglas.dic DIC/port.abrev.dic
EXTRADIST = irregulares.txt irr2perl port.aff jspell-pt.1

BASE= port.aff $(PTDIC) irregulares.txt aux_verb.dic \
      IRR/ge_verb.l IRR/ge_verb2.y makefile \
      PERL/pos2iso PERL/jsp2isp.pl README jspell.port.spec irr2perl

NATURA_WWW=/home/natura/download/sources/Dictionaries

#-------------------------------------------------------------------
# Instructions
#-------------------------------------------------------------------
all:
	@ echo
	@ echo -e "jspell:"
	@ echo -e "\tjspell -- builds jspell dictionary"
	@ echo -e "\tjspell-install -- installs jspell"
	@ echo -e "\tjspell-tgz -- creates jspell munged distribution file"
	@ echo
	@ echo -e "ispell:"
	@ echo -e "\tispell -- builds ispell dictionary"
	@ echo -e "\tispell-install -- installs ispell"
	@ echo -e "\tispell-clean -- clears ispell generated dictionaries"
	@ echo -e "\tispell-tgz -- creates ispell distribution file"
	@ echo
	@ echo -e "aspell5:"
	@ echo -e "\taspell5 -- builds aspell 0.50 dictionary"
	@ echo -e "\taspell5-install -- installs aspell 0.50"
	@ echo -e "\taspell5-tgz -- creates aspell 0.50 distribution file"
	@ echo
	@ echo -e "aspell6:"
	@ echo -e "\taspell6 -- builds aspell 0.60 dictionary"
	@ echo -e "\taspell6-install -- installs aspell 0.60"
	@ echo -e "\taspell6-tgz -- creates aspell 0.60 distribution file"
	@ echo
	@ echo -e "myspell:"
	@ echo -e "\tmyspell -- builds myspell dictionary (will make ispell if required)"
	@ echo -e "\tmyspell-install -- installs myspell"
	@ echo -e "\tmyspell-tgz -- creates myspell distribution file (tar.gz)"
	@ echo -e "\tmyspell-zip -- creates myspell distribution file (zip)"
	@ echo
	@ echo -e "hunspell:"
	@ echo -e "\thunspell -- builds hunspell dictionary"
	@ echo -e "\thunspell-install -- installs hunspell"
	@ echo -e "\thunspell-tgz -- creates hunspell distribution file (tar.gz)"
	@ echo -e "\thunspell-zip -- creates hunspell distribution file (zip)"
	@ echo
	@ echo -e "wordlist:"
	@ echo -e "\twordlist -- builds a simple word list"
	@ echo -e "\twordlist-bz2 -- creates wordlist compressed file"
	@ echo -e "\twordlist-diff -- calculates real differences on the dictionary since last release (needs a previous release)"
	@ echo -e
	@ echo -e "chuveiro:"
	@ echo -e "\tchuveiro -- build all available dictionaries"
	@ echo -e "\tinstall -- online publish at natura"
	@ echo
#-------------------------------------------------------------------
# Generated files
#-------------------------------------------------------------------

port.dic: $(PTDIC) aux_all_irr.dic 
	echo -e '## THIS IS A GENERATED FILE!! DO NOT EDIT!!\n\n' > port.dic
	cat $(PTDIC) aux_all_irr.dic >> port.dic 

port.irr: aux_all_irr.dic
	./irr2perl aux_all_irr.dic > port.irr

aux_verb.dic: DIC/port.geral.dic
	egrep 'CAT=v|\#v' DIC/port.geral.dic > aux_verb.dic

aux_all_irr.dic: irregulares.txt aux_verb.dic IRR/ge_verb
	IRR/ge_verb aux_verb.dic < irregulares.txt > aux_all_irr.dic

IRR/ge_verb: IRR/ge_verb.l IRR/ge_verb2.y
	cd IRR; make

tgz:
	make clean
	cd .. ; tar -cvzf jspell.pt.tgz jspell.pt ; mv jspell.pt.tgz jspell.pt/dicionario.pt.tgz

jspell.port.tgz: $(BASE)
	rm -rf jspell.port-`./ver`
	mkdir -p jspell.port-`./ver`
	cp COPYING jspell.port-`./ver`
	cp $(BASE) jspell.port-`./ver`
	tar -cvzf jspell.port.tgz jspell.port-`./ver`

port.tgz: $(BASE)
	tar -czf dic.tgz $(BASE)

#-------------------------------------------------------------------
# Garbage collecting :)
#-------------------------------------------------------------------
clean: 
	cd IRR;    make clean
	cd ISPELL; make clean
	cd ASPELL5; make clean
	cd ASPELL6; make clean
	cd MYSPELL; make clean
	cd HUNSPELL; make clean
#	cd WORDLIST; make clean #No clean
	rm -f *.stat *.cnt
	rm -f *~
	rm -f aux_all_irr.dic 
	rm -f port.dic
	rm -f *.gz *.zip *.bz2

#-------------------------------------------------------------------
# ispell rules
#-------------------------------------------------------------------

ispell: port.dic port.aff
	cd ISPELL; make

ispell-install: ispell
	cd ISPELL; make install

ispell-tgz:
	cd ISPELL; make tgz
	mv ISPELL/ispell.$(ABR)-$(DATE).tar.gz .

ispell-clean:
	cd ISPELL; make clean


#-------------------------------------------------------------------
# aspell 0.50 rules
#-------------------------------------------------------------------
aspell5: port.dic port.aff
	cd ASPELL5; make aspell

aspell5-install: aspell5
	cd ASPELL5; make install

aspell5-tgz:
	cd ASPELL5; make dist
	mv ASPELL5/aspell5*$(DATE)*bz2 .

aspell5-clean:
	cd ASPELL5; make clean

#-------------------------------------------------------------------
# aspell 0.60 rules
#-------------------------------------------------------------------

aspell6: port.dic port.aff
	cd ASPELL6; make aspell

aspell6-install: aspell6
	cd ASPELL6; make install

aspell6-tgz:
	cd ASPELL6; make dist
	mv ASPELL6/aspell6*$(DATE)*bz2 .

aspell6-clean:
	cd ASPELL6; make clean

#-------------------------------------------------------------------
# myspell rules
#-------------------------------------------------------------------

myspell: port.dic port.aff ispell
	cd MYSPELL; make

myspell-install: myspell
	cd MYSPELL; make install

myspell-tgz:
	cd MYSPELL; make tgz
	mv MYSPELL/myspell.$(ABR)-$(DATE).tar.gz .

myspell-zip:
	cd MYSPELL; make myspell-zip
	mv MYSPELL/myspell.$(ABR)-$(DATE).zip .

myspell-clean:
	cd MYSPELL; make clean


#-------------------------------------------------------------------
# hunspell rules (myspell backward compatible, to replace myspell?)
#-------------------------------------------------------------------

hunspell: port.dic port.aff
	cd HUNSPELL; make

hunspell-install: hunspell
	cd HUNSPELL; make install

hunspell-tgz:
	cd HUNSPELL; make tgz
	mv HUNSPELL/hunspell-$(ABRX)-$(DATE).tar.gz .

hunspell-zip:
	cd HUNSPELL; make hunspell-zip
	mv HUNSPELL/hunspell-$(ABRX)-$(DATE).zip .

hunspell-clean:
	cd HUNSPELL; make clean



#-------------------------------------------------------------------
# wordlist rules
#-------------------------------------------------------------------
wordlist: port.dic
	cd WORDLIST; make wl; make diff

wordlist-bz2: wordlist
	cd WORDLIST; make bz2
	cp WORDLIST/wordlist.$(ABRX)-$(DATE).tar.bz2 .
	cp WORDLIST/rawdiffwordlist.$(ABRX)-$(DATE).txt .
	cp WORDLIST/verbdiffwordlist.$(ABRX)-$(DATE).txt .

wordlist-clean:
	cd WORDLIST; make clean


#-------------------------------------------------------------------
# jspell rules
#-------------------------------------------------------------------

jspell-rpm: jspell-tgz
	mv $(DIST_DIR).tar.gz ~/rpms/SOURCES/jspell.$(ABR).tgz
	perl -pe 's/VERSION/chomp($$a=`date +%Y%m%d`);$$a/e;' jspell.pt.spec.in > jspell.pt.spec
	rpmbuild -ba jspell.pt.spec 


jspell: port.hash port.irr

jspell-install: port.hash port.irr
	mkdir -p $(LIB)
	cp port.hash $(LIB)
	cp port.irr  $(LIB)
	cp port.meta  $(LIB)


# Jspell port man

install-man: jspell-pt.1
	cp jspell.pt.1  /usr/local/man/man1/

jspell-pt.1: jspell.pt.pod
	pod2man --center="jSpell Documentation" jspell.pt.pod jspell-pt.1


################
jspell-tgz: $(EXTRADIST)
	mkdir -p $(DIST_DIR)/IRR
	cp $(IRRFILES) $(DIST_DIR)/IRR

	mkdir -p $(DIST_DIR)/DIC
	cp $(PTDIC) $(DIST_DIR)/DIC

	cp $(EXTRADIST) $(DIST_DIR)

	cp dist_makefile $(DIST_DIR)/makefile
	cp port.meta $(DIST_DIR)/port.meta
	perl -pi -e 's/DISTDATE/chomp($$a=`date +%Y%m%d`);$$a/e;' $(DIST_DIR)/makefile
	perl -pi -e 's!DICFILES!$(PTDIC)!'                        $(DIST_DIR)/makefile

	tar -zcvf $(DIST_DIR).tar.gz $(DIST_DIR)
	rm -fr $(DIST_DIR)


################

port.hash: port.dic port.aff
	jbuild port.dic port.aff port.hash

#-------------------------------------------------------------------
# chuveiro rules
#-------------------------------------------------------------------

chuveiro: jspell-tgz wordlist-bz2 ispell-tgz myspell-tgz myspell-zip aspell6-tgz aspell5-tgz hunspell-tgz hunspell-zip

install: #wordlist-diff
	cp aspell5*$(DATE)*bz2 $(NATURA_WWW)/aspell
	ln -sf $(NATURA_WWW)/aspell/aspell5-$(ABR)-$(DATE)-0.tar.bz2 $(NATURA_WWW)/aspell/aspell5-$(ABR)-latest.tar.bz2

	cp my*.gz $(NATURA_WWW)/myspell
	ln -sf $(NATURA_WWW)/myspell/myspell.$(ABR)-$(DATE).tar.gz $(NATURA_WWW)/myspell/myspell.$(ABR)-latest.tar.gz

	cp my*.zip $(NATURA_WWW)/myspell
	ln -sf $(NATURA_WWW)/myspell/myspell.$(ABR)-$(DATE).zip $(NATURA_WWW)/myspell/myspell.$(ABR)-latest.zip

	cp huns*.gz $(NATURA_WWW)/hunspell
	ln -sf $(NATURA_WWW)/hunspell/hunspell-$(ABRX)-$(DATE).tar.gz $(NATURA_WWW)/hunspell/hunspell-$(ABRX)-latest.tar.gz

	cp huns*.zip $(NATURA_WWW)/hunspell
	ln -sf $(NATURA_WWW)/hunspell/hunspell-$(ABRX)-$(DATE).zip $(NATURA_WWW)/hunspell/hunspell-$(ABRX)-latest.zip

	cp i*.gz $(NATURA_WWW)/ispell
	ln -sf $(NATURA_WWW)/ispell/ispell.$(ABR)-$(DATE).tar.gz $(NATURA_WWW)/ispell/ispell.$(ABR)-latest.tar.gz

	cp j*.gz $(NATURA_WWW)/jspell
	ln -sf $(NATURA_WWW)/jspell/jspell.$(ABR)-$(DATE).tar.gz $(NATURA_WWW)/jspell/jspell.$(ABR)-latest.tar.gz

	cp aspell6*$(DATE)*bz2 $(NATURA_WWW)/aspell6
	ln -sf $(NATURA_WWW)/aspell6/aspell6-$(ABRX)-$(DATE)-0.tar.bz2 $(NATURA_WWW)/aspell6/aspell6-$(ABRX)-latest.tar.bz2

	cp rawdiff*$(DATE)*txt $(NATURA_WWW)/misc/rawdiff
	cp verbdiff*$(DATE)*txt $(NATURA_WWW)/misc/verbdiff
	cp word*$(DATE)*bz2 $(NATURA_WWW)/misc/wordlist
	ln -sf $(NATURA_WWW)/misc/wordlist/wordlist.$(ABRX)-$(DATE).tar.bz2 $(NATURA_WWW)/misc/wordlist/wordlist.$(ABRX)-latest.tar.bz2

	date >> $(NATURA_WWW)/CHANGELOG
	echo "* empty log *" >> $(NATURA_WWW)/CHANGELOG
#é necessário editar o ficheiro para efeitos do Atom XML que vai ser gerado
	vim $(NATURA_WWW)/CHANGELOG
#precaução
	cp $(NATURA_WWW)/atom.xml $(NATURA_WWW)/atom.xml~
	perl gFeed.pl
#	@echo "Go edit $(NATURA_WWW)/CHANGELOG !"

test: port.hash
	TESTS/test.pl
