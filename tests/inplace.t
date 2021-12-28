#!./perl
use strict;
chdir "$ENV{PERL_ENV}";
chdir 't' if -d 't';
require './test.pl';

    
my %ltmpfiles;

# A regexp that matches the tempfile names
$::tempfile_regexp = 'tmp\d+[A-Z][A-Z]?';
    
# Avoid ++, avoid ranges, avoid split //
my $ltempfile_count = 0;
sub ltempfile {
    while(1){
        my $try = (-d "t" ? "t/" : "")."tmp$$";
        my $alpha = _num_to_alpha($ltempfile_count,2);
        last unless defined $alpha;
        $try = $try . $alpha;
 	$ltempfile_count = $ltempfile_count + 1;
        
        # Need to note all the file names we allocated, as a second request may
        # come before the first is created.
        if (!$ltmpfiles{$try} && !-e $try) {
            # We have a winner
            $ltmpfiles{$try} = 1;
            return $try;
	}
    }   
    die "Can't find temporary file name starting \"tmp$$\"";
}
$^I = $^O eq 'VMS' ? '_bak' : '.bak';

plan( tests => 1 );

my @tfiles     = (ltempfile(), ltempfile(), ltempfile());
my @tfiles_bak = map "$_$^I", @tfiles;

END { unlink_all(@tfiles_bak); }

for my $file (@tfiles) {
    runperl( prog => 'print qq(foo\n);', 
             args => ['>', $file] );
}

@ARGV = @tfiles;

while (<>) {
    s/foo/bar/;
}
continue {
    print;
}

is ( runperl( prog => 'print<>;', args => \@tfiles ), 
     "bar\nbar\nbar\n", 
     "file contents properly replaced" );
