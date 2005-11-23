#!/bin/bash


#----------------------------------------------------------------------------------------
# install
#
# Install myspell dictionary on the directories of the most common programs that
# uses myspell (Mozilla, Thunderbird, OpenOffice 1.X and 2.X)
# This program is intended only for linux systems
# You may require root access
#
# NOTICE: CHECK BELLOW DIRECTORIES, BEFORE UPDATING THE DICTIONARY
#-----------------------------------------------------------------------------------------

OOO="/usr/lib/OpenOffice.org/share/dict/ooo $HOME/.ooo*/user/wordbook/  $HOME/.openoffice/*/user/wordbook/"

MOZILLA="$MOZILLA_FIVE_HOME /usr/lib/mozilla /usr/lib/mozilla-* /usr/lib/thunderbird /usr/lib/thunderbird-* /usr/lib/MozillaThunderbird /usr/local/mozilla /usr/local/mozilla-* /usr/local/thunderbird /usr/local/thunderbird-* /usr/local/mozilla-thunderbird /usr/local/MozillaThunderbird /opt/mozilla /opt/mozilla-* /opt/thunderbird /opt/thunderbird-* /opt/mozilla-thunderbird /opt/MozillaThunderbird"


echo -e "install -- Tries to install Myspell dictionary on default places"

for DIR in $OOO 
do
  if test -w $DIR ; then
      cp pt* $DIR
      if [ -h $DIR ]; then
	  continue
      fi

      if ! grep $DIR/dictionary.lst -e 'DICT pt PT pt_PT' ; then 
	  echo "DICT pt PT pt_PT" >> $DIR/dictionary.lst
      fi
      echo "OpenOffice dict install on $DIR !" ;
  fi
done

#Check current used directory ?

for DIR in $MOZILLA 
do
	if [ -h $DIR ]; then
		continue
	fi
	if test -w $DIR/components/myspell ; then
	        cp pt_PT.aff $DIR/components/myspell/pt-PT.aff
		cp pt_PT.dic $DIR/components/myspell/pt-PT.dic
		echo "Mozilla dict install on $DIR !"
	fi
done

