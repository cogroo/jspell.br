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
DIST_DIR=jspell.$(ABR)-$(DATE)

LIB=`jspell-dict --dic-dir`
ISPELLLIB=/home/jj/lib/ispell
JSPELLLIB=/home/jj/lib/jspell

IRRFILES=IRR/ge_verb.l IRR/ge_verb2.y IRR/makefile


PTDIC = DIC/port.geral.dic DIC/port.inf.dic DIC/port.np.dic DIC/port.siglas.dic
EXTRADIST = irregulares.txt irr2perl port.aff jspell-pt.1

BASE= port.aff $(PTDIC) irregulares.txt aux.verb.dic \
      IRR/ge_verb.l IRR/ge_verb2.y makefile \
      PERL/pos2iso PERL/jsp2isp.pl README jspell.port.spec irr2perl

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

#-------------------------------------------------------------------
# Generated files
#-------------------------------------------------------------------

port.dic: $(PTDIC) aux.all-irr.dic 
	echo -e '## THIS IS A GENERATED FILE!! DO NOT EDIT!!\n\n' > port.dic
	cat $(PTDIC) >> port.dic 



port.irr: aux.all-irr.dic
	./irr2perl > port.irr

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
	cd JSPELL; make clean
	cd ISPELL; make clean
	rm -f *.stat *.cnt

realclean:
	cd IRR;    make realclean
	cd JSPELL; make realclean
	cd ISPELL; make realclean
	rm -f *.stat *.cnt 
	rm -f aux.all-irr.dic 
	rm -f port.dic

#-------------------------------------------------------------------
# ispell rules
#-------------------------------------------------------------------

ispell: port.dic port.aff
	cd ISPELL; make

ispell-install: ispell
	cd ISPELL; make install

ispell-tgz: ispell
	cd ISPELL; make tgz
	mv ISPELL/$(LING)/ispell.$(ABR).$(DATE).tar.gz .

#-------------------------------------------------------------------
# aspell rules
#-------------------------------------------------------------------

aspell: port.dic port.aff
	(cd ASPELL; make)

aspell-install: aspell
	cd ASPELL; make install

aspell-tgz:
	(cd ASPELL; make tgz)
	mv ASPELL/aspell.$(ABR).$(DATE).tar.gz .

#-------------------------------------------------------------------
# jspell rules
#-------------------------------------------------------------------

jspell-rpm: jspell-tgz
	mv $(DIST_DIR).tar.gz ~/rpms/SOURCES/jspell.$(ABR).tgz
	perl -pe 's/VERSION/chomp($$a=`date +%Y%d%m`);$$a/e;' jspell.pt.spec.in > jspell.pt.spec
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
	perl -pi -e 's/DISTDATE/chomp($$a=`date +%Y%d%m`);$$a/e;' $(DIST_DIR)/makefile
	perl -pi -e 's!DICFILES!$(PTDIC)!'                        $(DIST_DIR)/makefile

	tar -zcvf $(DIST_DIR).tar.gz $(DIST_DIR)
	rm -fr $(DIST_DIR)


################

port.hash: port.dic port.aff
	jbuild port.dic port.aff port.hash

