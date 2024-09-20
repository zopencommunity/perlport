node('linux') 
{
        stage ('Poll') {
                checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        doGenerateSubmoduleConfigurations: false,
                        extensions: [],
                        userRemoteConfigs: [[url: 'https://github.com/zopencommunity/perlport.git']]])
        }

        stage('Build') {
                build job: 'Port-Pipeline', parameters: [string(name: 'PORT_GITHUB_REPO', value: 'https://github.com/zopencommunity/perlport.git'), string(name: 'PORT_DESCRIPTION', value: 'Perl is a family of two high-level, general-purpose, interpreted, dynamic programming languages.' ), string(name: 'NODE_LABEL', value: "v2r4")]
        }
}
