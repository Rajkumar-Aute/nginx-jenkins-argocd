pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
   // GIT_USERNAME = credentials('GIT_USERNAME')
   // GIT_PASSWORD = credentials('GIT_PASSWORD')
    DOCKER_REPOSITORY = credentials('DOCKER_REPOSITORY')


  }
  stages {
    stage('clone reposotory'){
        steps {
        checkout scm
        }
    }
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
    //        git url: "https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/argocd-manifest.git, {branch}"
    //        sh "chmod +x -R ${env.WORKSPACE}"
    //        sh "chmod +x ./script/updateyaml.sh"
    //        sh "cat ./script/updateyaml.sh"
    //        sh "./script/updateyaml.sh"
    //        //sh "git config user.email rajkumaraute@gmail.com"
    //        //sh "git config user.name Rajkumar"
    //        //sh "cat deployment.yaml"
    //        //sh "sed -i 's+$(DOCKER-REPOSITORY).*+$(DOCKER-REPOSITORY):$BUILD_NUMBER+g' deployment.yaml"
    //        //sh "cat deployment.yaml"
    //        //sh "git add ."
    //        //sh "git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}'"
    //        //sh "git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/argocd-manifest.git {{branch}}"
    //    
      
            script {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        //def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                        sh "git config user.email rajkumaraute@gmail.com"
                        sh "git config user.name Rajkumar"
                        sh "cat deployment.yaml"
                        sh "sed -i 'sed -i 's+rajkumaraute/nginxcustom.*+rajkumaraute/nginxcustom:$BUILD_NUMBER+g' deployment.yaml"
                        sh "cat deployment.yaml"
                        sh "git add ."
                        sh "git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}'"
                        sh "git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/argocd-manifest.git HEAD:main"
      
                }
        
        }
    }
 }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}