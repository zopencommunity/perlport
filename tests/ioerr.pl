my @letters = qw(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z);

# Avoid ++ -- ranges split negative numbers
sub _num_to_alpha{
    my($num,$max_char) = @_;
    return unless $num >= 0;
    my $alpha = '';
    my $char_count = 0;
    $max_char = 0 if $max_char < 0;
        
    while( 1 ){
        $alpha = $letters[ $num % 26 ] . $alpha;
        $num = int( $num / 26 );
        last if $num == 0;
 	$num = $num - 1;

        # char limit
        next unless $max_char;
        $char_count = $char_count + 1;
        return if $char_count == $max_char;
    }   
    return $alpha;
}

sub tempfile {
    while(1){
        my $try = (-d "t" ? "t/" : "")."tmp$$";
        my $alpha = _num_to_alpha($tempfile_count,2);
        last unless defined $alpha;
        $try = $try . $alpha;
        $tempfile_count = $tempfile_count + 1;

        # Need to note all the file names we allocated, as a second request may
        # come before the first is created.
        if (!$tmpfiles{$try} && !-e $try) {
            # We have a winner
            $tmpfiles{$try} = 1;
            return $try;
	}
    }   
    die "Can't find temporary file name starting \"tmp$$\"";
}

my $X = tempfile();
my $Y = tempfile();

print $X "Hi Out\n";
print $Y "Hi Err\n";
