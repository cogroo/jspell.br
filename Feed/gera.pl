#!/usr/bin/perl

use File::Slurp 'slurp';
use XML::Atom::Feed;
use XML::Atom::Entry;
use Text::Diff;
use IO::Uncompress::Gunzip 'gunzip';
use LWP::Simple;
use File::Copy;
use strict;
use warnings;
use utf8;

our $date = scalar(localtime);
our $dicbase = 'http://natura.di.uminho.pt/download/sources/Dictionaries';
sub _DEBUG_ { print STDERR "[$date] ", @_, "\n" }

feed_for('ao');
feed_for('preao');

sub feed_for {
    my $tipo = shift;

    _DEBUG_ "****** $tipo ******";

    # 1. Fetch current wordlist
    _DEBUG_ "Fetching old wordlist";
    getstore "$dicbase/wordlists/LATEST/wordlist-$tipo-latest.txt.gz" => "old.gz";
    gunzip "old.gz" => "old.txt";
    unlink "old.gz";

    # 2. Fetch new wordlist
    _DEBUG_ "Copying current wordlist";
    copy "out/wordlists/wl-$tipo.txt" => "new.txt";

    # 3. Compute differences
    _DEBUG_ "Computing differences";
    my $diff = diff "old.txt" => "new.txt", {STYLE => 'OldStyle'};
    unlink "new.txt";
    unlink "old.txt";

    # 4. Format HTML
    _DEBUG_ "Formatting diff into HTML";
    my $html = diff_to_html($diff);

    # 5. Save
    _DEBUG_ "Saving diff";
    my $time = time;
    open OUT, ">:utf8", "Feed/$tipo-$time.html" or die;
    print OUT $html;
    close OUT;
    `svn add Feed/$tipo-$time.html`;

    # 6. Remove if we have too many files there
    _DEBUG_ "Cleaning up";
    my @files = <Feed/$tipo-*.html>;
    while (@files > 6) {
        my ($file_to_delete) = sort @files;
        unlink $file_to_delete;
        `svn rm $file_to_delete`;
    }

    # 7. Commit
    _DEBUG_ "Committing diff file";
    `svn ci -m "Publish $date"`;

    # 8. Gerar feed
    _DEBUG_ "Generating feed";
    my $feed = XML::Atom::Feed->new;
    $feed->title("Dicionários Natura - $tipo");
    $feed->id("$tipo-$time");
    for my $file (reverse sort @files) {
        my $entry = XML::Atom::Entry->new;
        my $entry_time = $file;
        $entry_time =~ s/\D//g;
        $entry_time = localtime($entry_time);
        $entry->title("Actualizações: $entry_time");
        $entry->id($file);
        my $string = "<div>" . urlhtml() . slurp($file, binmode => ':utf8') . "</div>";
        $entry->content( $string );
        $feed->add_entry($entry);
    }
    open FEED, ">", "feed-$tipo.xml" or die;
    print FEED $feed->as_xml;
    close FEED;
}

sub urlhtml {
    return <<EOH;
<p>Download a partir de: <a href="http://natura.di.uminho.pt/download/sources/Dictionaries/">http://natura.di.uminho.pt/download/sources/Dictionaries/</a>.</p>
EOH
}

sub diff_to_html {
    my $diff = shift;
    my @diff = map {
        if (/^</) {
            s/^..//;
            "<span style='text-decoration: line-through; color: #990000;'>$_</span>"
        }
        elsif (/^>/) {
            s/^..//;
            "<span style='font-weight: bold; color: #009900;'>$_</span>"
        }
        else {
            ();
        }
    } split /\n/ => $diff;
    return join "<br/>\n" => @diff;
}
