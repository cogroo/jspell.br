PTDIC=DICFILES
LIB=`jspell-dict --dic-dir`

all:
	@ echo
	@ echo ' Dicionário jspell (DISTDATE) '
	@ echo '------------------------------'
	@ echo
	@ echo ' NOTE: to install and build jspell you need a recent'
	@ echo '       jspell release (Lingua::Jspell 1.60 or later)'
	@ echo
	@ echo  make install - installs jspell dictionary
	@ echo  make build   - creates hash files, but do not install
	@ echo

build: IRR/ge_verb port.hash port.irr

install: build
	mkdir -p $(LIB)
	cp port.hash $(LIB)
	cp port.irr  $(LIB)
	cp port.yaml $(LIB)

port.hash: port.dic port.aff
	jbuild port.dic port.aff port.hash

port.irr: aux.all-irr.dic
	./irr2perl aux.all-irr.dic > port.irr

IRR/ge_verb:
	cd IRR; make ge_verb;

auxi.verb.dic: DIC/port.geral.dic
	egrep "CAT=v|\#v" DIC/port.geral.dic > auxi.verb.dic

aux.all-irr.dic: irregulares.txt auxi.verb.dic IRR/ge_verb
	IRR/ge_verb auxi.verb.dic < irregulares.txt > aux.all-irr.dic

port.dic: $(PTDIC) aux.all-irr.dic
	echo -e '## THIS IS A GENERATED FILE!! DO NOT EDIT!!\n\n' > port.dic
	cat $(PTDIC) aux.all-irr.dic >> port.dic 


