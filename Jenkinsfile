pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    GIT_USERNAME = credentials('GIT_USERNAME')
    GIT_PASSWORD = credentials('GIT_PASSWORD')


  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t rajkumaraute/nginxcustom:$BUILD_NUMBER .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push rajkumaraute/nginxcustom:$BUILD_NUMBER'
      }
    }
    stage('update deployment.yaml file') {
        steps{
            git url: "https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/argocd-manifest.git, branch: 'main'"
            sh "chmod +x -R ${env.WORKSPACE}"
            sh "chmod +x ./script/updateyaml.sh"
            sh "cat ./script/updateyaml.sh"
            sh "./script/updateyaml.sh"
            //sh "git config user.email rajkumaraute@gmail.com"
            //sh "git config user.name Rajkumar"
            //sh "cat deployment.yaml"
            //sh "sed -i 's+$(DOCKER-REPOSITORY).*+$(DOCKER-REPOSITORY):$BUILD_NUMBER+g' deployment.yaml"
            //sh "cat deployment.yaml"
            //sh "git add ."
            //sh "git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}'"
            //sh "git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/argocd-manifest.git {{branch}}"
        }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}
/*
pipeline(
    environment {
        DOCKERHUB_CREDENTIALS = credentials ('dockerhub')
    }
    agnet any
       
    stages {
        stage('SCM Checkout') {
            steps{
                git 'https://github.com/Rajkumar-Aute/nginx-jenkins-argocd.git'
            }
        }
        stage('Build docker image'){
            steps{
                sh 'docker build -t rajkumaraute/nginxcustom:$BUILD_NUMBER .'
            }
        }
        stage('Login to dockerhub'){

            steps{
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Docker image push'){
            steps{
                sh 'docker push rajkumaraute/nginxcustom:$BUILD_NUMBER'
            }
        }
)
post {
    always {
        sh 'docker logout'
    }
}

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
*/