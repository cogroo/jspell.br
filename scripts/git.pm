#!/usr/bin/perl -s

package git;

use strict;
use Data::Dumper;
use Archive::Tar;
use File::Copy;
use File::chdir;
use File::Path 'rmtree';
use Git::Repository;

my $PATH = '/home/colen/jspell_repo';
my $ARCHIVE = 'jspell.br.tar';

sub get_branch_path {
	my ($name) = @_;

	return "$PATH/$name/jspell.br/";
}

sub new_branch {
	my ($name) = @_;
	
	if( -d "$PATH/$name" ) {
		rmtree([ "$PATH/$name" ]);
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
	
	my $cmd = $r->command( split(' ', "pull origin master") );
    my $errput = join('\n', $cmd->stderr->getlines());
    my $output = join('\n', $cmd->stdout->getlines());
    $cmd->close;
    my $exit = $cmd->exit;

	if( $exit != 0 ) {
		die "Failed to pull origin master: $errput ";
	}

	# now we try to branch
	$cmd = $r->command( split(' ', "checkout -b $name") );
	$errput = join('\n', $cmd->stderr->getlines());
	$output = join('\n', $cmd->stdout->getlines());
	$cmd->close;
	$exit = $cmd->exit;

	if( $exit != 0 ) {
		die "Failed to checkout -b $name: \n $output $errput \n";
	}
}

sub commit {
	my ($name, $message) = @_;
	my $dir = "$PATH/$name/jspell.br/";


	my $r = Git::Repository->new( work_tree => $dir );
	
	my @c = split(' ', "commit -a -m");
	push(@c, $message);
	my $cmd = $r->command( @c );
    my $errput = join('\n', $cmd->stderr->getlines());
    my $output = join('\n', $cmd->stdout->getlines());
    $cmd->close;
    my $exit = $cmd->exit;

	if( $exit != 0 ) {
		die "Failed to commit changes: $output $errput ";
	}
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
	
	my $cmd = $r->command( split(' ', "checkout master") );
    my $errput = join('\n', $cmd->stderr->getlines());
    my $output = join('\n', $cmd->stdout->getlines());
    $cmd->close;
    my $exit = $cmd->exit;

	if( $exit != 0 ) {
		## safe to die here
		die "Failed to checkout master: $output $errput ";
	}

	##

	$cmd = $r->command( split(' ', "merge $name") );
    $errput = join('\n', $cmd->stderr->getlines());
    $output = join('\n', $cmd->stdout->getlines());
    $cmd->close;
    $exit = $cmd->exit;

	if( $exit != 0 ) {
		# unsafe die, need to checkout $name again

		my $err = "Fatal: failed to checkout master: $output $errput";
		
		$cmd = $r->command( split(' ', "checkout $name") );
	    $errput = join('\n', $cmd->stderr->getlines());
	    $output = join('\n', $cmd->stdout->getlines());
	    $cmd->close;
	    $exit = $cmd->exit;

		if( $exit != 0 ) {
			## safe to die here
			die "Failed to merge $name into master: $output $errput \n caused by \n    $err";
		}


		die "Failed to merge $name into master: $errput ";
	}

	# git push origin master
	# - Pushes commits to your remote repository stored on GitHub

	$cmd = $r->command( split(' ', "push origin master") );
    $errput = join('\n', $cmd->stderr->getlines());
    $output = join('\n', $cmd->stdout->getlines());
    $cmd->close;
    $exit = $cmd->exit;

	if( $exit != 0 ) {
		die "Failed to push origin master: $errput ";
	}

	##

	$cmd = $r->command( split(' ', "branch -d $name") );
    $errput = join('\n', $cmd->stderr->getlines());
    $output = join('\n', $cmd->stdout->getlines());
    $cmd->close;
    $exit = $cmd->exit;

	if( $exit != 0 ) {
		die "Failed to branch -d $name: $errput ";
	}
}

sub DELETE {
	my ($name) = @_;

	if( -d "$PATH/$name" ) {
		rmtree([ "$PATH/$name" ]);
	}
}

sub status {
	my ($name) = @_;

	if( !-d "$PATH/$name" ) {
		die "Repositorio $name não encontrado.";
	}
}

sub make {
	my ($name) = @_;
	{
		local $CWD = "$PATH/$name/jspell.br";
		system("make jspell");
	}
}

# my $ret = new_branch("mybranch");
# commit("mybranch", "a msg");
# push_to_git("zuado");
# make("zuado");
1;

