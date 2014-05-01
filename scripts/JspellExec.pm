#!/usr/bin/perl -s

# Load JSpell ptbr dictionary for queries
# Please install the dictionary first (make install)

package JspellExec;

use strict;
use Lingua::Jspell;
use Lingua::Jspell::DictManager;
use File::chdir;
use JSON;
use File::Temp;
use Data::Dumper;

use open ':encoding(utf8)';
use open ':std';

local $SIG{CHLD} = 'IGNORE';

sub install {
  my ($path, $name) = @_;
  local $CWD = $path;
  install_dic({name=>$name, yaml=>'port.yaml', irr=>"port.irr"}, "port.aff", "port.dic");
}

sub install_singleton {
  my ($path, $name, $dicData) = @_;
  local $CWD = $path;

my $str = <<"AFFIX";
#n/CAT=nc//
#nm/CAT=nc,G=m,N=s//
#nmp/CAT=nc,G=m,N=p//
#nf/CAT=nc,G=f,N=s//
#nfp/CAT=nc,G=f,N=p//
#nn/CAT=nc,G=_,N=s//
#nm2/CAT=nc,G=2,N=s//
#nn2/CAT=nc,G=_,N=_//
#a/CAT=adj,N=s,G=m// na realidade N=?? G=??
#af/CAT=adj,N=s,G=f//
#am/CAT=adj,N=s,G=m//
#an/CAT=adj,N=s,G=_//
#av/CAT=adv//
#avl/CAT=adv,SUBCAT=lugar//
#avt/CAT=adv,SUBCAT=tempo//
#avn/CAT=adv,SUBCAT=neg//
#avq/CAT=adv,SUBCAT=quant//
#avm/FSEM=mente,CAT=adv,SUBCAT=modo//
#i/CAT=in//
#hm/CAT=a_nc,G=m,N=s//
#hm2/CAT=a_nc,G=2,N=s// Se for nc é masc. se for adj. é neutr
#hf/CAT=a_nc,G=f,N=s//
#hf2/CAT=a_nc,G=2,N=s// Se for nc é fem. se for adj. é neutro
#hn/CAT=a_nc,N=s,G=_//
#hn2/CAT=a_nc,N=_,G=_//
#pr/CAT=pref//
#v/CAT=v,T=inf,TR=_//  Na realidade TR=??
#vt/CAT=v,T=inf,TR=t//
#vi/CAT=v,T=inf,TR=i//
#vl/CAT=v,T=inf,TR=l//
#vn/CAT=v,T=inf,TR=_//
#o/CAT=nord,G=m,N=s//
#ca/CAT=card,N=p//

AFFIX

  my $filename = $name . '.dic';
  open my $fh, ">", $filename or die "could not open $filename: $!";
  print $fh $str;
  print $fh $dicData;
  close $fh; 
  install_dic({name=>$name, yaml=>'port.yaml', irr=>"port.irr"}, "port.aff", $filename);
}

sub get_temp_filename {
  my ($path) = @_;
    my $fh = File::Temp->new(
        TEMPLATE => 'tempXXXXX',
        DIR      => $path,
        SUFFIX   => '.dic',
    );
    my $fn = $fh->filename;
    $fn =~ s/\.dic//;

    return $fn;
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
      return "\"$r\""
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

sub init_dict {
  my ($name) = @_;
  my $dict = Lingua::Jspell->new( $name ) || die "could not open $name dict";   # select portuguese dictionary
  $dict->setmode({flags => 1});    # show  feature "flag" in output

  return $dict;
}

sub del_dict {
  my ($path, $name) = @_;
  # remover da pasta local
  unlink $path . $name . ".dic";

  # remover da pasta do sistema
  unlink "/usr/local/lib/jspell/" . $name . ".hash";
  unlink "/usr/local/lib/jspell/" . $name . ".aff";
  unlink "/usr/local/lib/jspell/" . $name . ".yaml";
}

sub run {
  my ($dict, $palavra) = @_;


    my $usr = $palavra;
    my @fea_palavra = $dict->fea($usr);

    my %resposta;
    $resposta{'analise'} = \@fea_palavra;

    
    my @der = $dict->der($usr);

    my %hashDerivadas;
    
    foreach my $dword (@der) {
      my @fea = $dict->fea($dword);
      foreach my $f (@fea) {
        if($$f{'rad'} eq $usr) {
          $hashDerivadas{$dword} = $f;
        }
      }
    }

    $resposta{'derivadas'} = \%hashDerivadas;

    return %resposta;
  
}

sub query_default {
  my ($path, $name, $query) = @_;
  # install($path, $name);
  my $dic = init_dict($name);

  my %res = run($dic, $query);
  return %res;
}

sub query_singleton {
  my ($path, $dicData) = @_;
  my $name = get_temp_filename();

  install_singleton($path, $name, $dicData);
  my $dic = init_dict($name);
  $dicData =~ /(.*?)\//;
  my $query = $1;
  my %res = run($dic, $query);
  del_dict($path, $name);
  return %res;
}

# print Dumper query_default("../out/jspell-ao/", "teste", "menino");
# print Dumper query_singleton("../out/jspell-ao/", "abismal/#an/p/");
1;

