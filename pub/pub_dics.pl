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

  );

open(DIC_HTML, ">", "$dir/dics.html") or die "$!";
print {DIC_HTML} $template->output;
close(DIC_HTML);
