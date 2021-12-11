open(TRY, '>tmpIo_argv1.tmp') or die "Can't open temp file: $!";
close TRY or die "Could not close: $!";
open(TRY, '>tmpIo_argv2.tmp') or die "Can't open temp file: $!";
close TRY or die "Could not close: $!";
@ARGV = ('tmpIo_argv1.tmp', 'tmpIo_argv2.tmp');
$^I = '_bak';   # not .bak which confuses VMS
$/ = undef;
my $i = 11;
while (<>) {
    s/^/ok $i\n/;
    ++$i;
    print;
}
