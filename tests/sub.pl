sub chtag { 
  my $tag = `chtag @_`;
  my $rc = $?;
  if ($rc > 0) {
    print STDERR $tag;
  }
  return $rc;
}

`touch /tmp/myfile` if (1);
$tag="-r";
$file="/tmp/myfile";
$rc = chtag($tag, $file);
print $rc if ($rc > 0);
$rc = chtag("-t", "-cISO8859-1", "/tmp/myfile");
print $rc if ($rc > 0);
$rc = chtag("-t", "-cIBM-1047", "/tmp/myfile");
print $rc if ($rc > 0);
