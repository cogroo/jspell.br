all:
	@ echo " dicts          - Build all dicts"
	@ echo " tarballs       - Build all dicts and tarballs"
	@ echo
	@ echo " ispell-all     - Build ispell folders and tarballs"
	@ echo " ispell         - Build ispell folders only"
	@ echo
	@ echo " hunspell-all   - Build hunspell folders and tarballs"
	@ echo " hunspell       - Build ispell folders only"
	@ echo
	@ echo "chuveiro:"
	@ echo "\tchuveiro -- build all available dictionaries"
	@ echo "\tchuveiro-install -- online publish at natura"
	@ echo
	@ echo " For specific targets documentation:"
	@ echo "  - jspell-help  \t for jspell"
	@ echo "  - aspell5-help \t for aspell v5"
	@ echo "  - aspell6-help \t for aspell v6"
	@ echo "  - myspell-help \t for myspell"
	@ echo "  - wordlist-help\t for word-lists"
	@ echo

dicts: ispell hunspell

tarballs: ispell-all hunspell-all

wordlist-help:
	@ echo
	@ echo "wordlist:"
	@ echo "\twordlist -- builds a simple word list"
	@ echo "\twordlist-bz2 -- creates wordlist compressed file"
	@ echo "\twordlist-diff -- calculates real differences on the dictionary since last release"
	@ echo "\t                 (needs a previous release)"
	@ echo

myspell-help:
	@ echo
	@ echo "myspell:"
	@ echo "\tmyspell -- builds myspell dictionary (will make ispell if required)"
	@ echo "\tmyspell-install -- installs myspell"
	@ echo "\tmyspell-tgz -- creates myspell distribution file (tar.gz)"
	@ echo "\tmyspell-zip -- creates myspell distribution file (zip)"
	@ echo

jspell-help:
	@ echo
	@ echo "jspell:"
	@ echo "\tjspell -- builds jspell dictionary (jspell-big)"
	@ echo "\tjspell-install -- installs jspell"
	@ echo "\tjspell-dist -- creates jspell munged distribution file"
	@ echo "\tjspell-publish -- creates jspell-dist and -bin and uploads"
	@ echo

ispell-help:
	@ echo
	@ echo "ispell:"
	@ echo "\tispell -- builds ispell dictionary"
	@ echo "\tispell-install -- installs ispell"
	@ echo "\tispell-clean -- clears ispell generated dictionaries"
	@ echo "\tispell-tgz -- creates ispell distribution file"
	@ echo

aspell5-help:
	@ echo
	@ echo "aspell5:"
	@ echo "\taspell5 -- builds aspell 0.50 dictionary"
	@ echo "\taspell5-install -- installs aspell 0.50"
	@ echo "\taspell5-tgz -- creates aspell 0.50 distribution file"
	@ echo

aspell6-help:
	@ echo
	@ echo "aspell6:"
	@ echo "\taspell6 -- builds aspell 0.60 dictionary"
	@ echo "\taspell6-install -- installs aspell 0.60"
	@ echo "\taspell6-tgz -- creates aspell 0.60 distribution file"
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
# Garbage collecting :)
#-------------------------------------------------------------------
clean: aspell5-clean aspell6-clean myspell-clean wordlist-clean
	@ printf " Removing temporary files..."
	@ rm -f *.stat *.cnt *$(DATE)*txt
	@ rm -f *~ */*~ */*/*~
	@ rm -f aux_all_irr.dic 
	@ rm -f port.dic port.irr port.hash aux_verb.dic jspell-pt.1
	@ rm -f *.gz *.zip *.bz2
	@ printf " DONE\n"

realclean :: clean
