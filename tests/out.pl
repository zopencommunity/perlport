use strict;
use warnings;

my $config_PM = "/tmp/out";
my $config_Text = "Hello there\nIt is a wonderful day\n";
open CONFIG, ">", $config_PM or die "Can't open $config_PM: $!\n";
print CONFIG $config_Text;
close(CONFIG);
