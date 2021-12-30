use Encode::EBCDIC;

my $textfile = shift or die "Usage $0 <filename>\n";

open my $fh, '<:encoding(cp1047)', $textfile or die "Unable to open";
while (<$fh>) {
  print;
}
