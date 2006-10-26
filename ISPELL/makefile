#---------------------------------------------------------------------
#  
# This is   ISPELL/makefile
#
#---------------------------------------------------------------------


# make install

# make ispell
# make tgz 
# make ispell.tgz

LIB=/usr/lib

#ISPELLLIB=/usr/lib/ispell
ISPELLLIB=`ispell -vv | grep 'LIBDIR' | sed -e 's/.*"\(.*\)"/\1/'`

BASE= port.aff port.dic np.dic inf.dic irregulares.txt verb.dic \
      makefile all-irr.dic pos2iso jsp2isp.pl README irr2perl

#--------------------------------------------------------------------- 

todo: ispell

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
	cp ../COPYING ispell.$(ABR)-$(DATE)
	cp $P/$D.dic $P/README $P/$D.aff $P/makefile ispell.$(ABR)-$(DATE)
	tar -czf ispell.$(ABR)-$(DATE).tar.gz ispell.$(ABR)-$(DATE)
	rm -fr ispell.$(ABR)-$(DATE)

ispell : $P/$D.hash $P/README

$P/README: ../port.aff
	perl -e '$$/ = ""; $$a=<>; print $$a;' ../port.aff > $P/README

$P/$D.hash: $P/$D.dic $P/$D.aff $P/README
	cd $P; buildhash $D.dic $D.aff $D.hash

$P/$D.aff $P/$D.dic: ../port.dic ../port.aff 
	perl jsp2isp.pl ../port.aff > $P/$D.aff 
	perl jsp2isp.pl ../port.dic | grep -v '[#-]'  > $P/_$D.dic
	munchlist -l $P/$D.aff $P/_$D.dic > $P/_.dic
#	cp $P/_$D.dic $P/_.dic
	sort $P/_.dic > $P/$D.dic
	rm -f $P/_$D.dic $P/_.dic
	cp ver ispell.port.spec $P



../port.dic:
	cd ..; make port.dic

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

