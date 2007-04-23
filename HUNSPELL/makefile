#---------------------------------------------------------------------
# Generates Hunspell dictionary format (backward compatible with myspell)
#---------------------------------------------------------------------

# make install
# make hunspell
# make tgz

P=pt_PT
D=$P
DATE=`date +%Y%m%d`

hunspell: ../port.dic
#extrair do Jspell
	perl obtemRef.pl ../port.dic > h.tmp
	perl expandeRef.pl h.tmp ../port.dic > $P.dic
	perl genDicHunspell.pl $P.dic > _.dic

#converter formato do ficheiro de afixos
	LANG="pt_PT" perl genAffHunspell.pl ../port.aff > $D/$P.aff
	cat $P.replace >> $D/$P.aff

	wc -l _.dic | cut -c 0-5 > $D/$P.dic
	cat _.dic >> $D/$P.dic

hunspell-tgz: tgz

hunspell-zip: hunspell
	mkdir hunspell-$(P)-$(DATE)
	cp $D/$P.dic $D/README_$(P).txt $D/$P.aff hunspell-$(P)-$(DATE)
	cp ../COPYING hunspell-$(P)-$(DATE)
	zip -r hunspell-$(P)-$(DATE).zip hunspell-$(P)-$(DATE)
	rm -rf hunspell-$(P)-$(DATE)

tgz: hunspell
	mkdir hunspell-$(P)-$(DATE)
	cp $D/$P.dic $D/README_$(P).txt $D/$P.aff hunspell-$(P)-$(DATE)
	cp ../COPYING hunspell-$(P)-$(DATE)
	tar -czf hunspell-$(P)-$(DATE).tar.gz hunspell-$(P)-$(DATE)
	rm -rf hunspell-$(P)-$(DATE)

install :
	echo "Manualmente"

../port.dic:
	cd ..; make port.dic

clean : 
	rm -rf hunspell-$(P)-$(DATE)
	rm -rf *~ $D/*~ $D/*aff *gz $D/*~ $D/*dic *zip *aff *dic *tmp


