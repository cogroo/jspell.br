#!/usr/bin/perl -w

#Rui Vilela, Linguateca 2006
#Gera um feed para o lançamento de novas versões do dicionário

use strict;
use warnings;
use XML::Atom::Feed;
use XML::Atom::Entry;
use Data::Dumper;
use Date::Calc qw(Delta_Days);
use Date::Format qw(time2str);
use XML::DT;


#my $DIC='/home/natura/download/sources/Dictionaries';
my $DIC='/home/ruivilela/dd';
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

$entry->title('Nova versão do dicionário: '. `ls -rt -c1 $DIC/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`);

my $f=`ls -1t $DIC/jspell/*.gz |grep -v latest|head -n 2`; ##

$f=~s/\n//;

my $days;
if ($f=~/(\d{4})(\d{2})(\d{2})\D+(\d{4})(\d{2})(\d{2})/s){
    $days = abs(Delta_Days ($1,$2,$3,$4,$5,$6));
}else{
    warn "Problema com a pasta dos dicionários $DIC";
    exit;
}

my $rcvs="<p>Alterações efectuadas desde a última actualização (Há $days dia".($days>1 ? 's' : '')."):</p>";
$rcvs.='='x67;
$rcvs.="\n";

#foreach (`ls -1 $cvs/*.dic`){
#   $rcvs.= `cd $cvs; cvs diff -D "$days days ago" $_`; #eval?
#}

$rcvs=~s/Index:.+\//<b>Ficheiro<\/b>: /g;
$rcvs=~s/RCS file.+\n//g;
$rcvs=~s/retrieving revision.+\n//g;
$rcvs=~s/-r[\d\.]+//g;
$rcvs=~s/\n/<br\/>\n/g;

$entry->content("$rcvs<pre>Ver CHANGELOG para mais informações</pre>\n");

$entry->id("http://natura.di.uminho.pt/,".time2str("%s",time));
$entry->published($data);
$entry->updated($data);

$feed->add_entry($entry);

my $xml = $feed->as_xml;

######################################################

my $new = $& if ($xml=~/(<entry.*?<\/entry>)/s);

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

label1:

open $G, ">feedHistory" || warn "Not keeping feed history!";
print $G $new."\n".$oldEntry;
close $G;

#print Dumper \$xml;

open my $F, ">:utf8","$DIC/$feedfile" or warn "Não foi possível criar o ficheiro $feedfile - $!";
print $F $xml;
close $F;
print "$feedfile criado com sucesso!\n" if (-e "$DIC/$feedfile");
