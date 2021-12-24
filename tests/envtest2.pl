$|=1;
$\="\n";
my $getenv;
$getenv = "$^X -e 'print \$ENV{PATH}'";
$ENV{TST}='foo';
print "$getenv";
print "run: " . `$getenv`;
