#eval "chop (\$osname = `sh -c 'uname -nmsr 2>&1'`)";
eval "chop (\$osname = `uname -nmsr 2>&1`)";
print $osname;
