pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub') // store docker hub username and password/token
    DOCKERHUB_URL = "rajkumaraute/nginxcustom" // docker hub url username and image name 
  }
  stages {
    stage('clone reposotory'){
        steps {
        checkout scm
        }
    }
    stage('Build') {
      steps {
        sh 'docker build -t $DOCKERHUB_URL:$BUILD_NUMBER .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push $DOCKERHUB_URL:$BUILD_NUMBER'
      }
    }
    stage('update deployment.yaml file') {
        steps{
               script {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                      sh "chmod +x -R ${env.WORKSPACE}"
                      sh "pwd"
                      sh "./script/updateyaml.sh"
                        //def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                        //sh "git config user.email rajkumaraute@gmail.com"
                        //sh "git config user.name Rajkumar"
                        //sh "cat deployment.yaml"
                        //sh "sed -i 's+$DOCKERHUB_URL.*+$DOCKERHUB_URL:$BUILD_NUMBER+g' deployment.yaml"
                        //sh "cat deployment.yaml"
                        //sh "git add ."
                        //sh "git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}'"
                        //sh "git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/nginx-jenkins-argocd.git HEAD:main"
      
                }
        
        }
    }
 }
  }
}
}