Summary: ispell portuguese dictionary
Name: ispell.port
Version: 3.00
Release: 1
Copyright: GPL
Source: ispell.port.tgz
Group: Utilities/Text
Packager: jj@di.uminho.pt (Jose Joao Almeida) - Proj Natura
requires: ispell
# conflicts: ispell64

#
# $Id$
#

%description 
Português:
ispell.port  é o dicionário português para o corrector ortográfico ispell.

English:
ispell.port is the ispell spell checker dictionary for Portuguese language

%prep
%setup

%build

make portugues.hash

%install

make install

%files

/usr/lib/ispell/portugues.hash
/usr/lib/ispell/port.hash
