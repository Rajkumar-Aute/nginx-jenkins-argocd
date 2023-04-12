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
                  withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                        sh """
                        cat <<-EOF> deployment.yaml
                        apiVersion: apps/v1
                        kind: Deployment
                        metadata:
                          name: nginx-jenkins-argocd
                          labels:
                            app: nginx-jenkins-argocd
                        spec:
                          replicas: 1
                          selector:
                            matchLabels:
                              app: nginx-jenkins-argocd
                          template:
                            metadata:
                              labels:
                                app: nginx-jenkins-argocd
                            spec:
                              containers:
                                - name: nginx-jenkins-argocd
                                  image: rajkumaraute/nginxcustom:$BUILD_NUMBER
                                  ports:
                                    - containerPort: 80
                        EOF"""
                }
              }
        }
    }
  }
}