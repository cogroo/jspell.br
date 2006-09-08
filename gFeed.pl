#!/usr/bin/perl -w

#Rui Vilela, Linguateca 2006
#Gera um feed para o lançamento de novas versões do dicionário
#USAR com makefile installweb

use strict;
use warnings;
use XML::Atom::Feed;
use XML::Atom::Entry;
use Data::Dumper;
use Date::Calc qw(Delta_Days);
use Date::Format qw(time2str);
use encoding "utf-8";
use Encode "decode";
use XML::DT;


my $DIC='/home/natura/download/sources/Dictionaries';
#my $DIC='/home/ruivilela/dd';
my $url='http://natura.di.uminho.pt/download/sources/Dictionaries/';
my @cvs=("$ENV{HOME}/dicionarios/jspell.pt/DIC",
	 "$ENV{HOME}/natura/dicionarios/jspell.pt/DIC");
my $feedfile='atom.xml';
my $cvs;

for (@cvs){
    if (-d "$_"){
	$cvs=$_;
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
$mlink->href('http://natura.di.uminho.pt/natura/natura?&topic=Dicion%E1rios');
$feed->add_link($mlink);

my $author = XML::Atom::Person->new;
$author->name('Rui Vilela');
$author->email('ruivilela@di.uminho.pt');
$feed->author($author);

$feed->id("http://natura.di.uminho.pt/,".time2str("%s",time));
$feed->updated($data);

#######################################################
my $entry = XML::Atom::Entry->new(Version => 1.0);;

my $l=`ls -rt -c1 $DIC/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`; ##eval?
$l=~s/\n$//;
$entry->title("Nova versão do dicionário: $l");

my $f=`ls -1t $DIC/jspell/*.gz |grep -v latest|head -n 2`; ##

$f=~s/\n//;

my $days;
if ($f=~/(\d{4})(\d{2})(\d{2})\D+(\d{4})(\d{2})(\d{2})/s){
    $days = abs(Delta_Days ($1,$2,$3,$4,$5,$6));
}else{
    warn "Problema com a pasta dos dicionários $DIC";
    exit;
}

my $rcvs="<p>Disponível nos formatos: [";
$l=~s/^\w+//;
$rcvs.=" <a href='$url$_/$_$l.tar.gz'>$_</a> |" for (qw/jspell myspell aspell aspell6 ispell/);
$rcvs=~s/\|$/\]/;
$rcvs.="</p>";
$rcvs.="<p>Alterações efectuadas desde a última actualização (Há $days dia".($days>1 ? 's' : '')."):</p>";
$rcvs.="\n\n<code>";

my $hours=$days*24-12; #Não contar o dia da última alteração?
foreach (`ls -1 $cvs/*.dic`){
   $rcvs.= Encode::decode('iso-8859-1',`cd $cvs; cvs diff -D "$hours hours ago" $_`); #eval?
}

$rcvs=~s/Index:.+\//<b>Ficheiro<\/b>: /g;
$rcvs=~s/RCS file.+\n//g;
$rcvs=~s/retrieving revision.+\n//g;
$rcvs=~s/-r[\d\.]+//g;

$rcvs.="</code><p>Para mais informações consultar: <a href='http://natura.di.uminho.pt/natura/natura?&topic=Dicion%E1rios'>Dicionários no Natura</a> ou <a href='http://linguateca.di.uminho.pt/dics/dics.html'>Dicionários na Linguateca</a>.</p>\n";
$rcvs=~s/\n/<br\/>\n/g;

$entry->content($rcvs);

$entry->id("http://natura.di.uminho.pt/,".time2str("%s",time));
$entry->published($data);
$entry->updated($data);

$feed->add_entry($entry);

my $xml = $feed->as_xml;

######################################################

my @entry;

my %h = ( -outputenc => 'UTF-8',
       -inputenc => 'UTF-8',
       'entry' => sub{push @entry, "<$q>$c</$q>"}
       ); 
dt("$DIC/$feedfile",%h) if (-e "$DIC/$feedfile");

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
