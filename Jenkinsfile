node {
    agent {
        label 'build && ( linux || sw.os.linux ) && ( x86_64 || x64 )'
    }
    stage('checkout') {
        checkout scm
    }
    stage('Build cross-compilation OS') {
        sh "docker build -t ev3dev-lang-java:jdk-stretch -f system/Dockerfile system "
    }
    stage("Build cross-compilation environment") {
        sh "docker build -t ev3dev-lang-java:jdk-autobuild -f scripts/Dockerfile.autorun scripts "
    }
    stage("Build") {
        sh "sudo docker run --rm -it -v $PWD/build:/build -e JDKVER='10' -e JDKVM='client' ev3dev-lang-java:jdk-autobuild"
    }
}
