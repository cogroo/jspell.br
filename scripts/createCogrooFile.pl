#!/usr/bin/perl -s

use strict;
use Lingua::Jspell;
use Lingua::Jspell::DictManager;
use File::chdir;
use File::Path qw(make_path);
use Data::Dumper;
use locale;
use POSIX 'locale_h';


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
my $dic = init("../out/jspell-ao/port.dic") or die "nao abriu port.dic";

# this is to analyze
my $pt_dict = Lingua::Jspell->new("teste") or die "nao abriu";

my $out = "../out/cogroo/";
make_path($out);

# list of entries
open (SIMPLE,	'>:encoding(UTF-8)', $out.'tagdict.txt');


if($isCollectTags) {
	# list of tags
	open (TAG,		'>:encoding(UTF-8)', $out.'TAG_ptPT.txt');
}

if($isCollectContractions) {
	# the contractions
	open (CON,		'>:encoding(UTF-8)', $out.'contractions.txt');
}

if($isCollectVerbTransitivity) {
	# the contractions
	open (TRAN,		'>:encoding(UTF-8)', $out.'trans.txt');
}

# hash to remove duplicates and sort... is it necessary for simple? maybe we should serialize it directly to make it faster

my %tags;
my %con;

# features to add. Only if 1 will add
my %features = (
        ABR => 0,
        SEM => 0,
        PREAO90 => 0,
        EQAO90 => 0,
        AG => 1,
        PFSEM => 0,
        FSEM => 0,
        ORIG => 0,
        Adv => 0,
        Art => 0,
        BRAS => 0,
        CAR => 0,
        GR => 0,
        I => 0,
        LA => 0,
        PT => 0,
        PFSEM => 0,
        Pind => 0,
        Pdem => 0,
        Ppes => 0,  
        SEM => 0,
        SUBCAT => 0, 
        guess => 0,
        unknown => 0,
        AN => 0,
        unknown => 0,
        CLA => 0,
        ORIT => 0,
        Pdem2 => 0,
        Prep2 => 0,
        Prep => 0,
        TR => 0,
        
    );

my $i;
$dic->foreach_word(
	sub {
		# gets each word from dictionary
		my $word = shift;
		# list of derived words
		my @der = $pt_dict->der($word);
		foreach my $dword (@der) {
				# gets the analysis a 
				my @fea = $pt_dict->fea($dword);
				foreach my $key (@fea) {
					my $analisis;
					my $rad;
					if(!($dword =~ m/\S-\S/ && ${$key}{'CAT'} eq 'v')) { #avoid amar-lhe, amo-lha-ei etc
						my $trans;
						while ( my ($k,$v) = each %$key ) {
							if( $k eq "rad" ) {
								$rad = $v;
							}
						    elsif( !defined($features{$k}) ) {
							    $analisis .= "$k:$v|";
							    if($isCollectTags) {
							    	$tags{"$k:$v"} = 1; # enable to create a log of tags
							    }
							}
							elsif( $k eq 'TR' ) {
						    	$trans = $v;
							}
						}
						$rad =~ s/ /_/g;
						print SIMPLE "$dword $rad>$analisis\n";
						if($trans) {
							print TRAN "$dword\t$rad\t$trans\n";
						}
						#$simple{$dword}{"$rad>$analisis"} = 1;
						if($isCollectContractions && ${$key}{'CAT'} eq 'cp') {
							$con{$dword} = 1;
						}			
					}
				}
		}#foreach
		$i++;
		print STDERR "."      unless $i % 100;
    	print STDERR " "      unless $i % 1000;
	    print STDERR "[$i]\n" unless $i % 5000;
	}#sub
);

print STDERR " [$i]\n";

close SIMPLE or die "bad SIMPLE: $! $?";

if($isCollectTags) {
	for my $t ( sort keys %tags ) {
			print TAG "$t\n";
	}
	
	close TAG or die "bad TAG: $! $?";
}


if($isCollectContractions) {
	for my $t ( sort keys %con ) {
			print CON "$t\n";
	}
	
	close CON or die "bad CON: $! $?";
}

if($isCollectVerbTransitivity) {
	close TRAN or die "bad TRAN: $! $?";
}
