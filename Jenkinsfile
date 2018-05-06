node {
    stage('checkout') {
      checkout scm
    }
    stage('prepare') {
      sh "chmod +x hello.sh"
      sh "./hello.sh"
    }
}
