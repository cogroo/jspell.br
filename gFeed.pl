#!/usr/bin/perl -w

#Rui Vilela, Linguateca 2006
#Gera um feed RSS 1.0 para vigiar o lançamento de novas versões do dicionário

#Falta acumulação de Itens devido a bug, (caracteres acentuadas?)

use XML::RSS;
use strict;
use Date::Format; 
use Data::Dumper;

my $date_syn_stamp = time2str("%Y-%m-%dT00:00+00:00", time, 'GMT');
my $pubdate_stamp = time2str("%C", time, 'GMT');

my $DIC='/home/natura/download/sources/Dictionaries';
my $url='http://natura.di.uminho.pt/download/sources/Dictionaries/';

my $feed='feed.rdf';

my $rss = new XML::RSS (version => '1.0',encoding=>'UTF-8');

#$rss->parsefile("$DIC/$feed") if (-e "$DIC/$feed");
$rss->channel(
	      title        => "Natura - Dicionários",
	      link         => "http://natura.di.uminho.pt",
	      description  => "Projecto Natura - Actualização dos dicionários portugueses (Jspell/Myspell/Aspell/Ispell)",
	      pubDate      => $pubdate_stamp,
	      language   => 'pt-pt',
	      dc => {
		  creator    => 'ruivilela@di.uminho.pt',
		  publisher  => 'ruivilela@di.uminho.pt',
		  rights     => 'Copyright 2006, Natura / Linguateca',
	      },
	      syn => { updatePeriod => 'hourly',
		       updateBase   => $date_syn_stamp,
		   },
	      taxo => [
		       "http://linguateca.di.uminho.pt",
		       "http://www.linguateca.pt"
		       ]
	      );

#pop(@{$rss->{'items'}}) if (@{$rss->{'items'}} == 10); #Número de itens a ficarem

#print Dumper $rss->{'items'};

$rss->add_item(about => time2str('%s',time),
	       title => 'Nova versão do dicionário português: '. `ls -rt -c1 $DIC/jspell |grep -v 'latest' |sed -e 's/\.tar\.gz//' |tail -n 1`,
	       link  => $url,
	       description => 'Nova actualização do dicionário português para Jspell/Myspell/Aspell/Ispell disponível. Ver CHANGELOG para mais informações',
                );

$rss->save("$DIC/$feed") 
