@tfiles=("A","B","C");

@ARGV=@tfiles;

while (<>) {
  print $_;
}
