@Library('GlobalSharedLibrary') _
//setWebExNotification()

pipeline {
    agent { label "dal01p-gen-jen-adm003.mgmt.syniverse.com" }

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
					scmVars = (checkout([$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', excludedRegions: '', excludedRevprop: '', 
					excludedUsers: '', filterChangelog: false, ignoreDirPropChanges: false, includedRegions: '',
					locations: [[cancelProcessOnExternalsFail: true, credentialsId: 'svn_build_user', depthOption: 'infinity',
					ignoreExternalsOption: true, local: '.',
					remote: "https://ba1p-gen-ias-vcs001.syniverse.com/svn/imn_ps_imp/imn_config_mgmt/chi_ui_imn_conf/prod/trunk/"]],
					quietOperation: true, workspaceUpdater: [$class: 'UpdateUpdater']]))
					
					scmRevision = scmVars.SVN_REVISION
					echo "SCM URL is is ${scmVars.SVN_URL}"
					
					//pom = readMavenPom file: './pom.xml'
					//version = pom.version.toString().replace("\${scm.revision}", "")

					version="1.0"
				}
			}
		}
		stage('Get Build User'){
			steps{
			    script{
			        build_user_id = getBuildUser(scmVars.SVN_URL)
			    }
			}
		}
		stage('Create Tar') {				
			steps {
				echo "User ${build_user_id} started the build"
				sh "chmod +x ./build.sh"
				sh "./build.sh dal_fe_imn_conf_prod-${version}.${scmVars.SVN_REVISION}"
			}
		}
		stage('Upload tar') {				
			steps {
			    script{
                                //nexusPublisher nexusInstanceId: 'syniverse-rm', nexusRepositoryId: 'syn-imn-repo', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: "dal_fe_imn_conf_prod-${version}.${scmVars.SVN_REVISION}.tar.gz"]], mavenCoordinate: [artifactId: 'dal_fe_imn_conf_prod', groupId: 'com.syniverse.imn.conf', packaging: 'tar.gz', version: "${version}.${scmVars.SVN_REVISION}"]]]

				NEXUS_URL="https://nexusrm.syniverse.com"
				SYN_DB="tools"
				NEX_LOC="imn_config_mgmt/dal_fe_imn_conf_prod"
				sh "curl -v -n --upload-file dal_fe_imn_conf_prod-${version}.${scmVars.SVN_REVISION}.tar.gz ${NEXUS_URL}/repository/${SYN_DB}/${NEX_LOC}/ -u 'jenkinsadm:Jenk!ns@dm\$2'"
			    }
			}
		}
	}
	post {
		always {
			sendNotification(getBuildUser(scmVars.SVN_URL), 'A2P-India', currentBuild.currentResult, 'TeamVenture@syniverse.com')
			echo 'Mail has been sent to TeamVenture@syniverse.com'
		}
	}
}
