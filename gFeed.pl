#!/usr/bin/perl

#Rui Vilela, Linguateca 2006
#Gera um feed para o lançamento de novas versões do dicionário

use strict;
use warnings;
use XML::Atom::Feed;
use XML::Atom::Entry;
use Data::Dumper;
use Date::Calc qw(Delta_Days);
use Date::Format qw(time2str);
use Encode;


my $DIC='/home/natura/download/sources/Dictionaries';
my $url='http://natura.di.uminho.pt/download/sources/Dictionaries/';
my @cvs=("$ENV{HOME}/dicionarios/jspell.pt/DIC",
	 "$ENV{HOME}/natura/dicionarios/jspell.pt/DIC");
my $cvs;

for (@cvs){
    if (-d "$_"){
	$cvs=$_;
	last;
    }
}

my $feedfile='Atom.xml';

$XML::Atom::DefaultVersion = "1.0";

my $feed = XML::Atom::Feed->new(Version => 1.0);

$feed->version; # 1.0
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

#######################################################
my $entry = XML::Atom::Entry->new(Version => 1.0);;
$entry->title(Encode::decode_utf8('Nova versão do dicionário português: '. `ls -rt -c1 $DIC/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`));

my $f=`ls -1t $DIC/jspell/*.gz |grep -v latest|head -n 2`;

$f=~s/\n//;

my $days;
if ($f=~/(\d{4})(\d{2})(\d{2})\D+(\d{4})(\d{2})(\d{2})/s){
    $days = abs(Delta_Days ($1,$2,$3,$4,$5,$6));
}else{
    warn "Problema com a pasta dos dicionários $DIC";
    exit;
}

my $rcvs=Encode::decode_utf8("<p>Alterações efectuadas desde a última actualização (Há $days dia".($days>1 ? "s" : '')."):</p>");
$rcvs.='='x67;
$rcvs.="\n\n";

foreach (`ls -1 $cvs/*.dic`){
    $rcvs.= Encode::decode('iso-8859-1',`cd $cvs; cvs diff -D "$days days ago" $_`);
}
$rcvs=~s/Index:.+\//<b>Ficheiro<\/b>: /g;
$rcvs=~s/RCS file.+\n//g;
$rcvs=~s/retrieving revision.+\n//g;
$rcvs=~s/-r[\d\.]+//g;
$rcvs=~s/\n/<\/br>\n/g;

#GET LAST ENTRYS
print Dumper \$rcvs;

$entry->content("$rcvs</br>\n<pre>".Encode::decode_utf8("Ver CHANGELOG para mais informações</pre>\n"));

$feed->add_entry($entry);

#######################################################

my $xml = $feed->as_xml;

$xml=~s/utf-8/iso-8859-1/i; #Resolver bug do módulo
my $data=time2str("%Y-%m-%dT%XZ",time,'GMT');
$xml=~s/(<entry.*)/$1<updated>$data<\/updated>/;


#print Dumper \$xml;

open my $F, ">$DIC/$feedfile" or warn "Não foi possível criar o ficheiro $feedfile - $!";
print $F $xml;
close $F;

print "$feedfile criado com sucesso!\n" if (-e "$DIC/$feedfile");
