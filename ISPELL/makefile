# Get ISPELL dict

LIB=/usr/lib

#ISPELLLIB=/usr/lib/ispell
ISPELLLIB=`ispell -vv | grep 'LIBDIR' | sed -e 's/.*"\(.*\)"/\1/'`

#BASE= port.aff port.dic np.dic inf.dic irregulares.txt verb.dic \
      makefile all-irr.dic pos2iso jsp2isp.pl README irr2perl # NOT USED?

#----------------------------------------------------------------------------
# ispell
#----------------------------------------------------------------------------
# P - dir name of ispell files
# D - name of ispell portuguese dictionary

# FR - Flag renaming (use flagsRenDel to get just 32 MASKBITS

D=portugues
P=portugues
ABR=pt
DATE=`date +%Y%m%d`
#FR = perl flagsRenDel $D

ispell-tgz: tgz

tgz: ispell
	mkdir ispell.$(ABR)-$(DATE)
	cp ../DOC/COPYING ispell.$(ABR)-$(DATE)
	cp $P/$D.dic $P/README $P/$D.aff $P/makefile ispell.$(ABR)-$(DATE)
	tar -czf ispell.$(ABR)-$(DATE).tar.gz ispell.$(ABR)-$(DATE)
	rm -fr ispell.$(ABR)-$(DATE)


#---------------------------------------------------------------------
# instalations

install : $P/$D.hash 
	cd $P; make install
#	cp $P/$D.hash $(ISPELLLIB)
#	ln -sf $(ISPELLLIB)/$D.hash $(ISPELLLIB)/port.hash

clean : 
	rm -f $P/*.stat $P/*.cnt  $P/$D.hash $P/$D.dic
	rm -f *.gz
	rm -f *~

realclean:
	rm -f $P/*.stat $P/*.cnt 
	rm -f $P/$D.hash 
	rm -f $P/$D.dic $P/$D.aff 
	rm -f *~ $P/*~

