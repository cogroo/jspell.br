DICT = portugues.aspell

CONFIG = portugues.dat
PHONET = portugues_phone.dat

pkgdatadir = `aspell dump config | grep '^. data-dir current' | sed 's/^.*: \(.*\)$$/\1/'`
pkglibdir  = `aspell dump config | grep '^. dict-dir current' | sed 's/^.*: \(.*\)$$/\1/'`
pspell_pkgdatadir = `pspell-config pkgdatadir`

INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644

all: portugues pt-aspell.pwli

portugues: $(DICT) $(PHONET) $(CONFIG)
	cp $(pkgdatadir)/iso8859-1.dat ./
	aspell --data-dir=. --lang=portugues create master ./portugues < $(DICT)

pt-aspell.pwli:
	echo $(pkglibdir)/portugues > pt-aspell.pwli

install: portugues
	${INSTALL_DATA} $(PHONET) $(pkgdatadir)/
	echo ${INSTALL_DATA} $(CONFIG) $(pkgdatadir)/
	echo ${INSTALL_DATA} portugues  $(pkglibdir)/
	echo ${INSTALL_DATA} pt-aspell.pwli $(pspell_pkgdatadir)/
	${INSTALL_DATA} $(CONFIG) $(pkgdatadir)/
	${INSTALL_DATA} portugues  $(pkglibdir)/
	${INSTALL_DATA} pt-aspell.pwli $(pspell_pkgdatadir)/

tar:
	cd ..; \
	echo portugues/portugues > portugues/EXCLUDE; \
	echo portugues/pt-aspell.pwli >> portugues/EXCLUDE; \
	echo portugues/EXCLUDE >> portugues/EXCLUDE; \
	echo portugues/iso8859-1.dat >> portugues/EXCLUDE; \
	tar cvzf portugues.tar.gz --exclude-from portugues/EXCLUDE  portugues

clean:
	rm -f *~ portugues EXCLUDE pt-aspell.pwli iso8859-1.dat
