#!bin/bash
git config user.email rajkumaraute@gmail.com
git config user.name Rajkumar
cat deployment.yaml
sed -i 's+$(DOCKER_REPOSITORY).*+$(DOCKER_REPOSITORY):$BUILD_NUMBER+g' deployment.yaml
cat deployment.yaml
git add .
git commit -m 'Done by Jenkins Job update manifest: ${env.BUILD_NUMBER}'
git push --force https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/argocd-manifest.git {{branch}}