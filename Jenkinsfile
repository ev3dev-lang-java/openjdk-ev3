pipeline {
    agent {
        label 'build && ( linux || sw.os.linux ) && ( x86_64 || x64 )'
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
                sh "docker build -t ev3dev-lang-java:jdk-autobuild -f scripts/Dockerfile.autorun scripts "
            }
        }
        stage("Build") {
            steps {
                sh "docker run --rm -it -v $PWD/build:/build -e JDKVER='10' -e JDKVM='client' ev3dev-lang-java:jdk-autobuild"
            }
        }
    }
}
