#!/usr/bin/perl

use jspell;
use locale;

sub remflag{
   my($dicname,$f,@wl)=@_;
   my $p=join("|",@wl);

   open(Di,"$dicname") or die;
   open(Do,"> $dicname.novo") or die;

   while(<Di>){
     s!^((?:$p)/.*?/[^/]*)$f!$1!;
     print Do $_;
  }
}

sub addflag{
   my($dicname,$f,@wl)=@_;
   my $p=join("|",@wl);

   open(Di,"$dicname") or die;
   open(Do,"> $dicname.novo") or die;

   while(<Di>){
     s!^((?:$p)/.*?/[^/]*)$f!$1!;
     s!^((?:$p)/.*?/)!$1$f!;
     print Do $_;
  }
}

addflag("big.dic","H","estático","autarca","linha");
remflag("big.dic.novo","H","estático","linha");
