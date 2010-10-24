all:
	@ echo " dicts          - Build all dicts"
	@ echo " tarballs       - Build all dicts and tarballs"
	@ echo
	@ echo " jspell-all     - Build jspell folders and tarballs"
	@ echo " jspell         - Build jspell folders only"
	@ echo
	@ echo " ispell-all     - Build ispell folders and tarballs"
	@ echo " ispell         - Build ispell folders only"
	@ echo
	@ echo " hunspell-all   - Build hunspell folders and tarballs"
	@ echo " hunspell       - Build hunspell folders only"
	@ echo
	@ echo " aspell5-all    - Build aspell v0.50 folders and tarballs"
	@ echo " aspell5        - Build aspell v0.50 folders only"
	@ echo
	@ echo " wordlist       - Build wordlist folders only"
	@ echo
	@ echo "chuveiro:"
	@ echo "\tchuveiro -- build all available dictionaries"
	@ echo "\tchuveiro-install -- online publish at natura"
	@ echo
	@ echo "  - myspell-help \t for myspell"
	@ echo

dicts: ispell hunspell aspell5 wordlist jspell

tarballs: ispell-all hunspell-all aspell5-all wordlist-all

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
	@ printf " Removing temporary files..."
	@ rm -f *.stat *.cnt *$(DATE)*txt
	@ rm -f *~ */*~ */*/*~
	@ rm -f aux_all_irr.dic 
	@ rm -f port.dic port.irr port.hash aux_verb.dic jspell-pt.1
	@ rm -f *.gz *.zip *.bz2
	@ printf " DONE\n"

realclean :: clean
