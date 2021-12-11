# (1) check for the number of command-line arguments entered  
$number_args = $#ARGV + 1;  
if ($number_args != 2) {  
    print "Wrong entry. Please enter your full name.\n";  
    exit;  
}  
# (2) if two command line arguments received,  
$firstName=$ARGV[0];  
$lastName=$ARGV[1];  
print "Welcome $firstName $lastName at JavaTpoint.\n";  

while(<>) {
  print;
}
