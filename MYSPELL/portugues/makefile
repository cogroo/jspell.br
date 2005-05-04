#----------------------------------------------------------------------
# make install -- 
#----------------------------------------------------------------------

all:
	@echo -e "make install -- Tries to install Myspell dictionary on default places"

install :
	if test -w /opt/OpenOffice.org/share/dict/ooo ; then \
		cp $P/*pt* /opt/OpenOffice.org/share/dict/ooo ; \
		echo "OpenOffice dict install!"; \
	fi;
	if test -w /usr/lib/mozilla/components/myspell ; then \
		cp $P/*pt* /usr/lib/mozilla/components/myspell; \
		echo "Mozilla dict install!"; \
	fi;
	if test -w /usr/lib/MozillaThunderbird/components/myspell ; then \
		cp $P/*pt* /usr/lib/MozillaThunderbird/components/myspell; \
		echo "Mozilla Thunderbird dict install!"; \
	fi;


