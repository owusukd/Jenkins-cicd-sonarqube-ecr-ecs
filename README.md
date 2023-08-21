# Jenkins-cicd-sonarqube-ecr-ecs
In this project, I orchestrate a java application on AWS ECS. 
The application is a standalone monolithic java application. 
In this project I provisioned a Jenkins server and a SonarQube server for code analysis with defined quality gate. 
I also, created slack notification channel for the project for build notifications. 
The whole process involved in fetching the code from github, performing code anaalysis, building the a docker image of the app, uploading it to AWS ECR and deploying it on AWS ECS was automated using Jenkins. 

# Build plugins for Jenkins
* Sonarqube
* git
* Pipeline Maven Integration
* BuildTimestamp
* Pipeline utility steps
* Slack notification
* ECR
* Docker pipeline
* CloudBees docker build and publish
* AWS sdk, aws steps


Java Source code by Imran Teli.
