#!/usr/bin/perl

#########################################
# Script for updating dictionaries online
# 
# Rui Vilela - Linguateca, Pólo de Braga
#########################################

use HTML::Template;

$dir=shift; #path

sub estat{
	sprintf("%.1f KB",(((stat "$dir/$_[0]")[7])/1024));
}

sub listaherois{
    open $H, "<topmais.txt";
    $t='<tr>';
    while (<$H>){
	if /(\w+)\:(\w+)/{
	    $nome=$1;
	    $pals=$2;
	    $numero=split / /, $pals;
	    @pals=split / /, $pals;
	    foreach (reverse @pals){
		$upals=$_;
		$n++;
		last if ($n>2);
	    }
	    $t.='<td>'.$nome.'</td><td>'.$numero.'</td><td>'.$upals.'</td>'
	}
    }
    $t.='</tr>';
    return $t;
}

$data= `date +%Y%m%d`;
chomp($data);

my $template = HTML::Template->new(filename => 'lgdics.template');

$template->param(
      MYSPELL => 'myspell-pt.'.$data.'.tar.gz',
      ISPELL => 'ispell-pt.'.$data.'.tar.gz',
      ASPELL => 'aspell-pt.'.$data.'.tar.gz',
      JSPELL => 'jspell-pt.'.$data.'.tar.gz',
      SMYSPELL => &estat ('myspell-pt.'.$data.'.tar.gz'),
      SISPELL => &estat ('ispell-pt.'.$data.'.tar.gz'),
      SASPELL => &estat ('aspell-pt.'.$data.'.tar.gz'),
      SJSPELL => &estat ('jspell-pt.'.$data.'.tar.gz'),
      HEROIS => &listaherois,
  );

open(DIC_HTML, ">", "$dir/dics.html") or die "$!";
print {DIC_HTML} $template->output;
close(DIC_HTML);

### English

my $template = HTML::Template->new(filename => 'lgdics_en.template');

$template->param(
      MYSPELL => 'myspell-pt.'.$data.'.tar.gz',
      ISPELL => 'ispell-pt.'.$data.'.tar.gz',
      ASPELL => 'aspell-pt.'.$data.'.tar.gz',
      JSPELL => 'jspell-pt.'.$data.'.tar.gz',
      SMYSPELL => &estat ('myspell-pt.'.$data.'.tar.gz'),
      SISPELL => &estat ('ispell-pt.'.$data.'.tar.gz'),
      SASPELL => &estat ('aspell-pt.'.$data.'.tar.gz'),
      SJSPELL => &estat ('jspell-pt.'.$data.'.tar.gz'),
      HEROIS => &listaherois,
  );

open(DIC_HTML, ">", "$dir/dics_en.html") or die "$!";
print {DIC_HTML} $template->output;
close(DIC_HTML);
