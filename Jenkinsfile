pipeline {
    agent {
        label 'build && ( linux || sw.os.linux ) && docker'
    }
    stages {
        stage('checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build cross-compilation OS') {
            steps {
                sh "docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile system "
            }
        }
        stage("Build cross-compilation environment") {
            steps {
                sh "docker build -t ev3dev-lang-java:jdk-build -f scripts/Dockerfile.autorun scripts "
            }
        }
        stage("Build") {
            steps {
                sh "docker run --rm -it -v $PWD/build:/build -e JDKVER='10' -e JDKVM='client' -e AUTOBUILD='1' ev3dev-lang-java:jdk-build"
            }
        }
    }
}
