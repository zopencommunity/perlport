open my $fh, '<', '/tmp/my.in'
or die "Can't open /tmp/my.in for reading $!";

while(<$fh>) {
  print $_
}

close $fh or die "Can't close /tmp/my.in: $!";

