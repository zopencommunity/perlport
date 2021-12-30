use File::Copy;

syscopy("/bin/sh", "/tmp/file") or die "Copy failed: $!";
my $tag = `chtag -p /tmp/file`;
print $tag;
