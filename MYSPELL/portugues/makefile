d1=/opt/OpenOffice.org/share/dict/ooo
d2=/usr/lib/OpenOffice.org/share/dict/ooo
#d3=~/.openoffice.org/*/user/wordbook/

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
		cp pt_PT.aff /usr/lib/mozilla/components/myspell/pt-PT.aff; \
		cp pt_PT.dic /usr/lib/mozilla/components/myspell/pt-PT.dic; \
		echo "Mozilla dict install!"; \
	fi;
	if test -w /usr/lib/MozillaThunderbird/components/myspell ; then \
		cp pt_PT.aff /usr/lib/thunderbird/components/myspell/pt-PT.aff; \
		cp pt_PT.dic /usr/lib/thunderbird/components/myspell/pt-PT.dic; \
		echo "Mozilla Thunderbird dict install!"; \
	fi;



