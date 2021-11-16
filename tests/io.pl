open my $fh, '>', '/tmp/my.file'
or die "Can't open my.file for writing: $!";

printf $fh <<'EOM', $0;
Hello World
EOM

close $fh or die "Can't close /tmp/my.file: $!";

