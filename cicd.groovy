node('linux') 
{
        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'REPO', value: 'perlport'), string(name: 'DESCRIPTION', 'Perl is a family of two high-level, general-purpose, interpreted, dynamic programming languages.' )]
        }
}
