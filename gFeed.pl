#!/usr/bin/perl -w

#Rui Vilela, Linguateca 2006
#Gera um feed para o lançamento de novas versões do dicionário
#USAR com makefile installweb

use strict;
use warnings;
use XML::Atom::Feed;
use XML::Atom::Entry;
use Data::Dumper;
use Date::Format qw(time2str);
use encoding "utf-8";
use Encode "decode";
use XML::DT;
use File::Spec;
use File::Basename 'basename';
use Cwd 'getcwd';



my $DIC='/home/natura/download/sources/Dictionaries';
my $url='http://natura.di.uminho.pt/download/sources/Dictionaries/';
#Assumir directoria da makefile
my $svn=File::Spec->catdir(getcwd, "DIC");

my $feedfile=File::Spec->catfile($DIC,'atom.xml');
#my $feedfile=File::Spec->catfile($DIC,'_atom.xml');

$XML::Atom::DefaultVersion = "1.0";
my $feed = XML::Atom::Feed->new(Version => 1.0);
my $data=time2str("%Y-%m-%dT%XZ",time);

#$feed->version; # 1.0
$feed->title("Dicionários Opensource para o português");

my $mlink = XML::Atom::Link->new;
$mlink->type('text/html');
$mlink->rel('alternate');
$mlink->href('http://natura.di.uminho.pt/natura/natura?topic=Dicion%E1rios');
$feed->add_link($mlink);

my $author = XML::Atom::Person->new;
$author->name('Rui Vilela');
$author->email('ruivilela@di.uminho.pt');
$feed->author($author);

(my $currentRevision=`svn update | tail -n 1`)=~s/^\D*(\d+)\D*$/$1/;

$feed->id(time2str("%s",time)."-".$currentRevision);
$feed->updated($data);
#$feed->icon($url."dic.ico");

#######################################################

my $ultRev=0; #E se não houver entradas ?
my @entry;

my %h = ( -outputenc => 'UTF-8',
	  -inputenc => 'UTF-8',
	  "entry/id" => sub{ 
	      if ($c=~/-(\d+)/) { 
		  $ultRev=$1 if ($1 > $ultRev); #Não funciona se já houver uma entrada no mesmo dia
	      };
	      "<$q>$c</$q>"
	  },
	  "entry" => sub{ push @entry, "<$q>$c</$q>" }
	  );

pathdt($feedfile,%h) if (-e $feedfile);

#######################################################
my $entry = XML::Atom::Entry->new(Version => 1.0);;

my $dd=File::Spec->catdir($DIC,'jspell');
my $l=`ls -rt -c1 $dd |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`; ##eval?
chomp $l;

$entry->title("Nova versão do dicionário: $l");

my $rsvn="<p>Disponível nos formatos: [";
$l=~s/^\w+//;
$rsvn.=" <a href='$url$_/$_$l.tar.gz'>$_</a> |" for (qw/jspell myspell aspell aspell6 ispell/);
$rsvn=~s/\|$/\]/;
$rsvn.="</p>";
my $lastUpdate=`svn log -r $ultRev |grep -e '^r' |awk '{print \$5,\$6}' `;
$rsvn.="<p>Alterações efectuadas desde a última actualização : $lastUpdate</p>";
$rsvn.="\n\n<code>";

foreach (`ls -1 $svn/*.dic`){
    if ($ultRev!=0){
	$rsvn.= Encode::decode('iso-8859-1',`cd $svn; svn diff -r $ultRev:$currentRevision --diff-cmd /usr/bin/diff -x -U0 $_`);
    }else{
	$rsvn.= "<p>Não foi possível obter as diferenças desde a última versão<p>"
    }
}

$rsvn=~s/Index:.+\//<b>Ficheiro<\/b>: /g;
$rsvn=~s!(---|\+\+\+).+?([^/]+\n)!$1$2!g;
$rsvn.="</code><p>Ver o <a href='".$url."CHANGELOG'>CHANGELOG</a></p>";
$rsvn.="<p>Para mais informações consultar: <a href='http://natura.di.uminho.pt/natura/natura?topic=Dicion%E1rios'>Dicionários no Natura</a> ou <a href='http://linguateca.di.uminho.pt/dics/dics.html'>Dicionários na Linguateca</a>.</p>\n";
$rsvn=~s/\n/<br\/>\n/g;

$entry->content($rsvn);

$entry->id(time2str("%s",time)."-".$currentRevision);
$entry->published($data);
$entry->updated($data);

$feed->add_entry($entry);

my $xml = $feed->as_xml;

######################################################

my $c=10;
my $d=substr($data,0,10);
for (@entry){
    next if (/$d/s); #Evitar mais do que uma entry por dia
    $xml=~s/<\/entry>/"$&\n$_"/e;
    last if (--$c==0);
}

#print Dumper \$xml;

open my $F, ">:utf8",$feedfile or warn "Não foi possível criar o ficheiro $feedfile - $!";
print $F $xml;
close $F;
print basename($feedfile)." criado com sucesso!\n" if (-e $feedfile);
