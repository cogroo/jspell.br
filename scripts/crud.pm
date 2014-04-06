#!/usr/bin/perl -s


# CRUD of jspell dictionaries!

# First we need to load the dictionaries into memory because we need things faaast
package crud;

use strict;
use Data::Dumper;
use Tie::LLHash;
use Tie::Autotie 'Tie::LLHash';
use List::BinarySearch::XS qw( binsearch_pos );
use JspellExec;

tie my(%dictionaries), 'Tie::LLHash';



####
#
# Create
#  to create a new entry we need to
#  know which dictionary
#  find the line where to input the entry
#  input the entry
#  serialize it
#
####

sub create {
	my ($path, $name, $entry) = @_;
	initialize($path);

	#find the insertion point
	my $key_before = find_insert_point($entry, $name);
	(tied %{$dictionaries{$name}})->insert($entry => '', $key_before);

	closeup($path);
}

sub retrieve_lemma {
	my ($path, $lemma) = @_;
	initialize($path);
	my %out;
	foreach my $name (keys %dictionaries) {
		my $key = (tied %{$dictionaries{$name}})->reset;
		while (defined $key) {
			if($key =~ /^$lemma\// || $key =~ /\$$lemma\$/) {
				if(! defined $out{$name} ) {
					$out{$name} = [];
				}
				push ($out{$name}, $key);
				
			}
			$key = (tied %{$dictionaries{$name}})->next;
		}
	}
	closeup($path);



	return %out;
}

sub update {
	my ($path, $name, $entry_before, $entry_after) = @_;
	initialize($path);

	(tied %{$dictionaries{$name}})->insert($entry_after => '', $entry_before);
	(tied %{$dictionaries{$name}})->DELETE($entry_before);

	closeup($path);
}

sub DELETE {
	my ($path, $name, $entry) = @_;
	initialize($path);
	
	(tied %{$dictionaries{$name}})->DELETE($entry);

	closeup($path);
}

###
#
# Auxiliary Methods
#
##

sub initialize {
	my ($path) = @_;
	(tied %dictionaries)->CLEAR;
	load_dictionaries($path);
}

sub closeup {
	my ($path) = @_;
	serialize_all($path);
}


sub load_into_memory {
	my ($path, $file, $name) = @_;

	# open file
	open (FILE, "<:encoding(ISO-8859-1)", "$path/DIC/$file");
	while (<FILE>) {
		 chomp;
		 (tied %{$dictionaries{$name}})->last($_);
	}
	close (FILE);
}

# find the dictionary names
sub load_dictionaries {
	my ($path) = @_;
	my $directory = $path . '/DIC';
	opendir (DIR, $directory) or die $!;
	while (my $file = readdir(DIR)) {
		if( $file =~ /^port\.(.+)\.dic$/ ) {
			my $key = $1;
			(tied %dictionaries)->last($key);
			load_into_memory($path, $file, $key);

			print "Loaded " . keys( $dictionaries{$key} ) . " into '" . $1 . "'\n";
		}
    }
}

sub find_insert_point {
	my ($str, $dic_name) = @_;
	my @keys = keys $dictionaries{$dic_name};
	my $index = binsearch_pos {$a cmp $b} $str, @keys;
	return $keys[$index];
}

sub serialize_all {
	my ($path) = @_;
	# foreach file, serialize it
	foreach my $value (keys %dictionaries) {
	     print "Serializing $value ...\n";

	     serialize($path, $value);
	}
}

sub serialize {
	my ($path, $name) = @_;
	open (FILE, ">:encoding(ISO-8859-1)", "$path/DIC/port.$name.dic");

 	my $key = (tied %{$dictionaries{$name}})->reset;
	while (defined $key) {
		print FILE "$key\n";
		$key = (tied %{$dictionaries{$name}})->next;
	}

	close (FILE);
}

# create('/Users/colen/git/lixo/mybranch/jspell.br', 'inf', 'hertz/#nm//');
# update('/Users/colen/git/lixo/mybranch/jspell.br', 'inf', 'bug/#nm,ORIG=ing/a/', 'bug/#nm,ORIG=ing/axyz/');
# DELETE('/Users/colen/git/lixo/mybranch/jspell.br', 'geral', 'hertz/#nm//');
print Dumper retrieve_lemma('/Users/colen/git/lixo/mybranch/jspell.br','águia-imperial');

1;
