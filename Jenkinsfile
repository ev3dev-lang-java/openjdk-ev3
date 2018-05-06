node {
    stage('checkout') {
      checkout scm
    }
    stage('prepare') {
      sh "chmod +x hello.sh"
      sh "./hello.sh"
      sh "docker build -t ev3dev-lang-java:jdk-build   -f scripts/Dockerfile scripts"
    }
}
