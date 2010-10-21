#-*- makefile -*- ----------------------------------------------------

ISPELLLIB=`ispell -vv | grep 'LIBDIR' | sed -e 's/.*"\(.*\)"/\1/'`

portugues.hash: portugues.dic portugues.aff
	buildhash portugues.dic portugues.aff portugues.hash

install : portugues.hash 
	cp portugues.hash $(ISPELLLIB)/
	cp portugues.aff $(ISPELLLIB)/portugues.aff
	-rm $(ISPELLLIB)/pt_PT.hash $(ISPELLLIB)/pt.hash $(ISPELLLIB)/port.hash
	ln -s $(ISPELLLIB)/portugues.hash $(ISPELLLIB)/pt_PT.hash
	ln -s $(ISPELLLIB)/portugues.hash $(ISPELLLIB)/pt.hash
	ln -s $(ISPELLLIB)/portugues.hash $(ISPELLLIB)/port.hash
