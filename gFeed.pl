#!/usr/bin/perl

#Rui Vilela, Linguateca 2006
#Gera um feed para o lançamento de novas versões do dicionário

use strict;
use warnings;
use XML::Atom::Feed;
use XML::Atom::Entry;
use Data::Dumper;
use Date::Calc qw(Delta_Days);

my $DIC='/home/natura/download/sources/Dictionaries';
my $url='http://natura.di.uminho.pt/download/sources/Dictionaries/';
my @cvs=qw!~/dicionarios/jspell.pt/DIC ~/natura/dicionarios/jspell.pt/DIC!;
my $cvs;

for (@cvs){
    $cvs=$_ && last if (-d $_);
}

my $feedfile='Atom.xml';

$XML::Atom::DefaultVersion = "1.0";

my $feed = XML::Atom::Feed->new;

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
my $entry = XML::Atom::Entry->new;
$entry->title('Nova versão do dicionário português: '. `ls -rt -c1 $DIC/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`);

my $f=`ls -1t *.gz |grep -v latest|head -n 2`;

$f=s/\n//;

my $D;
if (/(\d{4})(\d{2})(\d{2})\D+(d{4})(\d{2})(\d{2})/){
    $D=@-;
}

my $days = Delta_Days ($D);

my $rcvs;
foreach (`ls -1 $cvs`){
    $rcvs=`cd $cvs; cvs diff -D $days`;
}

print Dumper $rcvs;

$entry->content("Nova actualização do dicionário português para Jspell/Myspell/Aspell/Ispell disponível.\n\n Ver CHANGELOG para mais informações\n");

my $link = XML::Atom::Link->new;
$link->type('text/html');
$link->rel('alternate');
$link->href('http://www.example.com/2003/12/post.html');
$entry->add_link($link);

$feed->add_entry($entry);

#######################################################

my $xml = $feed->as_xml;

print Dumper $xml;

#$rss->add_item(about => time2str('%s',time),
#	       description => 'Nova actualização do dicionário português para Jspell/Myspell/Aspell/Ispell disponível. Ver CHANGELOG para mais informações',
#	       );
#
