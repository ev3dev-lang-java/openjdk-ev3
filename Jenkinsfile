pipeline {
    agent {
        label '( linux || sw.os.linux ) && ( x64 || x86_64 || x86 || hw.arch.x86 ) && ( docker || sw.tool.docker ) && !test'
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
                sh "docker build -t ev3dev-lang-java:jdk-build -f scripts/Dockerfile scripts "
            }
        }
        stage("Build") {
            steps {
                //sh "rm -rf    /tmp/ev3dev-lang-java"
                //sh "mkdir -p  /tmp/ev3dev-lang-java"
                //sh "chmod 777 /tmp/ev3dev-lang-java"
                //sh "docker run --rm -v /tmp/ev3dev-lang-java:/build -e JDKVER='10' -e JDKVM='client' -e AUTOBUILD='1' ev3dev-lang-java:jdk-build"
            }
        }
    }
}
