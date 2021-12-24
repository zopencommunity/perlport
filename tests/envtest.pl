$|=1;
$\="\n";
my $getenv;
$getenv = "$^X -e 'print \$ENV{TST}'";
$ENV{TST}='foo';
print "$getenv";
print "run: " . `$getenv`;
