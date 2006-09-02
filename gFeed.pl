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
#my $DIC='/home/ruivilela/dd';
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

my $feedfile='atom.xml';

$XML::Atom::DefaultVersion = "1.0";

my $feed = XML::Atom::Feed->new(Version => 1.0);

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

#######################################################
my $entry = XML::Atom::Entry->new(Version => 1.0);;

$entry->title(Encode::decode_utf8('Nova versão do dicionário: '. `ls -rt -c1 $DIC/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`));

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
$rcvs.="\n";

foreach (`ls -1 $cvs/*.dic`){
    $rcvs.= Encode::decode('iso-8859-1',`cd $cvs; cvs diff -D "$days days ago" $_`);
}

$rcvs=~s/Index:.+\//<b>Ficheiro<\/b>: /g;
$rcvs=~s/RCS file.+\n//g;
$rcvs=~s/retrieving revision.+\n//g;
$rcvs=~s/-r[\d\.]+//g;
$rcvs=~s/\n/<\/br>\n/g;

#GET LAST ENTRYS
#print Dumper \$rcvs;

$entry->content("$rcvs<pre>".Encode::decode_utf8("Ver CHANGELOG para mais informações")."</pre>\n");

$feed->add_entry($entry);

#######################################################

my $xml = $feed->as_xml;

$xml=~s/utf-8/iso-8859-1/i; #Resolver bug do módulo
#print Dumper \$xml;

my $data=time2str("%Y-%m-%dT%XZ",time);
$xml=~s/<feed.*/$&<updated>$data<\/updated>/;
$xml=~s/<entry.*/$&<updated>$data<\/updated><published>$data<\/published>/;

my $new = $& if ($xml=~/(<entry.*?<\/entry>)/s);
#print Dumper \$new;

#Barb
my $G;
open $G,"<feedHistory" || goto label1;

$/='</entry>';
my $c=10;
my $d=substr($data,0,10);
my $oldEntry='';
while (<$G>){
    next if (/$d/); #Evitar mais do que uma entry por dia
    next if /^\s$/s;
    $xml=~s/<\/entry>/$&$_/;
    last if (--$c==0);
    $oldEntry.=$_;
}

$/='\n';
close $G;

#print Dumper \$xml;
#print Dumper \$oldEntry;
label1:

open $G, ">feedHistory" || warn "Not keeping feed history!";
print $G $new."\n".$oldEntry;
close $G;

#print Dumper \$xml;

open my $F, ">$DIC/$feedfile" or warn "Não foi possível criar o ficheiro $feedfile - $!";
print $F $xml;
close $F;

#xmllint --format ?
print "$feedfile criado com sucesso!\n" if (-e "$DIC/$feedfile");
