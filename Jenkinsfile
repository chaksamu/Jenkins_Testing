pipeline {
    agent any

	options {
		buildDiscarder(logRotator(numToKeepStr: '10'))
		timestamps()
		timeout(time: 1, unit: 'HOURS')
	}
	
    stages {
		stage('Checkout the code'){
		    steps{
				cleanWs()
				script{
					git 'https://github.com/chaksamu/Jenkins_Testing'
					
					//pom = readMavenPom file: './pom.xml'
					//version = pom.version.toString().replace("\${scm.revision}", "")
					SVN_REVISION="1986"
					version="1.0"
					build_user_id="chaksamu"
				}
			}
		}
		stage('Create Tar') {				
			steps {
				echo "User ${build_user_id} started the build"
				sh "chmod +x ./build.sh"
				sh "./build.sh chi_ui_imn_conf_prod-${version}.${SVN_REVISION}"
			}
		}
		stage('Upload tar') {				
			steps {
			    script{
				NEXUS_URL="http://localhost:8081"
				SYN_DB="tools"
				NEX_LOC="imn_config_mgmt/chi_ui_imn_conf_prod"
				sh "curl -v -n --upload-file chi_ui_imn_conf_prod-${version}.${scmVars.SVN_REVISION}.tar.gz ${NEXUS_URL}/repository/${SYN_DB}/${NEX_LOC}/ -u 'admin:chaksamu'"
			    }
			}
		}
	}
	post {
		always {
			echo 'Mail has been sent to chaksamu@gmail.com'
		}
	}
}
