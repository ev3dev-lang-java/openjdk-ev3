node {
    stage('checkout') {
        checkout scm
    }
    stage('Build the jdk cross-compilation OS') {
        sh "docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile system "
    }
    stage("Build the jdk cross-compilation environment") {
        sh "docker build -t ev3dev-lang-java:jdk-autobuild -f scripts/Dockerfile.autorun scripts "
    }
}
