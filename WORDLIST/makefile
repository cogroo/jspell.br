#Makefile para gerar a lista de palavras do dicionário

L=pt_PT
DATE=date +%Y%m%d

all: wl

wl: ../port.dic
	perl gerarWordList.pl ../port.dic > wordlist.$L-`$(DATE)`.txt

bz2: #wl
	tar cfj wordlist.$L-`$(DATE)`.tar.bz2  wordlist.$L-`$(DATE)`.txt

diff: wl
	rm *bz2
	cp $(OLDWL)/`ls -t1r $(OLDWL)/*20*bz2 |tail -n1` oldwl.tar.bz2
	tar xfjO oldwl.tar.bz2 > oldwl.txt
	diff oldwl.txt wordlist.$L-`$(DATE)`.txt > rawdiffwordlist.$L-`$(DATE)`.txt	perl -lne 'chomp; push @i if /^>/; push @o if /^</; print "Diferenças de palavras desde a última versão (FALTA ID DA VERSÃO ANTERIOR)"; print "\n\n**Removidas**"; map {print} @o; print "\n\n**Adicionadas**" map {print} @i' verbosediffwordlist.$L-`$(DATE)`.txt > wordlist.$L-`$(DATE)`.txt
../port.dic:
	cd ..; make port.dic

clean : 
	rm -rf *~ *.txt *bz2
