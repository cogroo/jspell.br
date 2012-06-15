#!/usr/bin/perl -s

# Load JSpell ptbr dictionary for queries
# Please install the dictionary first (make install)

use Lingua::Jspell;
use Lingua::Jspell::DictManager;
use File::chdir;

use open ':encoding(utf8)';
use open ':std';

sub build {
	local $CWD = "..";
	$result = `make jspell`;
	
	#print $result;
}

sub install {
	local $CWD = "../out/jspell-ao/";
	install_dic({name=>"teste", yaml=>'port.yaml', irr=>"port.irr"}, "port.aff", "port.dic");
}

# try to install the dictionary
build();
install();

my $dict = Lingua::Jspell->new( "ptbr") || die "could not open ptbr dict";   # select portuguese dictionary
$dict->setmode({flags => 1});    # show  feature "flag" in output

my $msg = "Digite uma palavra: \n";
print $msg;
while(<>) {
	chop;
	
	my @fea = $dict->fea($_);
	
	print Lingua::Jspell::any2str ( [@fea] , 1) . "\n";
	
	my @der = $dict->der($_);
	
	foreach my $dword (@der) {
		@fea = $dict->fea($dword);
		
		print "\t- " . $dword . Lingua::Jspell::any2str ( [@fea] , "compact") . "\n";
	}
	print $msg;
}
