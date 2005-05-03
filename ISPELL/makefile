#---------------------------------------------------------------------
# make install

# make ispell   (very slow!!!)

### same thing ###
# make tgz 
# make ispell.tgz

# make publish

LIB=/usr/lib
ISPELLLIB=/usr/lib/ispell

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
#plndir=/home/jj/public_html/pln
FR = mv $D.dic _$D.dic ; mv $D.aff _$D.aff
#FR = perl flagsRenDel $D

ispell.tgz: tgz

tgz:
	tar -czf $P/ispell.$(ABR).$(DATE).tar.gz $P/$D.dic $P/README $P/$D.aff $P/makefile

publish: tgz
	mv $P/$D.tgz $(plndir)/UM$D.tgz

ispell : $P/$D.hash $P/README

$P/README: ../port.aff
	perl -e '$$/ = ""; $$a=<>; print $$a;' ../port.aff > $P/README

$P/$D.hash: $P/$D.dic $P/$D.aff $P/README
	cd $P; buildhash $D.dic $D.aff $D.hash

$P/$D.aff $P/$D.dic: ../port.dic ../port.aff 
	#mkdir -p $P
	#perl jsp2isp.pl ../port.aff > /tmp/$D.aff 
	#perl jsp2isp.pl ../port.dic | grep -v '[#-]'  > /tmp/$D.dic
	perl jsp2isp.pl ../port.aff > $P/$D.aff 
	perl jsp2isp.pl ../port.dic | grep -v '[#-]'  > $P/$D.dic
	#cp flagsRenDel /tmp/

	cp ver ispell.port.spec $P

	#cd /tmp
	#perl flagsRenDel $D
	#munchlist -l $P/$D.aff $P/_$D.dic > $P/$D.dic;

	#cd /tmp; perl flagsRenDel $D; ${FR} ; munchlist -l /tmp/_$D.aff /tmp/_$D.dic > /tmp/$D.dic
	#cd $P
	#mv /tmp/$D.dic $P/
	#mv /tmp/$D.aff $P/ 

../port.dic:
	cd ..; make port.dic

#---------------------------------------------------------------------
# instalations

install : $P/$D.hash 
	cp $P/$D.hash $(ISPELLLIB)
	ln -sf $(ISPELLLIB)/$D.hash $(ISPELLLIB)/port.hash

clean : 
	rm -f $P/*.stat $P/*.cnt  $P/$D.hash

realclean:
	rm -f $P/*.stat $P/*.cnt 
	rm -f $P/$D.hash 
	rm -f $P/$D.dic $P/$D.aff 
