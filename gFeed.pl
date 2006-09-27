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


my $DIC='/home/natura/download/sources/Dictionaries';
#my $DIC='/home/ruivilela/dd';
my $url='http://natura.di.uminho.pt/download/sources/Dictionaries/';
my @svn=("$ENV{HOME}/dics/jspell.pt/DIC",
	 "$ENV{HOME}/natura/dicionarios/jspell.pt/DIC");

my $feedfile='atom.xml';
#my $feedfile='_atom.xml';

my $svn;

for (@svn){
    if (-d "$_"){
	$svn=$_;
	last;
    }
}

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

my $ultRev=0;
my @entry;

my %h = ( -outputenc => 'UTF-8',
	  -inputenc => 'UTF-8',
	  "feed/id" => sub{ if ($c=~/-(\d+)/) { $ultRev=$1 } },
	  "entry" => sub{ push @entry, "<$q>$c</$q>" }
       ); 

pathdt("$DIC/$feedfile",%h) if (-e "$DIC/$feedfile");

#######################################################
my $entry = XML::Atom::Entry->new(Version => 1.0);;

my $l=`ls -rt -c1 $DIC/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`; ##eval?
$l=~s/\n$//;
$entry->title("Nova versão do dicionário: $l");

my $rsvn="<p>Disponível nos formatos: [";
$l=~s/^\w+//;
$rsvn.=" <a href='$url$_/$_$l.tar.gz'>$_</a> |" for (qw/jspell myspell aspell aspell6 ispell/);
$rsvn=~s/\|$/\]/;
$rsvn.="</p>";
my $lastUpdate=`svn log -r $ultRev |grep -e '^r' |awk '{print \$5,\$6}' `;
$rsvn.="<p>Alterações efectuadas desde a última actualização desde : $lastUpdate</p>";
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

open my $F, ">:utf8","$DIC/$feedfile" or warn "Não foi possível criar o ficheiro $feedfile - $!";
print $F $xml;
close $F;
print "$feedfile criado com sucesso!\n" if (-e "$DIC/$feedfile");
