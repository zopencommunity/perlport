#!./perl
use strict;
chdir "$ENV{PERL_ENV}";
chdir 't' if -d 't';
require "./test.pl";

$^I = $^O eq 'VMS' ? '_bak' : '.bak';

$File::Temp::KEEP_ALL=1;
plan( tests => 1 );

my @tfiles     = (tempfile( UNLINK => 0), tempfile(), tempfile());
my @tfiles_bak = map "$_$^I", @tfiles;

for my $file (@tfiles) {
  print $file . "\n";
}

END { unlink_all(@tfiles_bak); }

for my $file (@tfiles) {
    runperl( prog => 'print qq(foo\n);', 
             args => ['>', $file] );
}

@ARGV = @tfiles;

for my $file (@tfiles) {
  open(FH, '<', $file) or die $!;
  while (<FH>) {
    print "before" . $_;
  }
  close(FH) 
}

while (<>) {
    s/foo/bar/;
}

for my $file (@tfiles) {
  open(FH, '<', $file) or die $!;
  while (<FH>) {
    print "after" . $_;
  }
  close(FH) 
}

is ( runperl( prog => 'print<>;', args => \@tfiles ), 
     "bar\nbar\nbar\n", 
     "file contents properly replaced" );
