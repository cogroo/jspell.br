#!/usr/bin/perl -s


# CRUD of jspell dictionaries!

# First we need to load the dictionaries into memory because we need things faaast
package crud;

use strict;
use Data::Dumper;
use Tie::LLHash;
use Tie::Autotie 'Tie::LLHash';
use List::BinarySearch::XS qw( binsearch_pos );

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
	my ($name, $entry) = @_;
	initialize();

	#find the insertion point
	my $key_before = find_insert_point($entry, $name);
	(tied %{$dictionaries{$name}})->insert($entry => '', $key_before);

	closeup();
}

sub retrieve_lemma {
	my ($lemma) = @_;
	initialize();
	my %out;
	foreach my $name (keys %dictionaries) {
		if( $name eq 'zool') {
			print "aqui \n";
		}
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
	closeup();
	return %out;
}

sub update {
	my ($name, $entry_before, $entry_after) = @_;
	initialize();

	(tied %{$dictionaries{$name}})->insert($entry_after => '', $entry_before);
	(tied %{$dictionaries{$name}})->DELETE($entry_before);

	closeup();
}

sub DELETE {
	my ($name, $entry) = @_;
	initialize();
	
	(tied %{$dictionaries{$name}})->DELETE($entry);

	closeup();
}

###
#
# Auxiliary Methods
#
##

sub initialize {
	(tied %dictionaries)->CLEAR;
	load_dictionaries();
}

sub closeup {
	serialize_all();
}


sub load_into_memory {
	my ($file, $name) = @_;

	# open file
	open (FILE, "<:encoding(ISO-8859-1)", "../DIC/$file");
	while (<FILE>) {
		 chomp;
		 (tied %{$dictionaries{$name}})->last($_);
	}
	close (FILE);
}

# find the dictionary names
sub load_dictionaries {
	my $directory = '../DIC';
	opendir (DIR, $directory) or die $!;
	while (my $file = readdir(DIR)) {
		if( $file =~ /^port\.(.+)\.dic$/ ) {
			my $key = $1;
			(tied %dictionaries)->last($key);
			load_into_memory($file, $key);

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
	# foreach file, serialize it
	foreach my $value (keys %dictionaries) {
	     print "Serializing $value ...\n";

	     serialize($value);
	}
}

sub serialize {
	my ($name) = @_;
	open (FILE, ">:encoding(ISO-8859-1)", "../DIC/port.$name.dic");

 	my $key = (tied %{$dictionaries{$name}})->reset;
	while (defined $key) {
		print FILE "$key\n";
		$key = (tied %{$dictionaries{$name}})->next;
	}

	close (FILE);
}

#create('jurid', 'hertz/#nm//');
#update('inf', 'bug/#nm,ORIG=ing/a/', 'bug/#nm,ORIG=ing/axyz/');
#DELETE('geral', 'hertz/#nm//');
# print Dumper retrieve_lemma('águia-imperial');

1;
