#!/usr/bin/perl -s

package git;

use strict;
use Data::Dumper;
use Archive::Tar;
use File::Copy;
use File::chdir;
use File::Path 'rmtree';
use Git::Repository;

my $PATH = '/Users/colen/git/lixo';
my $ARCHIVE = 'jspell.br.tar';


sub new_branch {
	my ($name) = @_;
	if( -d "$PATH/$name" ) {
		rmdir "$PATH/$name";
	}
	mkdir "$PATH/$name";
	my $dir = "$PATH/$name/jspell.br/";
	# descompactar clone inicial
	{
		local $CWD = "$PATH/$name";
		my $tar = Archive::Tar->new("$PATH/$ARCHIVE");
		$tar->extract();
	}

	# fazer git pull origin master para atualizar
	my $r = Git::Repository->new( work_tree => $dir );
	my @cmd = ('pull', 'origin', 'master');
	my $output = $r->run( @cmd );

	my $pullOk;
	if( $output =~ /Fast-forward/ || $output =~ /Already up-to-date/ ) {
		$pullOk = 1;
	} else {
		print "Failed to pull Repository updates: \n $output \n";
		$pullOk = 0;
	}

	if( $pullOk ) {
		# now we try to branch
		@cmd = ('checkout', '-b', $name);
		$output = $r->run( @cmd );

		if( $output =~ /Switched/ ) {
			return "OK";
		} else {
			print "Failed to checkout branch: \n $output \n";
			return $output;
		}
	} else {
		return $output;
	}
}

sub commit {
	my ($name, $message) = @_;
	my $dir = "$PATH/$name/jspell.br/";

	my $r = Git::Repository->new( work_tree => $dir );
	my @cmd = ('commit', '-am', $message);
	my $output = $r->run( @cmd );
	print $output . "\n";
}

sub push_to_git {
	my ($name) = @_;
	my $dir = "$PATH/$name/jspell.br/";

	my $r = Git::Repository->new( work_tree => $dir );

	# git checkout master
	# - Makes "master" the active branch
	# git merge mybranch
	# - Merges the commits from "mybranch" into "master"
	# git branch -d mybranch
	# - Deletes the "mybranch" branch
	
	my @cmd = ('checkout', 'master');
	my $output = $r->run( @cmd );
	print $output . "\n";

	@cmd = ('merge', $name);
	$output = $r->run( @cmd );
	print $output . "\n";

	@cmd = ('branch', '-d', $name);
	$output = $r->run( @cmd );
	print $output . "\n";

	# git push origin master
	# - Pushes commits to your remote repository stored on GitHub

	@cmd = ('push', 'origin', 'master');
	$output = $r->run( @cmd );
	print $output . "\n";
}

sub make {
	my ($name) = @_;
	{
		local $CWD = "$PATH/$name/jspell.br";
		system("make jspell");
	}
}

my $ret = new_branch("zuado");
# commit("zuado", "a msg");
# push_to_git("zuado");
make("zuado");
1;

