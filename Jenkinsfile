node {
    def app
    stage ('Clone reposotory' ) {
        checkout scm
    }
    stage('Build image') {
        app = docker.build(rajkumaraute/nginxcustom)
    }
    stage('Push image') {
        // dockerhub is a jenkins secret with dockerhub username and password (jenkins/manage-jenkins/credentials/system/global-credentisls)
        docker.withRegistry('https://registory.hub.docker.com','dockerhub') { 
            app.push("${env.BUILD_NUMBER}")
        }
    }
    stage('Trigger manifestupdate') {
        echo "ttiggering updatemanifestjob"
        build job: 'updatemanifest', parameters: [string(name:'DOCKERTAG', value: env.BUILD_NUMBER)]
    }
     stage('Update GITHUB') {
            script {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    //withCredentials([gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default')]) {
   
                    withCredentials([usernamePassword(credentialsId: 'devopsodia-github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        //def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                        sh "git config user.email rajkumaraute@gmail.com"
                        sh "git config user.name Rajkumar"
                        sh "cat deployment.yaml"
                        sh "sed -i 's+eks-url.*:${DOCKERTAG}+g' deployment.yaml"
                        sh "cat deployment.yaml"
                        sh "git add ."
                        sh "git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}'"
                        sh "git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/argocd-manifest.git {{branch}}"
      }
                }
    }
     }




}