#---------------------------------------------------------------------
# make install

# make jspell
# make install-jspell
# make jspell.tgz

# make ispell   (very slow!!!)
# make install-ispell
# make ispell.tgz

# make dic.tgz

LIB=/usr/local/lib
ISPELLLIB=/home/jj/lib/ispell
JSPELLLIB=/home/jj/lib/jspell

PTDIC = port.geral.dic aux.all-irr.dic port.inf.dic port.np.dic

BASE= port.aff $(PTDIC) irregulares.txt aux.verb.dic \
      IRR/ge_verb.l IRR/ge_verb2.y makefile \
      pos2iso jsp2isp.pl README jspell.port.spec irr2perl

what:
	@ echo "make what? (jspell ispell install-jspell install-ispell)"

port.dic: $(PTDIC)
	cat $(PTDIC) > port.dic 

#--------------------------------------------------------------------- 
rpm: 
	make jspell.port.tgz
	mv jspell.port.tgz /home/jj/SOURCES/
	rpm -ba jspell.port.spec

install :  port.hash port.irr
	mkdir -p ${LIB}/jspell
	mv port.hash ${LIB}/jspell/
	mv port.irr  ${LIB}/jspell/

installj :  port.hash port.irr
	mv port.hash  $(JSPELLLIB)/
	mv port.irr  $(JSPELLLIB)/

port.irr: aux.all-irr.dic
	./irr2perl > port.irr

ispell: port.dic port.aff
	cd ISPELL; make

jspell: port.dic port.aff
	cd JSPELL; make

install-jspell: port.dic port.aff
	cd JSPELL; make install

jspell.port.tgz: $(BASE)
	rm -rf jspell.port-`./ver`
	mkdir -p jspell.port-`./ver`
	cp $(BASE) jspell.port-`./ver`
	tar -cvzf jspell.port.tgz jspell.port-`./ver`
	
port.tgz: $(BASE)
	tar -czf dic.tgz $(BASE)

aux.verb.dic: port.geral.dic
	egrep "CAT=v|\#v" port.geral.dic > aux.verb.dic

aux.all-irr.dic: irregulares.txt aux.verb.dic IRR/ge_verb
	IRR/ge_verb aux.verb.dic < irregulares.txt > aux.all-irr.dic

IRR/ge_verb: IRR/ge_verb.l IRR/ge_verb2.y
	cd IRR; make
#---------------------------------------------------------------------
# instalations

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
