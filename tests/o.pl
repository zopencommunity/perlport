open my $fh, '>', '/tmp/my.out'
or die "Can't open /tmp/my.out for writing: $!";

printf $fh <<'EOM', $0;
Hello World
EOM

close $fh or die "Can't close /tmp/my.out: $!";

