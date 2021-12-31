use strict;
use warnings;

my $Config_PM = "/tmp/out";
my $config_Text = "Hello there\nIt is a wonderful day\n";

my $orig_config_txt = "";
my $orig_heavy_txt = "";
{
    local $/;
    my $fh;
    $orig_config_txt = <$fh> if open $fh, "<", $Config_PM;
}

open CONFIG, ">", $Config_PM or die "Can't open $Config_PM: $!\n";
print CONFIG $config_Text;
close(CONFIG);
