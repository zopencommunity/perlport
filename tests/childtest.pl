$|=1;
$\="\n";
my $getenv;
$getenv = "$^X -e 'print qq(hello)'";
print "run: " . `$getenv`;
