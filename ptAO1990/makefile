I=regras.pt-ptao

#O seguinte poderá ser passado pela makefile anterior, ou mesmo integrado ...
ABRX=pt_PT
DATE=`date +%Y%m%d`
#D=jspell.$(ABR).dic
DMIX=jspell.$(ABR)-MixAO90.dic
DAO=jspell.$(ABR)-AO90.dic

#PTDIC = DIC/port.geral.dic DIC/port.inf.dic DIC/port.np.dic DIC/port.siglas.dic DIC/port.abrev.dic DIC/port.estrg.dic DIC/port.jurid.dic

PTDIC = ../DIC/port.geral.dic

DIRAO = DIC/AO
DIRMIXAO = ../DIC/MixAO

all:
	perl hashRegras.pl $I > $I.hash
#	perl converteDicAO.pl -mix $I.hash $(PTDIC) $(DIRMIXAO)
#	perl converteDicAO.pl $I.hash $(PTDIC) $(DIRAO)	
	perl converteDicAO.pl $I.hash $(PTDIC)

clean:
