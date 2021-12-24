#!./perl
#
# Tests for Perl run-time environment variable settings
#
# $PERL5OPT, $PERL5LIB, etc.

BEGIN {
    chdir 't' if -d 't';
    @INC = '../lib';
    require Config; import Config;
    require './test.pl';
    skip_all_without_config('d_fork');
}

plan tests => 106;

my $STDOUT = tempfile();
my $STDERR = tempfile();
my $PERL = './perl';
my $FAILURE_CODE = 119;

delete $ENV{PERLLIB};
delete $ENV{PERL5LIB};
delete $ENV{PERL5OPT};
delete $ENV{PERL_USE_UNSAFE_INC};


# Run perl with specified environment and arguments, return (STDOUT, STDERR)
sub runperl_and_capture {
  local *F;
  my ($env, $args) = @_;

  local %ENV = %ENV;
  delete $ENV{PERLLIB};
  delete $ENV{PERL5LIB};
  delete $ENV{PERL5OPT};
  delete $ENV{PERL_USE_UNSAFE_INC};
  my $pid = fork;
  return (0, "Couldn't fork: $!") unless defined $pid;   # failure
  if ($pid) {                   # parent
    wait;
    return (0, "Failure in child.\n") if ($?>>8) == $FAILURE_CODE;

    open my $stdout, '<', $STDOUT
	or return (0, "Couldn't read $STDOUT file: $!");
    open my $stderr, '<', $STDERR
	or return (0, "Couldn't read $STDERR file: $!");
    local $/;
    # Empty file with <$stderr> returns nothing in list context
    # (because there are no lines) Use scalar to force it to ''
    return (scalar <$stdout>, scalar <$stderr>);
  } else {                      # child
    for my $k (keys %$env) {
      $ENV{$k} = $env->{$k};
    }
    open STDOUT, '>', $STDOUT or exit $FAILURE_CODE;
    open STDERR, '>', $STDERR and do { exec $PERL, @$args };
    # it did not work:
    print STDOUT "IWHCWJIHCI\cNHJWCJQWKJQJWCQW\n";
    exit $FAILURE_CODE;
  }
}

sub try {
  my ($env, $args, $stdout, $stderr) = @_;
  my ($actual_stdout, $actual_stderr) = runperl_and_capture($env, $args);
  local $::Level = $::Level + 1;
  my @envpairs = ();
  for my $k (sort keys %$env) {
    push @envpairs, "$k => $env->{$k}";
  }
  my $label = join(',' => (@envpairs, @$args));
  if (ref $stdout) {
    ok ( $actual_stdout =~/$stdout/, $label . ' stdout' );
  } else {
    is ( $actual_stdout, $stdout, $label . ' stdout' );
  }
  if (ref $stderr) {
    ok ( $actual_stderr =~/$stderr/, $label . ' stderr' );
  } else {
    is ( $actual_stderr, $stderr, $label . ' stderr' );
  }
}

#  PERL5OPT    Command-line options (switches).  Switches in
#                    this variable are taken as if they were on
#                    every Perl command line.  Only the -[DIMUdmtw]
#                    switches are allowed.  When running taint
#                    checks (because the program was running setuid
#                    or setgid, or the -T switch was used), this
#                    variable is ignored.  If PERL5OPT begins with
#                    -T, tainting will be enabled, and any
#                    subsequent options ignored.

try({PERL5OPT => '-w'}, ['-e', 'print $::x'],
    "", 
    qq{Name "main::x" used only once: possible typo at -e line 1.\nUse of uninitialized value \$x in print at -e line 1.\n});
