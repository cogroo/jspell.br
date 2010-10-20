#---------------------------------------------------------------------
# Generates Hunspell dictionary format (backward compatible with myspell)
#---------------------------------------------------------------------

# make install
# make hunspell
# make tgz

P=pt_PT
D=$P
DATE=`date +%Y%m%d`


hunspell-ao: ../port-ao.dic
	@echo "extrair do Jspell a morfologia..."
	perl obtemRef.pl ../port.dic > h.tmp
	perl expandeRef.pl h.tmp ../port.dic > $P.dic
	perl genDicHunspell.pl $P.dic > _.dic

	@echo "converter formato do ficheiro de afixos"
	LC_ALL=pt_PT.iso88591 perl genAffHunspell.pl ../port.aff > _$P.aff
	cat $P.replace >> _$P.aff

	wc -l _.dic | cut -c 1-5 > _$P.dic
	cat _.dic >> _$P.dic

	iconv -f iso8859-1 -t utf-8 _$P.dic > $D/$P.dic
	iconv -f iso8859-1 -t utf-8 _$P.aff > $D/$P.aff


hunspell: ../port.dic
#extrair do Jspell a morfologia
	perl obtemRef.pl ../port.dic > h.tmp
	perl expandeRef.pl h.tmp ../port.dic > $P.dic
	perl genDicHunspell.pl $P.dic > _.dic

#converter formato do ficheiro de afixos
	LC_ALL=pt_PT.iso88591 perl genAffHunspell.pl ../port.aff > _$P.aff
	cat $P.replace >> _$P.aff

	wc -l _.dic | cut -c 1-5 > _$P.dic
	cat _.dic >> _$P.dic

#	mv _$P.dic $D/$P.dic
#	mv _$P.aff $D/$P.aff

#ISO-8859-1 > UTF-8
	iconv -f iso8859-1 -t utf-8 _$P.dic > $D/$P.dic
	iconv -f iso8859-1 -t utf-8 _$P.aff > $D/$P.aff

hunspell-tgz: tgz

hunspell-zip: hunspell
	mkdir hunspell-$(P)-$(DATE)
	cp $D/$P.dic $D/README_$(P).txt $D/$P.aff hunspell-$(P)-$(DATE)
	cp ../DOC/COPYING hunspell-$(P)-$(DATE)
	zip -r hunspell-$(P)-$(DATE).zip hunspell-$(P)-$(DATE)
	rm -rf hunspell-$(P)-$(DATE)

tgz: hunspell
	mkdir hunspell-$(P)-$(DATE)
	cp $D/$P.dic $D/README_$(P).txt $D/$P.aff hunspell-$(P)-$(DATE)
	cp ../DOC/COPYING hunspell-$(P)-$(DATE)
	tar -czf hunspell-$(P)-$(DATE).tar.gz hunspell-$(P)-$(DATE)
	rm -rf hunspell-$(P)-$(DATE)


hunspell-ao-tgz: hunspell-ao
	mkdir hunspell-ao-$(P)-$(DATE)
	cp $D/$P.dic $D/README_$(P).txt $D/$P.aff hunspell-ao-$(P)-$(DATE)
	cp ../DOC/COPYING hunspell-ao-$(P)-$(DATE)
	tar -czf hunspell-ao-$(P)-$(DATE).tar.gz hunspell-ao-$(P)-$(DATE)
	rm -rf hunspell-ao-$(P)-$(DATE)


install :
	echo "Manualmente"

../port.dic:
	cd ..; make port.dic

clean : 
	rm -rf hunspell-$(P)-$(DATE)
	rm -rf *~ $D/*~ $D/*aff *gz $D/*~ $D/*dic *zip *aff *dic *tmp $D/_*


