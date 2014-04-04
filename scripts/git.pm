#!/usr/bin/perl -s

use strict;
use Data::Dumper;
use Archive::Tar;
use File::Copy;
use File::chdir;
use Git::Repository;

my $PATH = '/Users/colen/git/lixo';
my $ARCHIVE = 'jspell.br.tar';

sub prepare_clone {
	my ($name) = @_;
	mkdir "$PATH/$name";
	copy("$PATH/$ARCHIVE","$PATH/$name/$ARCHIVE") or die "Copy failed: $!";
	my $dir = "$PATH/$name/jspell.br/";
	# descompactar clone inicial
	{
		local $CWD = "$PATH/$name";
		# my $tar = Archive::Tar->new("$PATH/$name/$ARCHIVE");
		# $tar->extract();
	}

	# fazer git pull origin master para atualizar
	my $r = Git::Repository->new( work_tree => $dir );
	my @cmd = ('pull', 'origin', 'master');
	my $output = $r->run( @cmd );
	print $output;
}

prepare_clone("zuado");