#---------------------------------------------------------------------
# make install
# make jspell

B=jspell.port
LIB=/usr/local/lib

PTDIC = port.geral.dic aux.all-irr.dic port.inf.dic port.np.dic

BASE= ../port.aff $(PTDIC) irregulares.txt aux.verb.dic \
      IRR/ge_verb.l IRR/ge_verb2.y makefile \
      pos2iso jsp2isp.pl README jspell.port.spec irr2perl

$B/port.hash: $B/port.dic ../port.aff
	cd $B; jbuild port.dic port.aff port.hash


$B/port.dic $B/port.aff $B/makefile $B/jspell.port.spec: ../port.dic ../port.aff  makefile.simple
	mkdir -p $B
	grep -v "nojspell" ../port.dic > $B/port.dic 
	cp ../port.aff $B/port.aff
	cp ../jspell.port.spec $B/
	cp ../ver $B/
	cp makefile.simple $B/makefile

install : $B/port.hash $B/port.irr
	mkdir -p ${LIB}/jspell
	cp $B/port.hash ${LIB}/jspell/
	cp $B/port.irr  ${LIB}/jspell/

base: $B/port.dic $B/port.aff $B/makefile  $B/jspell.port.spec $B/port.irr

#--------------------------------------------------------------------- 
rpm: 
	make base
	cd $B; make rpm

$B/port.irr: ../aux.all-irr.dic
	./irr2perl > $B/port.irr

jspell: $B/port.hash

dist: jspell.port.tgz

jspell.port.tgz:
	rm -rf jspell.port-`./ver`
	mkdir -p jspell.port-`./ver`
	cp $(BASE) jspell.port-`./ver`
	tar -cvzf jspell.port.tgz jspell.port-`./ver`
	
clean : 
	rm -f $B/*.stat $B/*.cnt 
	rm -f $B/port.hash $B/port.dic $B/port.aff

realclean:
	rm -f *.tgz
	rm -f $B/*.stat $B/*.cnt 
	rm -f $B/port.hash $B/port.dic $B/port.aff
