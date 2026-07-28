pipeline {
    agent any

    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/practice-277/spring-petclinic-devops.git'
            }
        }
        stage('build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('sonarqube scan') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('nexus upload') {
            steps {
                nexusArtifactUploader artifacts: [[
                    artifactId: 'spring-petclinic', 
                    classifier: '', 
                    file: 'target/spring-petclinic-4.0.0-SNAPSHOT.jar', 
                    type: 'jar'
                ]], 
                credentialsId: 'nexus', 
                groupId: 'org.springframework.samples', 
                nexusUrl: '13.61.254.215:8081', 
                nexusVersion: 'nexus3', 
                protocol: 'http', 
                repository: 'maven-snapshots', 
                version: '4.0.0-SNAPSHOT'
            }
        }
         stage('Test docker') {
            steps {
                sh 'docker --version'
                sh 'docker ps'
            }
        }
         stage('docker image build') {
            steps {
                sh 'docker build -t aravinth175/spring-petclinic:v${BUILD_NUMBER} .'
            }
        }
         stage('list docker images') {
            steps {
                sh 'docker images'
            }
        }
        stage('Docker Login') {
           steps {
               withCredentials([usernamePassword(
                  credentialsId: 'dockerhub',
                  usernameVariable: 'DOCKER_USER',
                  passwordVariable: 'DOCKER_PASS'
              )]) {
                  sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
              }
           }
        }
        stage('Docker push') {
            steps {
                sh 'docker push aravinth175/spring-petclinic:v${BUILD_NUMBER}'
            }
        }
        stage('Deploy to EKS') {
            steps {
               sh '''
                 aws eks update-kubeconfig --region eu-north-1 --name petclinic-eks

                 kubectl set image deployment/petclinic \
                 petclinic=aravinth175/spring-petclinic:v${BUILD_NUMBER}

                 kubectl rollout status deployment/petclinic
               '''
            }
        }
    }
}