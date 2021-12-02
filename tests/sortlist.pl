#
# This gives different results for ASCII and EBCDIC
# because sort is based off of character positions - so uppercase strings 'float'
# to the end in one case and to the start in the other
#
my @header_files = qw(EXTERN.h INTERN.h XSUB.h av.h config.h cop.h cv.h
                      embed.h embedvar.h form.h gv.h handy.h hv.h hv_func.h intrpvar.h
                      iperlsys.h keywords.h mg.h nostdio.h op.h opcode.h
                      pad.h parser.h patchlevel.h perl.h perlio.h perlsdio.h
                      perlvars.h perly.h pp.h pp_proto.h proto.h
		      regcomp.h regexp.h regnodes.h scope.h sv.h thread.h utf8.h
     		      util.h);

push @header_files,
    $^O eq 'VMS' ? 'vmsish.h' : qw(dosish.h perliol.h time64.h unixish.h);
    
my $header_files = '    return qw(' . join(' ', sort @header_files) . ');';
$header_files =~ s/(?=.{64})   # If line is still overlength
                   (.{1,64})\  # Split at the last convenient space
                  /$1\n              /gx;

print $header_files
