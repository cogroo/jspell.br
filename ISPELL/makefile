#---------------------------------------------------------------------
# make install

# make ispell   (very slow!!!)
# make ispell.tgz

LIB=/usr/local/lib
ISPELLLIB=/home/jj/lib/ispell

BASE= port.aff port.dic np.dic inf.dic irregulares.txt verb.dic \
      makefile all-irr.dic pos2iso jsp2isp.pl README irr2perl
#--------------------------------------------------------------------- 

todo: ispell

#----------------------------------------------------------------------------
# ispell
#----------------------------------------------------------------------------
# P - dir name of ispell files
# D - name of ispell portuguese dictionary

D=portugues
P=portugues
plndir=$$HOME/public_html/pln
ispell.tgz: 
	tar -czf $P/$N.tgz $P/$N.dic $P/README  $P/$N.aff
	mv $P/$N.tgz $(plndir)/UM$N.tgz
	
ispell : $P/$N.hash $P/README

$P/README: ../port.aff
	perl -e '$$/ = ""; $$a=<>; print $$a;' ../port.aff > $P/README

$P/$N.hash: $P/$N.dic $P/$N.aff $P/README
	cd $P; buildhash $N.dic $N.aff $N.hash

$P/$N.aff $P/$N.dic: ../port.dic ../port.aff 
	mkdir -p  $P
	jsp2isp.pl ../port.aff > /tmp/$N.aff 
	jsp2isp.pl ../port.dic | grep -v '[#-]'  > /tmp/$N.dic
	cp flagsRenDel /tmp/
	cd /tmp; perl flagsRenDel $N; munchlist -l _$N.aff _$N.dic > $N.dic ;
	cd $P; mv /tmp/$N.dic . ; mv /tmp/_$N.aff $N.aff

../port.dic:
	cd ..; make port.dic

#---------------------------------------------------------------------
# instalations

install : $P/$N.hash 
	cp $P/$N.hash $(ISPELLLIB)
	-rm $(ISPELLLIB)/port.hash
	ln -s $(ISPELLLIB)/$N.hash $(ISPELLLIB)/port.hash

clean : 
	rm -f $P/*.stat $P/*.cnt  $P/$N.hash

realclean:
	rm -f $P/*.stat $P/*.cnt 
	rm -f $P/$N.hash 
	rm -f $P/$N.dic $P/$N.aff 
