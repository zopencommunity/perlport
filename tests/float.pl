    my $x = 100000.0;
    my $y = int($x * 1e-5) * 1e5; # '0'
    my $z = int($x / 1e+5) * 1e5;  # '100000'
    print "\$y is $y and \$z is $z\n"; # $y is 0 and $z is 100000
