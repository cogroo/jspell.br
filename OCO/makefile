D=../DIC/port.geral.dic
#Não sei a origem deste ficheiro
F1=../../../misc/freqnormpt/lemas.todos_pt

lemasPublico:
	perl cut.pl $(F1) > freq.tmp
	perl freqLema.pl $(D) freq.tmp > listaFreqDic
	perl toHash.pl listaFreqDic > HashFreqDic.tmp
	mv HashFreqDic.tmp HashFreqDic

clean:
	rm -f *.tmp listaFreqDic *~
