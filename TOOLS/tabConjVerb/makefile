#UPDATE JSPELL DIC FIRST
D=../../DIC

all: 
	echo "make [irr|verb|clean]"

irr:
	cat $(D)/port.geral.dic |grep 'I=' |perl -npe 's/([^\/]+).*/$$1/' > verbosIrregulares~
	perl tabConjVerbalIrreg2latex.pl verbosIrregulares~
	pdflatex tabVerbI.tex
verb:	
	cat $(D)/port.geral.dic |grep '/#v' |perl -npe 's/([^\/]+).*/$$1/' > verbosRegulares~
	echo "Espere uns 6000 verbos..."
	perl tabConjVerbal2latex.pl verbosRegulares~
	pdflatex tabVerb.tex
clean: 
	rm -f tabVerb?.* *~