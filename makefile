all:
	@ echo " dicts          - Build all dicts"
	@ echo " tarballs       - Build all dicts and tarballs"
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
	@ echo "chuveiro:"
	@ echo "\tchuveiro -- build all available dictionaries"
	@ echo "\tchuveiro-install -- online publish at natura"
	@ echo
	@ echo "  - myspell-help \t for myspell"
	@ echo

dicts: jspell wordlist ispell hunspell aspell5 aspell6

tarballs: ispell-all hunspell-all  wordlist-all aspell5-all aspell6-all

myspell-help:
	@ echo
	@ echo "myspell:"
	@ echo "\tmyspell -- builds myspell dictionary (will make ispell if required)"
	@ echo "\tmyspell-install -- installs myspell"
	@ echo "\tmyspell-tgz -- creates myspell distribution file (tar.gz)"
	@ echo "\tmyspell-zip -- creates myspell distribution file (zip)"
	@ echo

include makefiles/makefile.vars
include makefiles/makefile.jspell
include makefiles/makefile.ispell
include makefiles/makefile.aspell50
include makefiles/makefile.aspell60
include makefiles/makefile.myspell
include makefiles/makefile.hunspell
include makefiles/makefile.wordlist
include makefiles/makefile.chuveiro


#-------------------------------------------------------------------
# Garbage collection :)
#-------------------------------------------------------------------
clean: myspell-clean 
	@ rm -f *~ */*~ */*/*~

realclean :: clean
