Summary: jspell portuguese dictionary
Name: jspell.port
Version: 1.10
Release: 2
Copyright: GPL
Source: jspell.port.tgz
Group: Utilities/Text
Packager: jj@di.uminho.pt (Jose Joao Almeida)

#
# $Id$
#

%description
jspell is a morphological analyser. 
jspell.port is dictionary is for Portuguese language

%prep
%setup

#configure

%build

make jspell

%install

make install

%files

/usr/local/lib/jspell/port.hash
/usr/local/lib/jspell/port.irr
