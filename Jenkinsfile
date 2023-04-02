pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub') // docker hub username and password/token has been created in Jenkins global secret with name "dockerhub"
    dockerhub_url = "rajkumaraute/nginxcustom" // dockerhub account name and image name defined
    //dockerhub_url = credentials('DOCKER_URL') # can be added in global secret
    GITHUB = credentials('github')


  }
  stages {
    stage('clone reposotory'){
        steps {
        checkout scm
        }
    }
    stage('Build') {
      steps {
        sh 'docker build -t $dockerhub_url:$BUILD_NUMBER .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push $dockerhub_url:$BUILD_NUMBER'
      }
    }
    stage('update deployment.yaml file') {
        steps{
            script {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        //def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                        sh "git config user.email rajkumaraute@gmail.com"
                        sh "git config user.name Rajkumar"
                        sh "cat deployment.yaml"
                        sh "sed -i 's+$dockerhub_url.*+dockerhub_url:$BUILD_NUMBER+g' deployment.yaml"
                        sh "cat deployment.yaml"
                        sh "git add ."
                        sh "git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}'"
                        sh "git push --force https://${GITHUB_USR}:${GITHUB_PSW}@github.com/${GITHUB_USR}/nginx-jenkins-argocd.git HEAD:main"
      
                }
        
        }
    }
 }
  }
}
}