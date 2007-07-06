D=../../DIC

all:
#expansão das macros
	cat $(D)/*.dic |grep 'ORIG=' | perl -npe 's!/.*!!' |sort -u  > estrangeirismos~
	perl Estrangeirismos.pl estrangeirismos~
	pdflatex estrangeirismos.tex
clean:
	rm -f *~