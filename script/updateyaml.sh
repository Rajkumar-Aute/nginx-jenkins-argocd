#!bin/bash
git config user.email rajkumaraute@gmail.com
git config user.name Rajkumar
cat deployment.yaml
sed -i 's+$DOCKERHUB_URL.*+$DOCKERHUB_URL:$BUILD_NUMBER+g' deployment.yaml
cat deployment.yaml
git add .
git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}' && \
git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/nginx-jenkins-argocd.git HEAD:main