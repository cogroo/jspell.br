#-------------------------------------------------------------------
# Run 'make' to view options
#-------------------------------------------------------------------

# Version $Revision$

#-------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------

LING=portugues
ABR=pt
DATE=`date +%Y%m%d`
DIST_DIR=jspell-$(ABR).$(DATE)

LIB=`jspell-dict --dic-dir`
#ISPELLLIB=/home/jj/lib/ispell
#JSPELLLIB=/home/jj/lib/jspell

IRRFILES=IRR/ge_verb.l IRR/ge_verb2.y IRR/makefile


PTDIC = DIC/port.geral.dic DIC/port.inf.dic DIC/port.np.dic DIC/port.siglas.dic
EXTRADIST = irregulares.txt irr2perl port.aff jspell-pt.1

BASE= port.aff $(PTDIC) irregulares.txt aux.verb.dic \
      IRR/ge_verb.l IRR/ge_verb2.y makefile \
      PERL/pos2iso PERL/jsp2isp.pl README jspell.port.spec irr2perl

LINGUATECA_PUB=/home/www/htdocs/dics
NATURA_PUB=/home/natura/download/sources/Dictionaries

#-------------------------------------------------------------------
# Instructions
#-------------------------------------------------------------------
what:

	@ echo
	@ echo -e "jspell:"
	@ echo -e "\tjspell -- builds jspell dictionary"
	@ echo -e "\tjspell-install -- installs jspell"
	@ echo -e "\tjspell-tgz -- creates jspell munged distribution file"
	@ echo
	@ echo -e "ispell:"
	@ echo -e "\tispell -- builds ispell dictionary (slow)"
	@ echo -e "\tispell-install -- installs ispell"
	@ echo -e "\tispell-tgz -- creates ispell distribution file"
	@ echo
	@ echo -e "aspell:"
	@ echo -e "\taspell -- builds aspell dictionary (slow)"
	@ echo -e "\taspell-install -- installs aspell"
	@ echo -e "\taspell-tgz -- creates aspell distribution file"
	@ echo
	@ echo -e "myspell:"
	@ echo -e "\tmyspell -- builds myspell dictionary (will make ispell if required)"
	@ echo -e "\tmyspell-install -- installs myspell"
	@ echo -e "\tmyspell-tgz -- creates myspell distribution file (tar.gz)"
	@ echo -e "\tmyspell-zip -- creates myspell distribution file (zip)"
	@ echo
	@ echo -e "chuveiro:"
	@ echo -e "\tshower -- build all available dictionaries"
	@ echo -e "\tpublish-natura -- online publish at natura"
	@ echo -e "\tpublish-linguateca -- online publish at linguateca"
	@ echo
#-------------------------------------------------------------------
# Generated files
#-------------------------------------------------------------------

port.dic: $(PTDIC) aux.all-irr.dic 
	echo -e '## THIS IS A GENERATED FILE!! DO NOT EDIT!!\n\n' > port.dic
	cat $(PTDIC) aux.all-irr.dic >> port.dic 



port.irr: aux.all-irr.dic
	./irr2perl aux.all-irr.dic > port.irr

aux.verb.dic: DIC/port.geral.dic
	egrep "CAT=v|\#v" DIC/port.geral.dic > aux.verb.dic

aux.all-irr.dic: irregulares.txt aux.verb.dic IRR/ge_verb
	IRR/ge_verb aux.verb.dic < irregulares.txt > aux.all-irr.dic

IRR/ge_verb: IRR/ge_verb.l IRR/ge_verb2.y
	cd IRR; make

tgz:
	make clean
	cd .. ; tar -cvzf jspell.pt.tgz jspell.pt ; mv jspell.pt.tgz jspell.pt/dicionario.pt.tgz

jspell.port.tgz: $(BASE)
	rm -rf jspell.port-`./ver`
	mkdir -p jspell.port-`./ver`
	cp $(BASE) jspell.port-`./ver`
	tar -cvzf jspell.port.tgz jspell.port-`./ver`

port.tgz: $(BASE)
	tar -czf dic.tgz $(BASE)

#-------------------------------------------------------------------
# Garbage collecting :)
#-------------------------------------------------------------------
clean : 
	cd IRR;    make clean
	cd ISPELL; make clean
	cd ASPELL; make clean
	cd MYSPELL; make clean
	rm -f *.stat *.cnt
	rm -f *~

realclean: clean
	rm -f aux.all-irr.dic 
	rm -f port.dic
	rm -f *.gz

#-------------------------------------------------------------------
# ispell rules
#-------------------------------------------------------------------

ispell: port.dic port.aff
	cd ISPELL; make

ispell-install: ispell
	cd ISPELL; make install

ispell-tgz:
	cd ISPELL; make tgz
	mv ISPELL/ispell-$(ABR).$(DATE).tar.gz .

#-------------------------------------------------------------------
# aspell rules
#-------------------------------------------------------------------

aspell: port.dic port.aff
	cd ASPELL; make

aspell-install: aspell
	cd ASPELL; make install

aspell-tgz: aspell
	cd ASPELL; make tgz
	mv ASPELL/aspell-$(ABR).$(DATE).tar.gz .

#-------------------------------------------------------------------
# myspell rules
#-------------------------------------------------------------------

myspell: port.dic port.aff
	cd MYSPELL; make

myspell-install: myspell
	cd MYSPELL; make install

myspell-tgz: myspell
	cd MYSPELL; make tgz
	mv MYSPELL/myspell-$(ABR).$(DATE).tar.gz .

#myspell-zip: myspell
#	cd MYSPELL; make zip
#	mv MYSPELL/myspell_$(ABR)_$(DATE).zip .

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


# Jspell port man

install-man: jspell.pt.1
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

shower: jspell-tgz ispell-tgz myspell-tgz aspell-tgz

publish-natura: shower
	cp as*.gz $(NATURA_PUB)/aspell
	ln -sf $(NATURA_PUB)/aspell/aspell-$(ABR).$(DATE).tar.gz $(NATURA_PUB)/aspell/aspell-$(ABR).latest.tar.gz
	cp my*.gz $(NATURA_PUB)/myspell
	ln -sf $(NATURA_PUB)/myspell/myspell-$(ABR).$(DATE).tar.gz $(NATURA_PUB)/myspell/myspell-$(ABR).latest.tar.gz
	cp i*.gz $(NATURA_PUB)/ispell
	ln -sf $(NATURA_PUB)/ispell/ispell-$(ABR).$(DATE).tar.gz $(NATURA_PUB)/ispell/ispell-$(ABR).latest.tar.gz
	cp j*.gz $(NATURA_PUB)/jspell
	ln -sf $(NATURA_PUB)/jspell/jspell-$(ABR).$(DATE).tar.gz $(NATURA_PUB)/jspell/jspell-$(ABR).latest.tar.gz

publish-linguateca: shower
	rm -f $(LINGUATECA_PUB)/*.gz
	cp *.gz $(LINGUATECA_PUB)
	cd pub; perl pub_dics.pl $(LINGUATECA_PUB)

