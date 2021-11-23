use feature qw(say);

say "basic array print";
@files = ("A","B","C");
foreach $f (@files) {
  say "$f";
}

say "before loop";
foreach (glob('scripts/pod*.PL')) {
    my $temp = $_;
    say "file: $temp";
}
say "after loop";
