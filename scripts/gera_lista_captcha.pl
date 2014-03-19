#!/usr/bin/perl -s

use strict;
use Lingua::Jspell;
use Lingua::Jspell::DictManager;
use File::chdir;
use File::Path qw(make_path);
use Data::Dumper;
use locale;
use POSIX 'locale_h';
use List::Util qw(shuffle);

sub build {
	local $CWD = "..";
	my $result = `make jspell`;
	
	#print $result;
}

sub install {
	local $CWD = "../out/jspell-ao/";
	install_dic({name=>"teste", yaml=>'port.yaml', irr=>"port.irr"}, "port.aff", "port.dic");
}

# try to install the dictionary
build();
install();

my $isCollectTags = 0;
my $isCollectContractions = 0;
my $isCollectVerbTransitivity = 1;

# ptbr.dic for production, sample.dic for test

# this is to iterate the dictionaries
my $dic = Lingua::Jspell::DictManager::init("../out/jspell-ao/port.dic") or die "nao abriu port.dic";

# this is to analyze
my $pt_dict = Lingua::Jspell->new("teste") or die "nao abriu";

my $out = "../out/cogroo/";
make_path($out);

# list of entries
open (SIMPLE,	'>:encoding(UTF-8)', $out.'captcha.txt');

my $i;
my @allWords;
$dic->foreach_word(
	sub {
		# gets each word from dictionary
		my $word = shift;
		# list of derived words
		my @der = $pt_dict->der($word);
		foreach my $dword (@der) {
				if($dword =~ /^[a-z]+$/ 
					&& $dword eq lc($dword)
					&& length($dword) > 4) {
					# print "$dword ";
					push(@allWords, $dword);
				}
		}#foreach
		$i++;
		print STDERR "."      unless $i % 100;
    	print STDERR " "      unless $i % 1000;
	    print STDERR "[$i]\n" unless $i % 5000;
	}#sub
);

my $num_picks = 5400;

# Shuffled list of indexes into @allWords
my @shuffled_indexes = shuffle(0..$#allWords);

# Get just N of them.
my @pick_indexes = @shuffled_indexes[ 0 .. $num_picks - 1 ];  

# Pick cards from @deck
my @picks = @allWords[ @pick_indexes ];

print SIMPLE "lenght=$num_picks\n";
foreach my $t ( sort( @picks )) {
		print SIMPLE "$t;";
}



close SIMPLE or die "bad SIMPLE: $! $?";
