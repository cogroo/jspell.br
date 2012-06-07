
all:
	@ echo
	@ echo " dicts          - Build all dicts"
	@ echo " tarballs       - Build all dicts and tarballs"
	@ echo
	@ echo " jspell-all     - Build jspell folders and tarballs"
	@ echo " jspell         - Build jspell folders only"
	@ echo " ispell-all     - Build ispell folders and tarballs"
	@ echo " ispell         - Build ispell folders only"
	@ echo " hunspell-all   - Build hunspell folders and tarballs"
	@ echo " hunspell       - Build hunspell folders only"
	@ echo " aspell5-all    - Build aspell v0.50 folders and tarballs"
	@ echo " aspell5        - Build aspell v0.50 folders only"
	@ echo " aspell6-all    - Build aspell v0.60 folders and tarballs"
	@ echo " aspell6        - Build aspell v0.60 folders only"
	@ echo " wordlist       - Build wordlist folders only"
	@ echo
	@ echo " jspell-install - installs the 3 PT jspell dicts"
	@ echo
	@ echo " publish        - online publish at natura"
	@ echo

dicts: jspell wordlist ispell hunspell aspell5 aspell6

tarballs: jspell-all ispell-all hunspell-all wordlist-all aspell5-all aspell6-all

include makefiles/makefile.vars
include makefiles/makefile.jspell
include makefiles/makefile.ispell
include makefiles/makefile.aspell50
include makefiles/makefile.aspell60
include makefiles/makefile.hunspell
include makefiles/makefile.wordlist
include makefiles/makefile.chuveiro

include makefiles/makefile.ooo
include makefiles/makefile.mozilla

clean: 
	@ rm -f *~ */*~ */*/*~

realclean :: clean

test:
	perl -MTest::Harness -e 'runtests(<t/*.t>);'

feeds:
	perl Feed/gera.pl
	rsync -aASPvz feed-ao.xml    $(NATURA):$(NATURA_WWW)/feed-ao.xml
	rsync -aASPvz feed-big.xml   $(NATURA):$(NATURA_WWW)/feed-big.xml
	rsync -aASPvz feed-preao.xml $(NATURA):$(NATURA_WWW)/feed-preao.xml
	rsync -aASPvz feed-ao.xml    $(NATURA):$(NATURA_WWW)/atom.xml

