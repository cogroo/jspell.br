d1=/opt/OpenOffice.org/share/dict/ooo
d2=/usr/lib/OpenOffice.org/share/dict/ooo

#----------------------------------------------------------------------
# make install -- 
#----------------------------------------------------------------------

all:
	@echo -e "make install -- Tries to install Myspell dictionary on default places"

install :
	if test -w $(d1) ; then \
		cp pt* $(d1); \
		if ! grep $(d1)/dictionary.lst -e 'DICT pt PT pt_PT' ; then echo "DICT pt PT pt_PT" >> $(d1)/dictionary.lst ; fi; \
		echo "OpenOffice dict install!"; \
	fi;
	if test -w $(d2) ; then \
		cp pt* $(d2); \
		if ! grep $(d2)/dictionary.lst -e 'DICT pt PT pt_PT' ; then echo "DICT pt PT pt_PT" >> $(d2)/dictionary.lst ; fi; \
		echo "OpenOffice dict install!"; \
	fi;
	if test -w /usr/lib/mozilla/components/myspell ; then \
		cp pt* /usr/lib/mozilla/components/myspell; \
		echo "Mozilla dict install!"; \
	fi;
	if test -w /usr/lib/MozillaThunderbird/components/myspell ; then \
		cp pt* /usr/lib/MozillaThunderbird/components/myspell; \
		echo "Mozilla Thunderbird dict install!"; \
	fi;



