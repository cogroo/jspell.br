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
LIB=/usr/local/lib
ISPELLLIB=/home/jj/lib/ispell
JSPELLLIB=/home/jj/lib/jspell

PTDIC = port.geral.dic aux.all-irr.dic port.inf.dic port.np.dic port.siglas.dic

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

port.dic: $(PTDIC)
	echo -e '## THIS IS A GENERATED FILE!! DO NOT EDIT!!\n\n' > port.dic
	cat $(PTDIC) >> port.dic 


port.irr: aux.all-irr.dic
	./irr2perl > port.irr

aux.verb.dic: port.geral.dic
	egrep "CAT=v|\#v" port.geral.dic > aux.verb.dic

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

jspell-rpm: 
	cd JSPELL; make rpm

jspell: port.dic port.aff
	cd JSPELL; make

jspell-install: port.dic port.aff
	cd JSPELL; make install

jspell-tgz: jspell
	mkdir -p jspell.$(ABR).$(DATE)
	cp JSPELL/jspell.port/port.hash jspell.$(ABR).$(DATE)
	cp JSPELL/jspell.port/port.irr  jspell.$(ABR).$(DATE)
	cp JSPELL/jspell.mkfile.dist jspell.$(ABR).$(DATE)/makefile
	tar zcvf jspell.$(ABR).$(DATE).tar.gz jspell.$(ABR).$(DATE)
	rm -fr jspell.$(ABR).$(DATE)

# Jspell port man

install-man: jspell.pt.1
	cp jspell.pt.1  /usr/local/man/man1/

jspell.pt.1: jspell.pt.pod
	pod2man --center="jSpell Documentation" jspell.pt.pod jspell.pt.1


################
jspell-distro:
	rm -f jspell-dist/src/*.dic
	rm -f jspell-dist/src/*.aff
	cp port.aff $(PTDIC) jspell-dist/src/
	(cd jspell-dist && ./autogen.sh && make distcheck && mv jspell.pt-*.tar.gz ..)