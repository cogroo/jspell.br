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
	tar -czf $P/$D.tgz $P/$D.dic $P/README  $P/$D.aff
	mv $P/$D.tgz $(plndir)/UM$D.tgz
	
ispell : $P/$D.hash $P/README

$P/README: ../port.aff
	perl -e '$$/ = ""; $$a=<>; print $$a;' ../port.aff > $P/README

$P/$D.hash: $P/$D.dic $P/$D.aff $P/README
	cd $P; buildhash $D.dic $D.aff $D.hash

$P/$D.aff $P/$D.dic: ../port.dic ../port.aff 
	mkdir -p  $P
	jsp2isp.pl ../port.aff > /tmp/$D.aff 
	jsp2isp.pl ../port.dic | grep -v '[#-]'  > /tmp/$D.dic
	cp flagsRenDel /tmp/
	cd /tmp; perl flagsRenDel $D; munchlist -l _$D.aff _$D.dic > $D.dic ;
	cd $P; mv /tmp/$D.dic . ; mv /tmp/_$D.aff $D.aff

../port.dic:
	cd ..; make port.dic

#---------------------------------------------------------------------
# instalations

install : $P/$D.hash 
	cp $P/$D.hash $(ISPELLLIB)
	-rm $(ISPELLLIB)/port.hash
	ln -s $(ISPELLLIB)/$D.hash $(ISPELLLIB)/port.hash

clean : 
	rm -f $P/*.stat $P/*.cnt  $P/$D.hash

realclean:
	rm -f $P/*.stat $P/*.cnt 
	rm -f $P/$D.hash 
	rm -f $P/$D.dic $P/$D.aff 
