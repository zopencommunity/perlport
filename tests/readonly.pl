use strict;
use warnings;

my $File = "/tmp/out";
local $/;
my $fh;
my $text = <$fh> if open $fh, "<", $File;

open $fh, ">", $File;
