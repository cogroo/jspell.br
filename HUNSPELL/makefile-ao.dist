# -*- makefile -*-

HPATH=`hunspell -D < /dev/null 2>&1| head -2| tail -1| perl -ne '$$l=$$_;($$f)=grep{-d $$_ && /^.../}split/:/,$$l; ($$f)=grep {/^.../}split/:/,$$l unless $$f;print"$$f\n"'`

all:
	@ echo "Type 'make install' to install this dictionary"

install:
	@ hunspell -v > /dev/null || \
                (echo "Hunspell is required. Plz install it. " && false)
	@ perl     -v > /dev/null || \
	        (echo "Perl is required. Try to install dictionary manually. " && false)
	mkdir -p $(HPATH)
	cp pt_PT.aff $(HPATH)
	cp pt_PT.dic $(HPATH)
