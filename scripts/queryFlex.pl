#!/usr/bin/perl -s

# Load JSpell ptbr dictionary for queries
# Please install the dictionary first (make install)

use Lingua::Jspell;
use Lingua::Jspell::DictManager;
use File::chdir;
use JSON;

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

sub any2json {
  my ($r, $i) = @_;
  $i ||= 0;
  if (not $r) {return ""}
  if (ref $i) { any2json([@_]);}
  elsif ($i eq "compact") {
    if (ref($r) eq "HASH") {
      return "{". hash2json($r,$i) . "},"
    } elsif (ref($r) eq "ARRAY") {
      return "[" . join(",", map (any2json($_,$i), @$r)) . "]" 
    } else {
      return "$r"
    }
  } elsif ($i eq "f1") {
    if (ref($r) eq "HASH") {
      return "{". hash2json($r,"f1") . "},"
    } elsif (ref($r) eq "ARRAY") {
      return "[ " . join("  ,\n  ", map (any2json($_,"compact"), @$r)) . "]" 
    } else {
      return "$r"
    }
  } else {
  	my $ind = ($i >= 0)? (" " x $i) : "";
    if (ref($r) eq "HASH") {
      return $ind . " {". hash2json($r,abs($i)+3) . "},"
    } elsif (ref($r) eq "ARRAY") {
      return $ind . " [\n" . join("\n", map (any2json($_,abs($i)+3), @$r)) . "]"
    } else {
      return $ind . "\"$r\""
    }
  }
}

sub hash2json {
  my ($r, $i) = @_;
  my $c = "";
  if ($i eq "compact") {
    for (keys %$r) {
      $c .= any2json($_,$i). ":". any2json($r->{$_},$i). ",";
    }
    chop($c);
  } elsif ($i eq "f1") {
    for (keys %$r) {
      $c .= "\n  ", any2json($_,"compact"). ":". any2json($r->{$_},"compact"). ",\n";
    }
    chop($c);
  } else {
    for (keys %$r) {
      $c .= "\n". any2json($_,$i). ":". any2json($r->{$_},-$i) . ",";
    }
  }
  return $c;
}

sub run {
	my $dict = Lingua::Jspell->new( "ptbr") || die "could not open ptbr dict";   # select portuguese dictionary
	$dict->setmode({flags => 1});    # show  feature "flag" in output

	my $msg = "Digite uma palavra: \n";
	print $msg;
	while(<>) {
		chop;
		my $usr = $_;
		my @fea = $dict->fea($usr);

		my $flex = any2json ( [@fea] , 0) . "\n";
		$flex =~ s/,}/}/g;
		$flex =~ s/,]/]/g;
		print $flex;
		
		my @der = $dict->der($usr);
		
		foreach my $dword (@der) {
			@fea = $dict->fea($dword);
			foreach my $f (@fea) {
				if($$f{'rad'} eq $usr) {
					print "\t- " . $dword . any2json ( $f , "compact") . "\n";
				}
			}
			
		}
		print $msg;
	}
}

# try to install the dictionary
build();
install();
run();


