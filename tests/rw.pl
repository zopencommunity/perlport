use File::Temp;
$fh = tempfile();
($fh, $filename) = tempfile;
print $fh;
print $filename;

