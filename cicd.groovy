node('linux') 
{
        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'REPO', value: 'perlport'), string(name: 'DESCRIPTION', 'perlport' )]
        }
}
