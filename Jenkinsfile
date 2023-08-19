def COLOR_MAP = [
    'SUCCESS': 'good',  // good stands for the color green in Slack
    'FAILURE': 'danger' // danger stands for the color red in Slack
]

pipeline {
    agent any
    tools {
        maven "MAVEN3"
        jdk "OracleJDK8"
    }
    options{
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '10', daysToKeepStr: '', numToKeepStr: '10')
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        registryCredential = 'ecr:us-east-1:devops-aws-registry'
        appRegistry = "966996441247.dkr.ecr.us-east-1.amazonaws.com/vprofile"
        vprofileRegistry = "https://966996441247.dkr.ecr.us-east-1.amazonaws.com"
        cluster = "vprofile"      // cluster name
        service = "vprofile-app-svc"   // service name to run the container
    }
  stages {
    stage('Fetch code'){
      steps {
        git branch: 'docker', url: 'https://github.com/owusukd/vprofile-project.git'
      }
    }

    stage('Unit Test'){
      steps {
        sh 'mvn test'
      }
      post {
                success {
                    echo 'Unit test successful'
                }
            }
    }

    stage('Integration Test'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
            post {
                success {
                    echo 'Integration test successful'
                }
            }
        }

    stage ('Checkstyle Analysis'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
            post {
                success {
                    echo 'Generated Checkstyle Report'
                }
            }
        }

    stage('SonarQube analysis') {
        environment {
            scannerHome = tool 'sonar4.7'
        }
        steps {
            withSonarQubeEnv('sonarQube') {
                sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
            }
        }
    }

    stage("Quality Gate") {
        steps {
            timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
            }
        }
    }

    stage('Build App Image') {
        steps {
            script {
                dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", "./Docker-files/app/multistage/")
            }
        }
    }

    stage('Upload App Image') {
        steps{
            script {
                docker.withRegistry( vprofileRegistry, registryCredential ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
                }
            }
        }
    }
     
    stage('Deploy to ECS') {
        steps {
            withAWS(credentials: 'devops-aws-registry') {
                sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
            }
        }
    }

  }
  post { 
        always {
            echo 'Slack Notifications'
            slackSend channel: '#jenkinscicd',
                      color: COLOR_MAP[currentBuild.currentResult], 
                      message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"           
        }
  }
}
