%define src_ver 0.03
%define languagelocal portugues
%define languageeng portuguese
%define languageenglazy Portuguese
%define languagecode pt
%define lc_ctype pt_PT

Summary:       %{languageenglazy} files for aspell
Name:          aspell-%{languagecode}
Version:       0.03
Release:       1mdk
Group:         System/Internationalization
Source:        aspell-dict-portugues-%{src_ver}.tar.gz
URL:           http://natura.di.uminho.pt/~jj/SOURCES
Copyright:     GPL
BuildRoot:     %{_tmppath}/%{name}-%{version}-root

BuildRequires: aspell
Requires:      aspell

# Mandrake Stuff
Requires:      locales-%{languagecode}
Provides:      aspell-dictionary

ExcludeArch:   ia64
Autoreqprov:   no

%description
A %{languageenglazy} dictionary for use with aspell, a spelling checker.

%prep
%setup -q -n portugues

%build
cp %{_datadir}/aspell/iso8859-1.dat .

mv -f portugues.aspell words.%{languagelocal}

LC_CTYPE=%{lc_ctype} aspell --lang=%{languagelocal} --data-dir=. \
    create master ./%{languagelocal} < words.%{languagelocal}

%install
rm -fr $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_libdir}/aspell
mkdir -p $RPM_BUILD_ROOT%{_datadir}/aspell
mkdir -p $RPM_BUILD_ROOT%{_datadir}/pspell

install -m 0644 %{languagelocal} $RPM_BUILD_ROOT%{_libdir}/aspell
install -m 0644 %{languagelocal}.dat $RPM_BUILD_ROOT%{_datadir}/aspell

if ls %{languagelocal}_phonet.dat ; then
 install -m 0644 %{languagelocal}_phonet.dat $RPM_BUILD_ROOT/usr/share/aspell
fi

echo "%{_libdir}/aspell/%{languagelocal}" > $RPM_BUILD_ROOT%{_datadir}/pspell/%{languagecode}-aspell.pwli

if [ "%{languagelocal}" != "%{languageeng}" ];then

 cd $RPM_BUILD_ROOT%{_libdir}/aspell
 ln -s %{languagelocal} %{languageeng}
 
 cd $RPM_BUILD_ROOT%{_datadir}/aspell
 ln -s %{languagelocal}.dat %{languageeng}.dat
 
 if ls %{languagelocal}_phonet.dat ; then
  ln -s %{languagelocal}_phonet.dat %{languageeng}_phonet.dat
 fi

fi

%clean
rm -fr $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc README LISEZMOI COPYING
%{_datadir}/aspell/*
%{_libdir}/aspell/*
%{_datadir}/pspell/*

%changelog

