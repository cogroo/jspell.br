#---------------------------------------------------------------------
# make install

#ISPELLLIB=/usr/lib/ispell
ISPELLLIB=`ispell -vv | grep 'LIBDIR' | sed -e 's/.*"\(.*\)"/\1/'`
P=portugues

BASE= portugues.aff portugues.dic makefile README ispell.port.spec ver
#--------------------------------------------------------------------- 

portugues.hash: portugues.dic portugues.aff
	buildhash portugues.dic portugues.aff portugues.hash

install : $P.hash 
	cp $P.hash $(ISPELLLIB)/
	cp portugues.aff $(ISPELLLIB)/portugues.aff
	-rm $(ISPELLLIB)/pt_PT.hash $(ISPELLLIB)/pt.hash $(ISPELLLIB)/port.hash
	ln -s $(ISPELLLIB)/$P.hash $(ISPELLLIB)/pt_PT.hash
	ln -s $(ISPELLLIB)/$P.hash $(ISPELLLIB)/pt.hash
	ln -s $(ISPELLLIB)/$P.hash $(ISPELLLIB)/port.hash

rpm: ispell.port.tgz
	mv ispell.port.tgz /usr/src/redhat/SOURCES/
	rpm -ba ispell.port.spec

ispell.port.tgz: $(BASE)
	rm -rf ispell.port-`./ver`
	mkdir -p ispell.port-`./ver`
	cp $(BASE) ispell.port-`./ver`
	tar -cvzf ispell.port.tgz ispell.port-`./ver`
#	tar -cvzf ispell.port.tgz $(BASE)
#	rm -rf ispell.port-`./ver`/

clean:
	-rm *.hash
