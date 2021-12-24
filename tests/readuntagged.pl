open my $fh, '<', '/usr/include/errno.h'
or die "Can't open /usr/include/errno.h for reading $!";

while(<$fh>) {
  print $_
}

close $fh or die "Can't close /usr/include/errno.h: $!";
